# In-App Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans (the user prefers inline execution, no subagents) to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let Carburo check GitHub Releases for a newer version and, in-app, download the release APK (progress bar) and launch the Android system installer — with a throttled startup check and a manual check in Settings.

**Architecture:** Feature-first + layered (`features/ → domain/ ← data/`). Pure, fully-tested logic in `domain/` (`AppRelease`, `isNewerVersion`, `parseLatestRelease`, `shouldCheck`). I/O behind a domain interface in `data/` (`GitHubUpdateService` via `http` + `open_filex`; `UpdatePrefs` via `shared_preferences`). A focused `UpdateBanner` widget + a Settings tile drive the UI. Modeled on GitOpen's `GitHubReleaseUpdater`.

**Tech Stack:** Flutter (stable 3.44.x), Riverpod 3 (code-gen), `http`, `open_filex`, `shared_preferences`, `package_info_plus`, `path_provider`. Tests: `flutter_test` + `mocktail` + `SharedPreferences.setMockInitialValues`.

**Spec:** `docs/superpowers/specs/2026-06-23-in-app-update-design.md`

## Global Constraints

- **Local-first / best-effort:** the startup check is silent, throttled to **once per day**, and wrapped so any failure is swallowed (like the existing `_initNotifications`). The network is touched only for the update check and the user-initiated download.
- **Freezed/Riverpod conventions:** Riverpod 3 code-gen (`@riverpod` / `@Riverpod(keepAlive: true)`, `Ref ref`, `part 'file.g.dart';`, generated `<name>Provider`). `AsyncValue` → use `.asData?.value`, never `valueOrNull`. Regenerate after provider changes: `dart run build_runner build --delete-conflicting-outputs`.
- **Lint:** bare `flutter analyze` (whole project) must be clean before pushing. Generated `*.g.dart` are analyzer-excluded — never hand-edit.
- **Version bump:** this PR touches `lib/` + `pubspec.yaml` → bump `0.4.0+5 → 0.5.0+6`. Required CI checks: `build-and-test (ubuntu-latest)`, `version-check`, `build-apk`.
- **Git identity:** `zN3utr4l <zN3utr4l@users.noreply.github.com>`. Every commit ends with:
  `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`
- **Branch:** all work on `feature/in-app-update` (already created; spec committed there).
- ⚠️ **Depends on PR #4** (R8/ML Kit CD fix): a release build off `main` fails R8 until #4 merges. Merge #4 first, then rebase this branch onto `main` before merging this PR (this feature adds no R8-sensitive deps, so its own CI is unaffected, but its CD release would still hit the ML Kit R8 error otherwise).
- **TDD:** failing test → run (fail) → minimal impl → run (pass) → commit. Frequent commits.

## File Structure

```
pubspec.yaml                                       # +open_filex +shared_preferences +package_info_plus; bump 0.5.0+6
android/app/src/main/AndroidManifest.xml           # +REQUEST_INSTALL_PACKAGES
lib/src/
  domain/
    models/app_release.dart                        # NEW: AppRelease + isNewerVersion + parseLatestRelease + shouldCheck (pure)
    services/update_service.dart                   # NEW: abstract UpdateService + UpdateCheckException
  data/
    update/github_update_service.dart              # NEW: impl (http download + OpenFilex install)
    update/update_prefs.dart                        # NEW: shared_preferences throttle wrapper
  features/updates/
    update_providers.dart                          # NEW: providers + AvailableUpdate notifier + startupUpdateCheck + showUpdateDownloadDialog
    update_banner.dart                             # NEW: UpdateBanner ConsumerWidget
  providers.dart                                    # MODIFY: updateService/updatePrefs/currentVersion providers
  app/app.dart                                      # MODIFY: best-effort throttled startup check
  app/router.dart                                   # MODIFY: _HomeShell → ConsumerWidget + UpdateBanner
  features/settings/settings_screen.dart            # MODIFY: "Aggiornamenti" tile + manual check
test/
  domain/app_release_test.dart                      # NEW: pure
  data/github_update_service_test.dart              # NEW: mock http
  data/update_prefs_test.dart                       # NEW: setMockInitialValues
  features/update_banner_test.dart                  # NEW: widget (banner)
```

---

### Task 1: `AppRelease` + pure functions (domain)

