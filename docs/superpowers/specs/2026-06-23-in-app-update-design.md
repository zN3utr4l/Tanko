# In-App Update — Design

**Date:** 2026-06-23
**Status:** Approved (brainstorming)
**Scope:** Single feature / single PR.

## Summary

Let Carburo update itself: check GitHub Releases for a newer version, and if one
exists, download the release APK **in-app** (with a progress bar) and hand it to
the Android system installer — so the user never has to open a browser or hunt
for the APK. Checks run silently on startup (throttled to once/day) and
on-demand from Settings. Everything is best-effort and never blocks the app.

Modeled on GitOpen's `GitHubReleaseUpdater` (same author), adapted from desktop
installers to Android APK install.

## User-facing behaviour

- **On startup** (best-effort, alongside the existing notification init): if
  ≥ 1 day has passed since the last check, query the latest GitHub release. If it
  is newer than the installed version, show a dismissible **MaterialBanner** at
  the top of the shell: *"Carburo v0.5.0 disponibile — [Aggiorna] [Più tardi]"*.
- **Settings → "Aggiornamenti"**: a tile showing the current version with a
  *"Controlla aggiornamenti"* action → *"Sei aggiornato"* or *"v0.5.0 disponibile
  [Aggiorna]"*.
- **[Aggiorna]** → a dialog with a **progress bar** while the APK downloads; at
  100 % `open_filex` opens the file → the **system installer** launches (the user
  confirms; first time Android asks to allow "install unknown apps" for Carburo).
  Installs over the existing app — data preserved.
- **Best-effort everywhere**: offline / rate-limited / error → an honest message,
  never a crash, never a blocked screen.

## Architecture

Follows the existing one-directional layering: **`features/` → `domain/` ← `data/`**.
Pure, tested logic in `domain/`; I/O behind an interface in `data/`.

### `domain/` (pure, unit-tested)

- **`domain/models/app_release.dart`**:
  - `AppRelease { String version; String apkUrl; int sizeBytes; }` (plain value type).
  - `bool isNewerVersion(String candidate, String current)` — semver MAJOR.MINOR.PATCH,
    numeric compare; tolerant of a leading `v` and missing parts.
  - `AppRelease? parseLatestRelease(Map<String, dynamic> json)` — reads `tag_name`
    (strips `v`), picks the first asset whose name ends in `.apk`, returns null if
    no tag or no APK asset.
  - `bool shouldCheck(DateTime? lastCheck, DateTime now, Duration interval)` —
    true when `lastCheck` is null or older than `interval` (throttle).
- **`domain/services/update_service.dart`** — interface:
  ```dart
  abstract class UpdateService {
    /// Latest release if newer than [currentVersion], else null. Throws
    /// UpdateCheckException on a failed check (non-200/offline) so the UI never
    /// reports a failure as "up to date".
    Future<AppRelease?> checkForUpdate(String currentVersion);

    /// Download the APK reporting 0..1 progress, then launch the system
    /// installer. Throws on download failure.
    Future<void> downloadAndInstall(
      AppRelease release, {
      void Function(double progress)? onProgress,
    });
  }
  ```
  - `class UpdateCheckException implements Exception { final int statusCode; }`.

### `data/` (I/O, behind the interface)

- **`data/update/github_update_service.dart`** implements `UpdateService`:
  - `checkForUpdate`: `http` GET `https://api.github.com/repos/zN3utr4l/Carburo/releases/latest`
    with `Accept: application/vnd.github+json`; non-200 → throw
    `UpdateCheckException`; parse via `parseLatestRelease`; return it when
    `isNewerVersion(release.version, currentVersion)`.
  - `downloadAndInstall`: stream the APK to the cache dir (`path_provider`
    `getTemporaryDirectory`) reporting progress, then `OpenFilex.open(path)` to
    launch the installer. Returns/throws honestly.
- **`data/update/update_prefs.dart`**: thin wrapper over `shared_preferences`
  for the `last_update_check` timestamp (`Future<DateTime?> lastCheck()`,
  `Future<void> markChecked(DateTime)`).

### `features/` (UI / Riverpod)