**Files:**
- Create: `lib/src/domain/models/app_release.dart`
- Test: `test/domain/app_release_test.dart`

**Interfaces:**
- Produces:
  - `class AppRelease { const AppRelease({required this.version, required this.apkUrl, required this.sizeBytes}); final String version; final String apkUrl; final int sizeBytes; }`
  - `bool isNewerVersion(String candidate, String current)`
  - `AppRelease? parseLatestRelease(Map<String, dynamic> json)`
  - `bool shouldCheck(DateTime? lastCheck, DateTime now, Duration interval)`

- [ ] **Step 1: Write the failing test**

```dart
// test/domain/app_release_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/models/app_release.dart';

void main() {
  group('isNewerVersion', () {
    test('higher major/minor/patch is newer', () {
      expect(isNewerVersion('0.5.0', '0.4.0'), isTrue);
      expect(isNewerVersion('1.0.0', '0.9.9'), isTrue);
      expect(isNewerVersion('0.4.1', '0.4.0'), isTrue);
    });
    test('equal or older is not newer', () {
      expect(isNewerVersion('0.4.0', '0.4.0'), isFalse);
      expect(isNewerVersion('0.3.9', '0.4.0'), isFalse);
    });
    test('tolerates a leading v and missing parts', () {
      expect(isNewerVersion('v0.5', '0.4.0'), isTrue);
      expect(isNewerVersion('0.4', '0.4.0'), isFalse);
    });
  });

  group('parseLatestRelease', () {
    test('picks the .apk asset and strips the v from the tag', () {
      final r = parseLatestRelease({
        'tag_name': 'v0.5.0',
        'assets': [
          {'name': 'sha256.txt', 'browser_download_url': 'https://x/s.txt', 'size': 1},
          {'name': 'carburo-v0.5.0.apk', 'browser_download_url': 'https://x/c.apk', 'size': 1234},
        ],
      });
      expect(r, isNotNull);
      expect(r!.version, '0.5.0');
      expect(r.apkUrl, 'https://x/c.apk');
      expect(r.sizeBytes, 1234);
    });
    test('null when no tag or no apk asset', () {
      expect(parseLatestRelease({'assets': []}), isNull);
      expect(parseLatestRelease({'tag_name': 'v0.5.0', 'assets': []}), isNull);
    });
  });

  group('shouldCheck', () {
    final now = DateTime(2026, 6, 23, 12);
    test('true when never checked', () {
      expect(shouldCheck(null, now, const Duration(days: 1)), isTrue);
    });
    test('true when older than the interval', () {
      expect(shouldCheck(now.subtract(const Duration(days: 2)), now, const Duration(days: 1)), isTrue);
    });
    test('false when within the interval', () {
      expect(shouldCheck(now.subtract(const Duration(hours: 2)), now, const Duration(days: 1)), isFalse);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/domain/app_release_test.dart`
Expected: FAIL — `app_release.dart` / symbols not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/src/domain/models/app_release.dart

/// A GitHub release relevant to self-update: its version (tag without `v`) and
/// the downloadable APK.
class AppRelease {
  const AppRelease({
    required this.version,
    required this.apkUrl,
    required this.sizeBytes,
  });

  final String version;
  final String apkUrl;
  final int sizeBytes;
}

/// True when [candidate] is strictly newer than [current] (semver MAJOR.MINOR.
/// PATCH, numeric). Tolerates a leading `v` and missing parts (treated as 0).
bool isNewerVersion(String candidate, String current) {
  final c = _parse(candidate);
  final v = _parse(current);
  for (var i = 0; i < 3; i++) {
    if (c[i] > v[i]) return true;
    if (c[i] < v[i]) return false;
  }
  return false;
}

List<int> _parse(String version) {
  final clean = version.startsWith('v') ? version.substring(1) : version;
  final parts = clean.split('.');
  return List.generate(
    3,
    (i) => i < parts.length ? (int.tryParse(parts[i]) ?? 0) : 0,
  );
}

/// Parses GitHub's `releases/latest` JSON into an [AppRelease]: tag (without
/// `v`) + the first asset whose name ends in `.apk`. Null if no tag or no APK.
AppRelease? parseLatestRelease(Map<String, dynamic> json) {
  final tag = json['tag_name'] as String?;
  if (tag == null) return null;
  final version = tag.startsWith('v') ? tag.substring(1) : tag;
  final assets = (json['assets'] as List<dynamic>?) ?? const [];
  for (final raw in assets) {
    if (raw is! Map<String, dynamic>) continue;
    final name = raw['name'] as String?;
    final url = raw['browser_download_url'] as String?;
    if (name == null || url == null) continue;
    if (name.toLowerCase().endsWith('.apk')) {
      return AppRelease(
        version: version,
        apkUrl: url,
        sizeBytes: (raw['size'] as int?) ?? 0,
      );
    }
  }
  return null;
}

/// Throttle: true when [lastCheck] is null or older than [interval] before [now].
bool shouldCheck(DateTime? lastCheck, DateTime now, Duration interval) {
  if (lastCheck == null) return true;
  return now.difference(lastCheck) >= interval;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/domain/app_release_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/src/domain/models/app_release.dart test/domain/app_release_test.dart
git commit -m "feat: add AppRelease + version/parse/throttle pure helpers

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 2: Dependencies + Android permission + version bump

**Files:**
- Modify: `pubspec.yaml`
- Modify: `android/app/src/main/AndroidManifest.xml`

**Interfaces:** none (config). Deliverable: resolves, analyzes clean.

- [ ] **Step 1: Add the packages**

Run:
```bash
flutter pub add open_filex shared_preferences package_info_plus
```
Expected: the three become direct deps at their latest stable versions; `flutter pub get` succeeds.

- [ ] **Step 2: Bump the app version**

Edit `pubspec.yaml`: change `version: 0.4.0+5` to `version: 0.5.0+6`.

- [ ] **Step 3: Add the install permission to the manifest**

Edit `android/app/src/main/AndroidManifest.xml` — add inside `<manifest>`, with the other `<uses-permission>` lines:

```xml
    <!-- Install the downloaded APK via the system installer (in-app update). -->
    <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES"/>
```

- [ ] **Step 4: Verify it analyzes**

Run: `flutter analyze`
Expected: no new issues. (`open_filex` ships its own FileProvider for sharing the APK; no app-side provider needed.)

- [ ] **Step 5: Commit**

```bash
git add pubspec.yaml pubspec.lock android/app/src/main/AndroidManifest.xml
git commit -m "build: add open_filex, shared_preferences, package_info_plus; install perm; bump 0.5.0

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 3: `UpdateService` interface + `GitHubUpdateService`

**Files:**
- Create: `lib/src/domain/services/update_service.dart`
- Create: `lib/src/data/update/github_update_service.dart`
- Test: `test/data/github_update_service_test.dart`

**Interfaces:**
- Consumes: `AppRelease`, `isNewerVersion`, `parseLatestRelease` (Task 1).
- Produces:
  - `abstract class UpdateService { Future<AppRelease?> checkForUpdate(String currentVersion); Future<void> downloadAndInstall(AppRelease release, {void Function(double progress)? onProgress}); }`
  - `class UpdateCheckException implements Exception { UpdateCheckException(this.statusCode); final int statusCode; }`
  - `class GitHubUpdateService implements UpdateService { GitHubUpdateService({http.Client? client}); }`

- [ ] **Step 1: Create the interface**

```dart
// lib/src/domain/services/update_service.dart
import '../models/app_release.dart';

/// Thrown when the update check cannot reach GitHub (non-200), so the UI never
/// reports a failed check as "up to date".
class UpdateCheckException implements Exception {
  UpdateCheckException(this.statusCode);
  final int statusCode;

  @override
  String toString() => statusCode == 403
      ? 'Limite richieste GitHub raggiunto (HTTP 403) — riprova più tardi.'
      : 'Controllo aggiornamenti non riuscito (HTTP $statusCode)';
}

abstract class UpdateService {
  /// The latest release when newer than [currentVersion], else null. Throws
  /// [UpdateCheckException] on a failed check (non-200).
  Future<AppRelease?> checkForUpdate(String currentVersion);

  /// Downloads the APK reporting 0..1 [onProgress], then launches the system
  /// installer. Throws on download/open failure.
  Future<void> downloadAndInstall(
    AppRelease release, {
    void Function(double progress)? onProgress,
  });
}
```

- [ ] **Step 2: Write the failing test**

```dart
// test/data/github_update_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:carburo/src/data/update/github_update_service.dart';
import 'package:carburo/src/domain/services/update_service.dart';

class _MockClient extends Mock implements http.Client {}

const _body = '''
{"tag_name":"v0.5.0","assets":[
  {"name":"carburo-v0.5.0.apk","browser_download_url":"https://x/c.apk","size":99}
]}''';

void main() {
  setUpAll(() => registerFallbackValue(Uri()));

  test('returns the release when newer', () async {
    final client = _MockClient();
    when(() => client.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(_body, 200));
    final svc = GitHubUpdateService(client: client);
    final r = await svc.checkForUpdate('0.4.0');
    expect(r, isNotNull);
    expect(r!.version, '0.5.0');
    expect(r.apkUrl, 'https://x/c.apk');
  });

  test('returns null when up to date', () async {
    final client = _MockClient();
    when(() => client.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(_body, 200));
    final svc = GitHubUpdateService(client: client);
    expect(await svc.checkForUpdate('0.5.0'), isNull);
  });

  test('throws UpdateCheckException on non-200', () async {
    final client = _MockClient();
    when(() => client.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('nope', 403));
    final svc = GitHubUpdateService(client: client);
    expect(() => svc.checkForUpdate('0.4.0'), throwsA(isA<UpdateCheckException>()));
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/data/github_update_service_test.dart`
Expected: FAIL — `GitHubUpdateService` not found.

- [ ] **Step 4: Write the implementation**

```dart
// lib/src/data/update/github_update_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../domain/models/app_release.dart';
import '../../domain/services/update_service.dart';

class GitHubUpdateService implements UpdateService {
  GitHubUpdateService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  static const _owner = 'zN3utr4l';
  static const _repo = 'Carburo';

  @override
  Future<AppRelease?> checkForUpdate(String currentVersion) async {
    final uri = Uri.parse(
      'https://api.github.com/repos/$_owner/$_repo/releases/latest',
    );
    final resp = await _client.get(
      uri,
      headers: {'Accept': 'application/vnd.github+json'},
    );
    if (resp.statusCode != 200) throw UpdateCheckException(resp.statusCode);
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final release = parseLatestRelease(json);
    if (release == null) return null;
    return isNewerVersion(release.version, currentVersion) ? release : null;
  }

  @override
  Future<void> downloadAndInstall(
    AppRelease release, {
    void Function(double progress)? onProgress,
  }) async {
    final resp =
        await _client.send(http.Request('GET', Uri.parse(release.apkUrl)));
    if (resp.statusCode != 200) {
      throw Exception('Download fallito: HTTP ${resp.statusCode}');
    }
    final total = resp.contentLength ?? release.sizeBytes;
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, 'carburo-update.apk'));
    final sink = file.openWrite();
    try {
      var received = 0;
      await for (final chunk in resp.stream) {
        received += chunk.length;
        sink.add(chunk);
        if (onProgress != null && total > 0) {
          onProgress((received / total).clamp(0.0, 1.0));
        }
      }
    } finally {
      await sink.close();
    }
    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done) {
      throw Exception('Impossibile aprire l\'installer: ${result.message}');
    }
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/data/github_update_service_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 6: Commit**

```bash
git add lib/src/domain/services/update_service.dart lib/src/data/update/github_update_service.dart test/data/github_update_service_test.dart
git commit -m "feat: add UpdateService + GitHubUpdateService (check + download/install)

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 4: `UpdatePrefs` throttle store

**Files:**
- Create: `lib/src/data/update/update_prefs.dart`
- Test: `test/data/update_prefs_test.dart`

**Interfaces:**
- Produces: `class UpdatePrefs { const UpdatePrefs(); Future<DateTime?> lastCheck(); Future<void> markChecked(DateTime when); }`

- [ ] **Step 1: Write the failing test**

```dart
// test/data/update_prefs_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carburo/src/data/update/update_prefs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('lastCheck is null before any markChecked', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await const UpdatePrefs().lastCheck(), isNull);
  });

  test('markChecked then lastCheck round-trips the timestamp', () async {
    SharedPreferences.setMockInitialValues({});
    const prefs = UpdatePrefs();
    final when = DateTime(2026, 6, 23, 12);
    await prefs.markChecked(when);
    expect(await prefs.lastCheck(), when);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/data/update_prefs_test.dart`
Expected: FAIL — `update_prefs.dart` not found.

- [ ] **Step 3: Write the implementation**

```dart
// lib/src/data/update/update_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the last update-check time so the startup check can be throttled.
class UpdatePrefs {
  const UpdatePrefs();

  static const _key = 'last_update_check';

  Future<DateTime?> lastCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_key);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> markChecked(DateTime when) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, when.millisecondsSinceEpoch);
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/data/update_prefs_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/src/data/update/update_prefs.dart test/data/update_prefs_test.dart
git commit -m "feat: add UpdatePrefs throttle store (shared_preferences)

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 5: Providers + `AvailableUpdate` notifier + startup check + download dialog

**Files:**
- Modify: `lib/src/providers.dart`
- Create: `lib/src/features/updates/update_providers.dart`

**Interfaces:**
- Consumes: `UpdateService`/`GitHubUpdateService` (Task 3), `UpdatePrefs` (Task 4), `AppRelease`/`shouldCheck` (Task 1).
- Produces:
  - In `providers.dart`: `updateServiceProvider`, `updatePrefsProvider`, `currentVersionProvider` (`Future<String>`).
  - In `update_providers.dart`: `availableUpdateProvider` (Notifier with `void set(AppRelease?)`), `Future<void> startupUpdateCheck(WidgetRef ref)`, `Future<void> showUpdateDownloadDialog(BuildContext context, WidgetRef ref, AppRelease release)`.

- [ ] **Step 1: Register providers in `providers.dart`**

Add imports near the other `data/` imports:
```dart
import 'package:package_info_plus/package_info_plus.dart';
import 'data/update/github_update_service.dart';
import 'data/update/update_prefs.dart';
import 'domain/services/update_service.dart';
```
Add at the end of `providers.dart`:
```dart
@Riverpod(keepAlive: true)
UpdateService updateService(Ref ref) => GitHubUpdateService();

@Riverpod(keepAlive: true)
UpdatePrefs updatePrefs(Ref ref) => const UpdatePrefs();

@riverpod
Future<String> currentVersion(Ref ref) async =>
    (await PackageInfo.fromPlatform()).version;
```

- [ ] **Step 2: Create the update providers + helpers**

```dart
// lib/src/features/updates/update_providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/app_release.dart';
import '../../providers.dart';

part 'update_providers.g.dart';

/// Holds the update found by the startup check (null = none / dismissed).
@riverpod
class AvailableUpdate extends _$AvailableUpdate {
  @override
  AppRelease? build() => null;

  void set(AppRelease? release) => state = release;
}

/// Best-effort, throttled (≤ 1/day) startup check. Sets [availableUpdateProvider]
/// when a newer release exists. Callers wrap this in try/catch.
Future<void> startupUpdateCheck(WidgetRef ref) async {
  final prefs = ref.read(updatePrefsProvider);
  if (!shouldCheck(await prefs.lastCheck(), DateTime.now(), const Duration(days: 1))) {
    return;
  }
  final current = await ref.read(currentVersionProvider.future);
  final release = await ref.read(updateServiceProvider).checkForUpdate(current);
  await prefs.markChecked(DateTime.now());
  if (release != null) {
    ref.read(availableUpdateProvider.notifier).set(release);
  }
}

/// Modal progress dialog that downloads + launches the installer for [release].
Future<void> showUpdateDownloadDialog(
  BuildContext context,
  WidgetRef ref,
  AppRelease release,
) async {
  final progress = ValueNotifier<double>(0);
  final messenger = ScaffoldMessenger.of(context);
  unawaited(showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('Aggiornamento'),
      content: ValueListenableBuilder<double>(
        valueListenable: progress,
        builder: (_, p, __) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(value: p == 0 ? null : p),
            const SizedBox(height: 12),
            Text('${(p * 100).round()}%'),
          ],
        ),
      ),
    ),
  ));
  try {
    await ref
        .read(updateServiceProvider)
        .downloadAndInstall(release, onProgress: (p) => progress.value = p);
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('Aggiornamento non riuscito: $e')),
    );
  } finally {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    progress.dispose();
  }
}
```
(Add `import 'dart:async';` for `unawaited`.)

- [ ] **Step 3: Run codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: generates `update_providers.g.dart` + updates `providers.g.dart`, no errors.

- [ ] **Step 4: Verify it analyzes**

Run: `flutter analyze lib/src/features/updates lib/src/providers.dart`
Expected: no issues.

- [ ] **Step 5: Commit**

```bash
git add lib/src/providers.dart lib/src/providers.g.dart lib/src/features/updates/update_providers.dart lib/src/features/updates/update_providers.g.dart
git commit -m "feat: add update providers, startup check, and download dialog

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 6: `UpdateBanner` + shell wiring + startup hook + Settings tile

**Files:**
- Create: `lib/src/features/updates/update_banner.dart`
- Modify: `lib/src/app/router.dart`
- Modify: `lib/src/app/app.dart`
- Modify: `lib/src/features/settings/settings_screen.dart`
- Test: `test/features/update_banner_test.dart`

**Interfaces:**
- Consumes: `availableUpdateProvider`, `showUpdateDownloadDialog` (Task 5), `currentVersionProvider`, `updateServiceProvider` (Tasks 3/5), `AppRelease` (Task 1).
- Produces: `class UpdateBanner extends ConsumerWidget` (renders a `MaterialBanner` when an update is available, else `SizedBox.shrink`).

- [ ] **Step 1: Write the failing widget test**

```dart
// test/features/update_banner_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/domain/models/app_release.dart';
import 'package:carburo/src/features/updates/update_banner.dart';
import 'package:carburo/src/features/updates/update_providers.dart';

void main() {
  testWidgets('hidden when no update', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: UpdateBanner())),
      ),
    );
    expect(find.byType(MaterialBanner), findsNothing);
  });

  testWidgets('shows version and hides on "Più tardi"', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(availableUpdateProvider.notifier).set(
          const AppRelease(version: '0.5.0', apkUrl: 'https://x/c.apk', sizeBytes: 0),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: UpdateBanner())),
      ),
    );
    expect(find.textContaining('0.5.0'), findsOneWidget);

    await tester.tap(find.text('Più tardi'));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialBanner), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/update_banner_test.dart`
Expected: FAIL — `update_banner.dart` not found.

- [ ] **Step 3: Create `UpdateBanner`**

```dart
// lib/src/features/updates/update_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'update_providers.dart';