- **`providers.dart`**: `updateServiceProvider` (→ `GitHubUpdateService`),
  `currentVersionProvider` (`package_info_plus` → installed versionName),
  `updatePrefsProvider`.
- **`features/updates/update_controller.dart`**: an `availableUpdateProvider`
  (holds the `AppRelease?` found at startup) + a small controller that runs the
  throttled startup check and the manual check.
- **`app/app.dart`**: in `initState`, after notifications, a best-effort
  `_checkForUpdate()` that, when `shouldCheck`, fetches and sets
  `availableUpdateProvider` (no UI work here).
- **Shell** (router shell scaffold): a `MaterialBanner` shown when
  `availableUpdateProvider` is non-null, with **Aggiorna** (→ download dialog) and
  **Più tardi** (dismiss).
- **`features/settings/settings_screen.dart`**: an "Aggiornamenti" `ListTile`
  with the current version and a manual check; the download/install progress
  dialog is shared with the banner's **Aggiorna**.

## Data flow

```
startup → shouldCheck(lastCheck, now, 1d)?
   └─ yes → UpdateService.checkForUpdate(current)
              ├─ newer → availableUpdateProvider = release → banner
              └─ null/up-to-date → nothing ; markChecked(now)
Settings "Controlla aggiornamenti" → checkForUpdate(current) → inline result
[Aggiorna] → progress dialog → UpdateService.downloadAndInstall(release, onProgress)
              → OpenFilex.open(apk) → system installer (user confirms)
```

## Dependencies, permissions, persistence

- **New packages:** `open_filex` (open the APK → system installer),
  `shared_preferences` (throttle timestamp); promote `package_info_plus` to a
  direct dependency (already transitive). `http` and `path_provider` already present.
- **AndroidManifest:** add `REQUEST_INSTALL_PACKAGES`. `open_filex` ships its own
  FileProvider to expose the APK as a `content://` URI; if the install intent
  needs an app-side provider, add one (verify during implementation).
- **Throttle:** `last_update_check` key in `shared_preferences`; interval 1 day.

## Signing & error handling

- **Over-install requires a matching signature.** Releases are signed with the
  keystore (`ANDROID_KEYSTORE_*` secrets are set) → consistent, so updates install
  over the app with data preserved. A locally debug-signed dev build cannot be
  over-installed by a release-signed APK (signature mismatch → uninstall +
  reinstall). Noted; not a code concern.
- **Check failure** (non-200 / offline / timeout) → `UpdateCheckException` →
  surfaced as *"Controllo non riuscito"*, never *"sei aggiornato"*.
- **Download failure** → message + allow retry; no exception propagated to a crash.
- The startup check is wrapped best-effort (like `_initNotifications`); any
  failure is swallowed.

## Testing

- **Pure unit tests:** `isNewerVersion` (newer/older/equal, leading `v`, missing
  parts), `parseLatestRelease` (apk asset picked, tag normalized, missing
  tag/asset → null), `shouldCheck` (null/old/recent).
- **`GitHubUpdateService.checkForUpdate`** with a mocked `http.Client`: canned
  releases JSON → newer returns `AppRelease`, equal/older returns null, non-200
  throws `UpdateCheckException`.
- **Widget tests** with a fake `UpdateService`: Settings tile manual check shows
  *"disponibile"* / *"aggiornato"*; the banner appears when
  `availableUpdateProvider` is set and hides on **Più tardi**.
- `open_filex` / actual download are platform I/O behind the interface — mocked,
  not unit-tested.
- `flutter analyze` clean; regenerate codegen after provider changes.

## Delivery

- **Single feature / single PR.** Bump `pubspec.yaml` `0.4.0+5 → 0.5.0+6`.
- ⚠️ **Depends on PR #4** (R8/ML Kit CD fix): until it merges, any release build
  off `main` fails R8, so this feature can only be released after #4 is in. Branch
  from `main` once #4 has merged (or rebase onto it before merging this).

## Out of scope (v1)

- Background/automatic download without user action (always user-initiated install).
- Delta/partial updates; we download the full APK.
- Play Store in-app updates (the app is sideloaded, not on Play).
- A "skip this version" preference (only the 1/day throttle).