/// A dismissible banner shown at the top of the shell when a newer release is
/// available. "Aggiorna" downloads + installs; "Più tardi" hides it.
class UpdateBanner extends ConsumerWidget {
  const UpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final update = ref.watch(availableUpdateProvider);
    if (update == null) return const SizedBox.shrink();
    return MaterialBanner(
      leading: const Icon(Icons.system_update),
      content: Text('Carburo v${update.version} disponibile'),
      actions: [
        TextButton(
          onPressed: () => ref.read(availableUpdateProvider.notifier).set(null),
          child: const Text('Più tardi'),
        ),
        TextButton(
          onPressed: () => showUpdateDownloadDialog(context, ref, update),
          child: const Text('Aggiorna'),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/update_banner_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Wire the banner into the shell**

In `lib/src/app/router.dart`: add imports
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/updates/update_banner.dart';
```
Change `class _HomeShell extends StatelessWidget` to `class _HomeShell extends ConsumerWidget`, and its `build` to `Widget build(BuildContext context, WidgetRef ref)`. Replace `body: shell,` with:
```dart
      body: Column(
        children: [
          const UpdateBanner(),
          Expanded(child: shell),
        ],
      ),
```

- [ ] **Step 6: Hook the startup check in `app.dart`**

In `lib/src/app/app.dart`: add import
```dart
import '../features/updates/update_providers.dart';
```
In `initState`, after `_initNotifications();`, add `_checkForUpdate();`. Add the method:
```dart
  /// Best-effort, throttled in-app update check (sets the banner if newer).
  Future<void> _checkForUpdate() async {
    try {
      await startupUpdateCheck(ref);
    } catch (_) {
      /* best-effort */
    }
  }
```

- [ ] **Step 7: Add the Settings "Aggiornamenti" tile**

In `lib/src/features/settings/settings_screen.dart`: add imports
```dart
import '../updates/update_providers.dart';
import '../../domain/services/update_service.dart';
```
Add a method on `SettingsScreen`:
```dart
  Future<void> _checkUpdates(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final String current;
    try {
      current = await ref.read(currentVersionProvider.future);
    } catch (_) {
      return;
    }
    try {
      final release = await ref.read(updateServiceProvider).checkForUpdate(current);
      if (!context.mounted) return;
      if (release == null) {
        messenger.showSnackBar(const SnackBar(content: Text('Sei aggiornato')));
        return;
      }
      ref.read(availableUpdateProvider.notifier).set(release);
      await showUpdateDownloadDialog(context, ref, release);
    } on UpdateCheckException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
```
Add this `ListTile` to the `ListView` (e.g. after the restore tile):
```dart
          const Divider(),
          ListTile(
            leading: const Icon(Icons.system_update),
            title: const Text('Aggiornamenti'),
            subtitle: Text(
              'Versione attuale: '
              '${ref.watch(currentVersionProvider).asData?.value ?? '…'}',
            ),
            onTap: () => _checkUpdates(context, ref),
          ),
```

- [ ] **Step 8: Run codegen, the banner test, and analyze**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/update_banner_test.dart`
Run: `flutter analyze`
Expected: codegen OK; banner test PASS; analyze clean.

- [ ] **Step 9: Commit**

```bash
git add lib/src/features/updates/update_banner.dart lib/src/app/router.dart lib/src/app/app.dart lib/src/features/settings/settings_screen.dart test/features/update_banner_test.dart
git commit -m "feat: show update banner in shell + startup check + Settings check

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 7: Full verification + docs

**Files:**
- Modify: `CLAUDE.md` + `AGENTS.md`, `.claude/memory/gotchas.md`

- [ ] **Step 1: Whole-project analyze**

Run: `flutter analyze`
Expected: "No issues found!" Fix anything reported.

- [ ] **Step 2: Full test suite**

Run: `flutter test`
Expected: all tests pass (existing + new).

- [ ] **Step 3: Update docs**

In `CLAUDE.md` add a feature bullet (Architecture/features) noting the in-app updater: startup throttled check + Settings check → download the release APK in-app (`http`) → system installer (`open_filex`), `REQUEST_INSTALL_PACKAGES`, best-effort/local-first. Resync: `cp CLAUDE.md AGENTS.md`. In `.claude/memory/gotchas.md` add: over-install needs a matching signature (release builds are keystore-signed; a debug-signed dev build can't be over-installed by a release APK).

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.md AGENTS.md .claude/memory/gotchas.md
git commit -m "docs: note in-app updater in CLAUDE.md and gotchas

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

- [ ] **Step 5: (manual, on device)** Build a signed release, install it, publish a higher test release, and confirm the banner → download → installer flow updates over the app with data preserved. (Emulators can't sideload-install; needs a physical device.)

---

## Self-Review

**Spec coverage:**
- Startup throttled check → `shouldCheck` (Task 1) + `startupUpdateCheck` (Task 5) + `app.dart` hook (Task 6). ✅
- Banner with Aggiorna/Più tardi → `UpdateBanner` (Task 6). ✅
- Settings manual check → tile + `_checkUpdates` (Task 6). ✅
- Download with progress + system installer → `downloadAndInstall` + `showUpdateDownloadDialog` (Tasks 3/5). ✅
- Check failure honest (not "up to date") → `UpdateCheckException` (Task 3), surfaced in Settings (Task 6). ✅
- Throttle persistence → `UpdatePrefs` (Task 4). ✅
- Deps + `REQUEST_INSTALL_PACKAGES` → Task 2. ✅
- Pure/service/widget tests → Tasks 1/3/4/6. ✅
- Version bump + PR #4 dependency → Global Constraints + Task 2. ✅

**Placeholder scan:** No TBD/TODO; every code step has full code. ✅

**Type consistency:** `AppRelease{version,apkUrl,sizeBytes}`, `UpdateService.checkForUpdate/downloadAndInstall`, `UpdateCheckException(statusCode)`, `UpdatePrefs.lastCheck/markChecked`, `shouldCheck(DateTime?,DateTime,Duration)`, `availableUpdateProvider`+`.set`, `startupUpdateCheck(WidgetRef)`, `showUpdateDownloadDialog(BuildContext,WidgetRef,AppRelease)`, `currentVersionProvider` — used identically across tasks. ✅

**Known nuance (flagged):** `open_filex`'s bundled FileProvider should cover sharing the APK; if the install intent needs an app-side provider on some OEM/OS, add one (Task 2 note). The download/install path is platform I/O behind `UpdateService`, verified on-device (Task 7 Step 5), not in unit tests.
