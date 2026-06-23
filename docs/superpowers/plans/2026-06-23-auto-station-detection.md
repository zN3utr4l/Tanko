# Auto Station Detection Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans (the user prefers inline execution, no subagents) to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** When recording a fill-up in the moment, Carburo detects which fuel station the user is at (GPS + history, optional online lookup) or reads it from a receipt photo (on-device OCR), always degrading to manual entry.

**Architecture:** Feature-first + layered (`features/ → domain/ ← data/`). Pure, fully-tested logic lives in `domain/` (`StationMatcher`, `ReceiptParser`, `haversineMeters`, Overpass JSON parser). I/O lives behind domain interfaces in `data/` (`GeolocatorLocationService`, `MlKitOcrService`, `OverpassStationLookup`). A `StationDetector` in `features/fillups/` orchestrates them; `FillUpFormScreen` drives the UX.

**Tech Stack:** Flutter (stable 3.44.x), Riverpod 3 (code-gen), Freezed 3, Drift 2.34, `geolocator`, `google_mlkit_text_recognition`, `http`, existing `image_picker`. Tests: `flutter_test` + `mocktail` + in-memory Drift.

**Spec:** `docs/superpowers/specs/2026-06-23-auto-station-detection-design.md`

## Global Constraints

- **Local-first:** GPS is read only on demand at fill-up time; the network is contacted **only** when the user explicitly taps "Cerca online". Photos and data stay on device. Every path degrades to manual entry — never blocking.
- **Freezed 3** data classes are `@freezed abstract class X with _$X` (NOT `@freezed class`). Add `const X._();` only when the class has custom getters/methods.
- **Riverpod 3** code-gen: `@riverpod` / `@Riverpod(keepAlive: true)`, `Ref ref` parameter, `part 'file.g.dart';`, generated provider is `<name>Provider`.
- **AsyncValue:** `valueOrNull` is NOT available here — use `.asData?.value` (or `.value`). Using `valueOrNull` fails analysis.
- **Regenerate after model/DB/provider changes:** `dart run build_runner build --delete-conflicting-outputs`. Never hand-edit `*.g.dart` / `*.freezed.dart`.
- **Lint:** run bare `flutter analyze` (whole project, covers `test/`) before pushing; must be clean.
- **Money in EUR, distance in km, volume in liters.**
- **Version bump:** this PR touches `lib/` and `pubspec.yaml`, so bump `pubspec.yaml` `0.3.0+4 → 0.4.0+5`. CI required checks are `build-and-test (ubuntu-latest)` and `version-check`; CD releases `v0.4.0` (APK) on merge to `main`.
- **Git identity:** `zN3utr4l <zN3utr4l@users.noreply.github.com>` (already configured for `D:\repos\Personal`). Every commit ends with:
  `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`
- **Branch:** all work on `feature/auto-station-detection` (already created; the design spec is committed there). Do NOT commit the unrelated pre-existing working-tree changes.
- **TDD:** failing test → run (fail) → minimal impl → run (pass) → commit. Frequent commits.

## File Structure

```
pubspec.yaml                                              # +geolocator +google_mlkit_text_recognition +http; version bump
android/app/src/main/AndroidManifest.xml                 # +ACCESS_COARSE/FINE_LOCATION
lib/src/
  domain/
    models/
      enums.dart                                         # +StationSource enum
      geo_point.dart                                     # NEW: plain GeoPoint(lat,lng)
      detected_station.dart                              # NEW: DetectedStation (freezed)
      receipt_data.dart                                  # NEW: ReceiptData (freezed)
    services/
      geo.dart                                           # NEW: haversineMeters() pure
      station_matcher.dart                               # NEW: StationMatcher (pure)
      receipt_parser.dart                                # NEW: ReceiptParser (pure)
      location_service.dart                              # NEW: abstract LocationService
      ocr_service.dart                                   # NEW: abstract OcrService
      station_lookup_service.dart                        # NEW: abstract StationLookupService
  data/
    location/geolocator_location_service.dart            # NEW: impl
    ocr/mlkit_ocr_service.dart                           # NEW: impl
    lookup/overpass_parser.dart                          # NEW: pure parseOverpassFuelStations()
    lookup/overpass_station_lookup.dart                  # NEW: impl (http)
  providers.dart                                         # +locationService/ocrService/stationLookupService providers
  features/fillups/
    station_detector.dart                                # NEW: StationDetector + stationDetectorProvider + shouldOfferDetection()
    fill_up_form_screen.dart                             # MODIFY: dialog, prefill, chip, persist lat/lng/photo
test/
  domain/geo_test.dart                                   # NEW
  domain/station_matcher_test.dart                       # NEW
  domain/receipt_parser_test.dart                        # NEW
  data/overpass_parser_test.dart                         # NEW
  data/overpass_station_lookup_test.dart                 # NEW
  features/station_detector_test.dart                    # NEW
  features/fill_up_form_detection_test.dart              # NEW
```

---

### Task 1: Haversine distance (pure)

**Files:**
- Create: `lib/src/domain/services/geo.dart`
- Test: `test/domain/geo_test.dart`

**Interfaces:**
- Produces: `double haversineMeters(double lat1, double lng1, double lat2, double lng2)` — great-circle distance in meters.

- [ ] **Step 1: Write the failing test**

```dart
// test/domain/geo_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/services/geo.dart';

void main() {
  test('distance between identical points is zero', () {
    expect(haversineMeters(45.07, 7.68, 45.07, 7.68), closeTo(0, 1e-6));
  });

  test('0.001 deg of latitude is about 111 m', () {
    expect(haversineMeters(45.0, 7.0, 45.001, 7.0), closeTo(111.2, 1.0));
  });

  test('symmetric', () {
    final a = haversineMeters(45.0, 7.0, 45.02, 7.03);
    final b = haversineMeters(45.02, 7.03, 45.0, 7.0);
    expect(a, closeTo(b, 1e-6));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/domain/geo_test.dart`
Expected: FAIL — `geo.dart` / `haversineMeters` not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/src/domain/services/geo.dart
import 'dart:math' as math;

/// Great-circle distance in meters between two WGS84 lat/lng points.
double haversineMeters(double lat1, double lng1, double lat2, double lng2) {
  const earthRadius = 6371000.0; // meters
  final dLat = _rad(lat2 - lat1);
  final dLng = _rad(lng2 - lng1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_rad(lat1)) *
          math.cos(_rad(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

double _rad(double deg) => deg * math.pi / 180.0;
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/domain/geo_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/src/domain/services/geo.dart test/domain/geo_test.dart
git commit -m "feat: add haversine distance helper

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 2: `StationSource` enum + `DetectedStation` model + `StationMatcher` (pure)

**Files:**
- Modify: `lib/src/domain/models/enums.dart` (append `StationSource`)
- Create: `lib/src/domain/models/detected_station.dart`
- Create: `lib/src/domain/services/station_matcher.dart`
- Test: `test/domain/station_matcher_test.dart`

**Interfaces:**
- Consumes: `haversineMeters` (Task 1).
- Produces:
  - `enum StationSource { history, online, receipt, manual }`
  - `DetectedStation({required String name, required double latitude, required double longitude, required double distanceMeters, required StationSource source})` (freezed).
  - `class StationMatcher { const StationMatcher(); DetectedStation? match({required double latitude, required double longitude, required List<FillUp> history, double radiusMeters = 80}); }`

- [ ] **Step 1: Append the enum**

```dart
// lib/src/domain/models/enums.dart  (append at end)

/// Where an auto-detected station name came from.
enum StationSource { history, online, receipt, manual }
```

- [ ] **Step 2: Create the model**

```dart
// lib/src/domain/models/detected_station.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'detected_station.freezed.dart';

@freezed
abstract class DetectedStation with _$DetectedStation {
  const factory DetectedStation({
    required String name,
    required double latitude,
    required double longitude,
    required double distanceMeters,
    required StationSource source,
  }) = _DetectedStation;
}
```

- [ ] **Step 3: Run codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: generates `detected_station.freezed.dart`, no errors.

- [ ] **Step 4: Write the failing test**

```dart
// test/domain/station_matcher_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/services/station_matcher.dart';

FillUp fill({
  required int id,
  double? lat,
  double? lng,
  String? station,
}) => FillUp(
  id: id,
  vehicleId: 1,
  date: DateTime(2026, 1, id),
  amount: 50,
  liters: 30,
  odometer: 1000.0 * id,
  categoryId: 1,
  latitude: lat,
  longitude: lng,
  station: station,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  const matcher = StationMatcher();

  test('exact-coordinate history entry matches', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [fill(id: 1, lat: 45.07, lng: 7.68, station: 'Eni Corso Francia')],
    );
    expect(m, isNotNull);
    expect(m!.name, 'Eni Corso Francia');
    expect(m.source, StationSource.history);
    expect(m.distanceMeters, closeTo(0, 1.0));
  });

  test('entry just inside the radius matches (~55 m)', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [fill(id: 1, lat: 45.0705, lng: 7.68, station: 'Q8')],
    );
    expect(m, isNotNull);
  });

  test('entry outside the radius does not match (~222 m)', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [fill(id: 1, lat: 45.072, lng: 7.68, station: 'Q8')],
    );
    expect(m, isNull);
  });

  test('nearest of several candidates wins', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [
        fill(id: 1, lat: 45.0705, lng: 7.68, station: 'Far'),   // ~55 m
        fill(id: 2, lat: 45.0701, lng: 7.68, station: 'Near'),  // ~11 m
      ],
    );
    expect(m!.name, 'Near');
  });

  test('entries without coords or station name are ignored', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [
        fill(id: 1, lat: null, lng: null, station: 'No coords'),
        fill(id: 2, lat: 45.07, lng: 7.68, station: '   '),
        fill(id: 3, lat: 45.07, lng: 7.68, station: null),
      ],
    );
    expect(m, isNull);
  });

  test('empty history returns null', () {
    expect(matcher.match(latitude: 45.07, longitude: 7.68, history: []), isNull);
  });
}
```

- [ ] **Step 5: Run test to verify it fails**

Run: `flutter test test/domain/station_matcher_test.dart`
Expected: FAIL — `StationMatcher` not found.

- [ ] **Step 6: Write minimal implementation**

```dart
// lib/src/domain/services/station_matcher.dart
import '../models/detected_station.dart';
import '../models/enums.dart';
import '../models/fill_up.dart';
import 'geo.dart';

/// Finds the nearest past fill-up (with coordinates and a station name) within
/// [radiusMeters] of the given point. Pure; "learn from history" matcher.
class StationMatcher {
  const StationMatcher();

  DetectedStation? match({
    required double latitude,
    required double longitude,
    required List<FillUp> history,
    double radiusMeters = 80,
  }) {
    DetectedStation? best;
    var bestDist = double.infinity;
    for (final f in history) {
      final lat = f.latitude;
      final lng = f.longitude;
      final name = f.station;
      if (lat == null || lng == null || name == null || name.trim().isEmpty) {
        continue;
      }
      final d = haversineMeters(latitude, longitude, lat, lng);
      if (d <= radiusMeters && d < bestDist) {
        bestDist = d;
        best = DetectedStation(
          name: name.trim(),
          latitude: lat,
          longitude: lng,
          distanceMeters: d,
          source: StationSource.history,
        );
      }
    }
    return best;
  }
}
```

- [ ] **Step 7: Run test to verify it passes**

Run: `flutter test test/domain/station_matcher_test.dart`
Expected: PASS (6 tests).

- [ ] **Step 8: Commit**

```bash
git add lib/src/domain/models/enums.dart lib/src/domain/models/detected_station.dart lib/src/domain/models/detected_station.freezed.dart lib/src/domain/services/station_matcher.dart test/domain/station_matcher_test.dart
git commit -m "feat: add StationMatcher and DetectedStation (history match)

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 3: `ReceiptData` model + `ReceiptParser` (pure, best-effort)

**Files:**
- Create: `lib/src/domain/models/receipt_data.dart`
- Create: `lib/src/domain/services/receipt_parser.dart`
- Test: `test/domain/receipt_parser_test.dart`

**Interfaces:**
- Produces:
  - `ReceiptData({String? station, double? amount, double? liters, double? pricePerLiter, DateTime? date})` (freezed).
  - `class ReceiptParser { const ReceiptParser(); ReceiptData parse(List<String> lines); }` — never throws; unreadable fields stay null.

- [ ] **Step 1: Create the model**

```dart
// lib/src/domain/models/receipt_data.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_data.freezed.dart';

@freezed
abstract class ReceiptData with _$ReceiptData {
  const factory ReceiptData({
    String? station,
    double? amount,
    double? liters,
    double? pricePerLiter,
    DateTime? date,
  }) = _ReceiptData;
}
```

- [ ] **Step 2: Run codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: generates `receipt_data.freezed.dart`, no errors.

- [ ] **Step 3: Write the failing test**

```dart
// test/domain/receipt_parser_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/services/receipt_parser.dart';

void main() {
  const parser = ReceiptParser();

  test('extracts brand, amount, liters, price and date from a typical receipt', () {
    final data = parser.parse([
      'ENI STATION',
      'VIA ROMA 12 - TORINO',
      'DIESEL',
      'LITRI 28,50',
      'PREZZO 1,789 EUR/L',
      'IMPORTO EURO 50,99',
      'DATA 23/06/2026 14:32',
    ]);
    expect(data.station, 'Eni');
    expect(data.liters, closeTo(28.50, 1e-9));
    expect(data.pricePerLiter, closeTo(1.789, 1e-9));
    expect(data.amount, closeTo(50.99, 1e-9));
    expect(data.date, DateTime(2026, 6, 23));
  });

  test('brand match is case-insensitive and matches as substring', () {
    expect(parser.parse(['stazione q8 di rossi']).station, 'Q8');
  });

  test('totally unreadable input yields all-null, never throws', () {
    final data = parser.parse(['@@@@', '......']);
    expect(data.station, isNull);
    expect(data.amount, isNull);
    expect(data.liters, isNull);
    expect(data.pricePerLiter, isNull);
    expect(data.date, isNull);
  });

  test('empty input yields all-null', () {
    final data = parser.parse([]);
    expect(data, const ReceiptData());
  });
}
```

- [ ] **Step 4: Run test to verify it fails**

Run: `flutter test test/domain/receipt_parser_test.dart`
Expected: FAIL — `ReceiptParser` not found.

- [ ] **Step 5: Write minimal implementation**

```dart
// lib/src/domain/services/receipt_parser.dart
import '../models/receipt_data.dart';

/// Best-effort extraction of fill-up fields from OCR'd receipt lines.
/// Never throws; any field it cannot read confidently stays null.
class ReceiptParser {
  const ReceiptParser();

  /// Known Italian fuel brands, upper-case keyword -> display name.
  static const _brands = <String, String>{
    'ENI': 'Eni',
    'AGIP': 'Agip',
    'Q8': 'Q8',
    'ESSO': 'Esso',
    'TAMOIL': 'Tamoil',
    'REPSOL': 'Repsol',
    'BEYFIN': 'Beyfin',
    'TOTALERG': 'TotalErg',
    'TOTAL': 'Total',
    'SHELL': 'Shell',
    // 'IP' and 'API' are short; match as whole words only (see _hasWord).
  };

  ReceiptData parse(List<String> lines) {
    final upper = lines.map((l) => l.toUpperCase()).toList();
    return ReceiptData(
      station: _station(upper),
      amount: _numNear(upper, RegExp(r'IMPORTO|TOTALE|EURO|€')),
      liters: _numNear(upper, RegExp(r'LITRI|\bLT\b')),
      pricePerLiter: _numNear(upper, RegExp(r'/L|PREZZO')),
      date: _date(lines.join('\n')),
    );
  }

  String? _station(List<String> upper) {
    for (final entry in _brands.entries) {
      if (upper.any((l) => l.contains(entry.key))) return entry.value;
    }
    if (upper.any((l) => _hasWord(l, 'IP'))) return 'IP';
    if (upper.any((l) => _hasWord(l, 'API'))) return 'Api';
    return null;
  }

  bool _hasWord(String line, String word) =>
      RegExp('\\b$word\\b').hasMatch(line);

  /// First number on a line matching [marker]. Handles "28,50" and "1.789".
  double? _numNear(List<String> upper, RegExp marker) {
    final numRe = RegExp(r'(\d+[.,]\d+)');
    for (final l in upper) {
      if (!marker.hasMatch(l)) continue;
      final m = numRe.firstMatch(l);
      if (m != null) {
        return double.tryParse(m.group(1)!.replaceAll(',', '.'));
      }
    }
    return null;
  }

  DateTime? _date(String text) {
    final m = RegExp(r'(\d{2})[/.\-](\d{2})[/.\-](\d{4})').firstMatch(text);
    if (m == null) return null;
    final d = int.tryParse(m.group(1)!);
    final mo = int.tryParse(m.group(2)!);
    final y = int.tryParse(m.group(3)!);
    if (d == null || mo == null || y == null) return null;
    if (mo < 1 || mo > 12 || d < 1 || d > 31) return null;
    return DateTime(y, mo, d);
  }
}
```

- [ ] **Step 6: Run test to verify it passes**

Run: `flutter test test/domain/receipt_parser_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 7: Commit**

```bash
git add lib/src/domain/models/receipt_data.dart lib/src/domain/models/receipt_data.freezed.dart lib/src/domain/services/receipt_parser.dart test/domain/receipt_parser_test.dart
git commit -m "feat: add ReceiptParser and ReceiptData (best-effort OCR parse)

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 4: Dependencies + Android location permissions

**Files:**
- Modify: `pubspec.yaml` (add deps, bump version)
- Modify: `android/app/src/main/AndroidManifest.xml`

**Interfaces:** none (config). Deliverable: project resolves, builds, `flutter analyze` clean.

- [ ] **Step 1: Add the packages**

Run:
```bash
flutter pub add geolocator google_mlkit_text_recognition http
```
Expected: `pubspec.yaml` gains the three deps at their latest stable versions; `flutter pub get` succeeds.

- [ ] **Step 2: Bump the app version**

Edit `pubspec.yaml`: change `version: 0.3.0+4` to `version: 0.4.0+5`.

- [ ] **Step 3: Add location permissions to the manifest**

Edit `android/app/src/main/AndroidManifest.xml` — add inside `<manifest>`, next to the existing `<uses-permission>` lines:

```xml
    <!-- Detect the fuel station at fill-up time (when-in-use, on demand). -->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

- [ ] **Step 4: Verify it still analyzes and the Android build resolves**

Run: `flutter analyze`
Expected: no new issues.
Run: `flutter pub get`
Expected: success. (If the Android Gradle build later complains about `minSdkVersion`, ML Kit / geolocator need ≥ 21; the app is already at `min_sdk_android: 24`, so no change is required.)

- [ ] **Step 5: Commit**

```bash
git add pubspec.yaml pubspec.lock android/app/src/main/AndroidManifest.xml
git commit -m "build: add geolocator, ml kit text recognition, http; location perms; bump to 0.4.0

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 5: I/O service interfaces + thin impls + `GeoPoint`

**Files:**
- Create: `lib/src/domain/models/geo_point.dart`
- Create: `lib/src/domain/services/location_service.dart`
- Create: `lib/src/domain/services/ocr_service.dart`
- Create: `lib/src/domain/services/station_lookup_service.dart`
- Create: `lib/src/data/location/geolocator_location_service.dart`
- Create: `lib/src/data/ocr/mlkit_ocr_service.dart`

**Interfaces:**
- Produces:
  - `class GeoPoint { const GeoPoint(this.latitude, this.longitude); final double latitude; final double longitude; }`
  - `abstract class LocationService { Future<GeoPoint?> current(); }`
  - `abstract class OcrService { Future<List<String>> readLines(String imagePath); }`
  - `abstract class StationLookupService { Future<List<DetectedStation>> nearby(double latitude, double longitude, {double radiusMeters}); }`
  - `class GeolocatorLocationService implements LocationService` and `class MlKitOcrService implements OcrService`.

> These adapters wrap plugin static APIs that are not practically unit-testable; their behavior is exercised via fakes in Tasks 7 and 8. Deliverable here is "compiles + analyze clean".

- [ ] **Step 1: Create `GeoPoint`**

```dart
// lib/src/domain/models/geo_point.dart
/// A WGS84 coordinate pair. Plain value type (no codegen).
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}
```

- [ ] **Step 2: Create the three interfaces**

```dart
// lib/src/domain/services/location_service.dart
import '../models/geo_point.dart';

/// Current device location, best-effort. Returns null on denial / GPS off /
/// timeout — callers must degrade gracefully.
abstract class LocationService {
  Future<GeoPoint?> current();
}
```

```dart
// lib/src/domain/services/ocr_service.dart
/// On-device text recognition. Returns the recognized text lines, or an empty
/// list on failure. Never throws.
abstract class OcrService {
  Future<List<String>> readLines(String imagePath);
}
```

```dart
// lib/src/domain/services/station_lookup_service.dart
import '../models/detected_station.dart';

/// Online lookup of fuel stations near a point (used only on explicit request).
/// Returns an empty list on network failure. Never throws.
abstract class StationLookupService {
  Future<List<DetectedStation>> nearby(
    double latitude,
    double longitude, {
    double radiusMeters,
  });
}
```

- [ ] **Step 3: Create the geolocator impl**

```dart
// lib/src/data/location/geolocator_location_service.dart
import 'package:geolocator/geolocator.dart';
import '../../domain/models/geo_point.dart';
import '../../domain/services/location_service.dart';

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<GeoPoint?> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      return GeoPoint(pos.latitude, pos.longitude);
    } catch (_) {
      return null;
    }
  }
}
```

- [ ] **Step 4: Create the ML Kit impl**

```dart
// lib/src/data/ocr/mlkit_ocr_service.dart
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../domain/services/ocr_service.dart';

class MlKitOcrService implements OcrService {
  @override
  Future<List<String>> readLines(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(imagePath),
      );
      return [
        for (final block in result.blocks)
          for (final line in block.lines) line.text,
      ];
    } catch (_) {
      return const [];
    } finally {
      await recognizer.close();
    }
  }
}
```

- [ ] **Step 5: Verify it analyzes**

Run: `flutter analyze`
Expected: no issues. (`OverpassStationLookup` is created in Task 6; its provider is wired then.)

- [ ] **Step 6: Commit**

```bash
git add lib/src/domain/models/geo_point.dart lib/src/domain/services/location_service.dart lib/src/domain/services/ocr_service.dart lib/src/domain/services/station_lookup_service.dart lib/src/data/location/geolocator_location_service.dart lib/src/data/ocr/mlkit_ocr_service.dart
git commit -m "feat: add location and OCR service interfaces and impls

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 6: Overpass online lookup (pure parser + http impl)

**Files:**
- Create: `lib/src/data/lookup/overpass_parser.dart`
- Create: `lib/src/data/lookup/overpass_station_lookup.dart`
- Test: `test/data/overpass_parser_test.dart`
- Test: `test/data/overpass_station_lookup_test.dart`

**Interfaces:**
- Consumes: `haversineMeters` (Task 1), `DetectedStation`/`StationSource` (Task 2), `StationLookupService` (Task 5).
- Produces:
  - `List<DetectedStation> parseOverpassFuelStations(Map<String, dynamic> json, {required double originLat, required double originLng})` — pure; sorted nearest-first.
  - `class OverpassStationLookup implements StationLookupService { OverpassStationLookup({http.Client? client}); }`

- [ ] **Step 1: Write the failing parser test**

```dart
// test/data/overpass_parser_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/data/lookup/overpass_parser.dart';
import 'package:carburo/src/domain/models/enums.dart';

void main() {
  test('maps fuel nodes to DetectedStation, nearest first, source=online', () {
    final json = {
      'elements': [
        {'type': 'node', 'lat': 45.072, 'lon': 7.68, 'tags': {'name': 'Far Eni'}},
        {'type': 'node', 'lat': 45.0701, 'lon': 7.68, 'tags': {'brand': 'Q8'}},
        {'type': 'node', 'lat': 45.07, 'lon': 7.68, 'tags': {'amenity': 'fuel'}}, // no name/brand
      ],
    };
    final out = parseOverpassFuelStations(json, originLat: 45.07, originLng: 7.68);
    expect(out, hasLength(2)); // the nameless node is dropped
    expect(out.first.name, 'Q8'); // ~11 m, nearer than 'Far Eni' (~222 m)
    expect(out.first.source, StationSource.online);
    expect(out.first.distanceMeters, lessThan(out.last.distanceMeters));
  });

  test('missing or empty elements yields empty list', () {
    expect(parseOverpassFuelStations({}, originLat: 0, originLng: 0), isEmpty);
    expect(
      parseOverpassFuelStations({'elements': []}, originLat: 0, originLng: 0),
      isEmpty,
    );
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/data/overpass_parser_test.dart`
Expected: FAIL — `overpass_parser.dart` not found.

- [ ] **Step 3: Write the pure parser**

```dart
// lib/src/data/lookup/overpass_parser.dart
import '../../domain/models/detected_station.dart';
import '../../domain/models/enums.dart';
import '../../domain/services/geo.dart';

/// Maps an Overpass `[out:json]` response of `amenity=fuel` nodes into
/// [DetectedStation]s, sorted nearest-first. Nodes without a usable name are
/// dropped. Pure.
List<DetectedStation> parseOverpassFuelStations(
  Map<String, dynamic> json, {
  required double originLat,
  required double originLng,
}) {
  final elements = (json['elements'] as List?) ?? const [];
  final out = <DetectedStation>[];
  for (final e in elements) {
    if (e is! Map) continue;
    final lat = (e['lat'] as num?)?.toDouble();
    final lng = (e['lon'] as num?)?.toDouble();
    if (lat == null || lng == null) continue;
    final tags = (e['tags'] as Map?) ?? const {};
    final name = (tags['name'] ?? tags['brand'] ?? tags['operator'])?.toString();
    if (name == null || name.trim().isEmpty) continue;
    out.add(
      DetectedStation(
        name: name.trim(),
        latitude: lat,
        longitude: lng,
        distanceMeters: haversineMeters(originLat, originLng, lat, lng),
        source: StationSource.online,
      ),
    );
  }
  out.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
  return out;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/data/overpass_parser_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Write the failing http-impl test**

```dart
// test/data/overpass_station_lookup_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:carburo/src/data/lookup/overpass_station_lookup.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() => registerFallbackValue(Uri()));

  test('parses a 200 response into candidates', () async {
    final client = _MockClient();
    when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
      (_) async => http.Response(
        '{"elements":[{"lat":45.07,"lon":7.68,"tags":{"name":"Eni"}}]}',
        200,
      ),
    );
    final lookup = OverpassStationLookup(client: client);
    final out = await lookup.nearby(45.07, 7.68);
    expect(out.single.name, 'Eni');
  });

  test('non-200 response yields empty list', () async {
    final client = _MockClient();
    when(() => client.post(any(), body: any(named: 'body')))
        .thenAnswer((_) async => http.Response('error', 503));
    final lookup = OverpassStationLookup(client: client);
    expect(await lookup.nearby(45.07, 7.68), isEmpty);
  });

  test('network exception yields empty list (never throws)', () async {
    final client = _MockClient();
    when(() => client.post(any(), body: any(named: 'body')))
        .thenThrow(Exception('offline'));
    final lookup = OverpassStationLookup(client: client);
    expect(await lookup.nearby(45.07, 7.68), isEmpty);
  });
}
```

- [ ] **Step 6: Run test to verify it fails**

Run: `flutter test test/data/overpass_station_lookup_test.dart`
Expected: FAIL — `OverpassStationLookup` not found.

- [ ] **Step 7: Write the http impl**

```dart
// lib/src/data/lookup/overpass_station_lookup.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/detected_station.dart';
import '../../domain/services/station_lookup_service.dart';
import 'overpass_parser.dart';

/// Online fuel-station lookup via the OpenStreetMap Overpass API. No API key.
/// Called only on explicit user request. Returns an empty list on any failure.
class OverpassStationLookup implements StationLookupService {
  OverpassStationLookup({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  static const _endpoint = 'https://overpass-api.de/api/interpreter';

  @override
  Future<List<DetectedStation>> nearby(
    double latitude,
    double longitude, {
    double radiusMeters = 150,
  }) async {
    try {
      final query =
          '[out:json][timeout:10];node["amenity"="fuel"](around:$radiusMeters,$latitude,$longitude);out;';
      final resp = await _client
          .post(Uri.parse(_endpoint), body: {'data': query})
          .timeout(const Duration(seconds: 12));
      if (resp.statusCode != 200) return const [];
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return parseOverpassFuelStations(
        json,
        originLat: latitude,
        originLng: longitude,
      );
    } catch (_) {
      return const [];
    }
  }
}
```

- [ ] **Step 8: Run tests to verify they pass**

Run: `flutter test test/data/overpass_parser_test.dart test/data/overpass_station_lookup_test.dart`
Expected: PASS (5 tests total).

- [ ] **Step 9: Commit**

```bash
git add lib/src/data/lookup/overpass_parser.dart lib/src/data/lookup/overpass_station_lookup.dart test/data/overpass_parser_test.dart test/data/overpass_station_lookup_test.dart
git commit -m "feat: add Overpass online station lookup (opt-in)

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 7: `StationDetector` orchestrator + providers + `shouldOfferDetection`

**Files:**
- Create: `lib/src/features/fillups/station_detector.dart`
- Modify: `lib/src/providers.dart` (register the three I/O services)
- Test: `test/features/station_detector_test.dart`

**Interfaces:**
- Consumes: `LocationService`, `OcrService`, `StationLookupService` (Task 5), `StationMatcher` (Task 2), `ReceiptParser` (Task 3), `FillUpRepository` (existing), `GeoPoint`/`DetectedStation`/`ReceiptData`.
- Produces:
  - `class StationDetection { const StationDetection({this.position, this.match}); final GeoPoint? position; final DetectedStation? match; }`
  - `class StationDetector` with:
    - `Future<StationDetection> detect()` — read GPS once, match against history.
    - `Future<List<DetectedStation>> lookupOnline(GeoPoint at)` — online candidates.
    - `Future<ReceiptData> readReceipt(String imagePath)` — OCR + parse.
  - `bool shouldOfferDetection(DateTime entryDate, DateTime now)` — true when `entryDate` is within 5 minutes of `now` (a real-time entry).
  - `stationDetectorProvider` (`@riverpod`).
  - In `providers.dart`: `locationServiceProvider`, `ocrServiceProvider`, `stationLookupServiceProvider`.

- [ ] **Step 1: Register the I/O services in `providers.dart`**

Add imports near the other `data/` imports:
```dart
import 'data/location/geolocator_location_service.dart';
import 'data/ocr/mlkit_ocr_service.dart';
import 'data/lookup/overpass_station_lookup.dart';
import 'domain/services/location_service.dart';
import 'domain/services/ocr_service.dart';
import 'domain/services/station_lookup_service.dart';
```
Add providers at the end of `providers.dart`:
```dart
@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) => const GeolocatorLocationService();

@Riverpod(keepAlive: true)
OcrService ocrService(Ref ref) => MlKitOcrService();

@Riverpod(keepAlive: true)
StationLookupService stationLookupService(Ref ref) => OverpassStationLookup();
```

- [ ] **Step 2: Write the failing test**

```dart
// test/features/station_detector_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/models/detected_station.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/models/geo_point.dart';
import 'package:carburo/src/domain/models/receipt_data.dart';
import 'package:carburo/src/domain/repositories/fill_up_repository.dart';
import 'package:carburo/src/domain/services/location_service.dart';
import 'package:carburo/src/domain/services/ocr_service.dart';
import 'package:carburo/src/domain/services/receipt_parser.dart';
import 'package:carburo/src/domain/services/station_lookup_service.dart';
import 'package:carburo/src/domain/services/station_matcher.dart';
import 'package:carburo/src/features/fillups/station_detector.dart';

class _FixedLocation implements LocationService {
  _FixedLocation(this._point);
  final GeoPoint? _point;
  @override
  Future<GeoPoint?> current() async => _point;
}

class _FakeRepo implements FillUpRepository {
  _FakeRepo(this._all);
  final List<FillUp> _all;
  @override
  Future<List<FillUp>> all() async => _all;
  @override
  Future<List<FillUp>> forVehicle(int vehicleId) async => _all;
  @override
  Future<int> upsert(FillUp fillUp) async => 0;
  @override
  Future<void> delete(int id) async {}
}

class _FakeOcr implements OcrService {
  _FakeOcr(this._lines);
  final List<String> _lines;
  @override
  Future<List<String>> readLines(String imagePath) async => _lines;
}

class _EmptyLookup implements StationLookupService {
  @override
  Future<List<DetectedStation>> nearby(double lat, double lng, {double radiusMeters = 150}) async => const [];
}

FillUp _fill({double? lat, double? lng, String? station}) => FillUp(
  id: 1, vehicleId: 1, date: DateTime(2026), amount: 50, liters: 30,
  odometer: 1000, categoryId: 1, latitude: lat, longitude: lng,
  station: station, createdAt: DateTime(2026), updatedAt: DateTime(2026),
);

StationDetector _detector({
  GeoPoint? at,
  List<FillUp> history = const [],
  List<String> ocrLines = const [],
}) => StationDetector(
  location: _FixedLocation(at),
  fillUps: _FakeRepo(history),
  matcher: const StationMatcher(),
  lookup: _EmptyLookup(),
  ocr: _FakeOcr(ocrLines),
  receiptParser: const ReceiptParser(),
);

void main() {
  test('detect() matches a known station from history', () async {
    final d = _detector(
      at: const GeoPoint(45.07, 7.68),
      history: [_fill(lat: 45.07, lng: 7.68, station: 'Eni')],
    );
    final result = await d.detect();
    expect(result.position, isNotNull);
    expect(result.match?.name, 'Eni');
    expect(result.match?.source, StationSource.history);
  });

  test('detect() with no GPS returns empty result', () async {
    final result = await _detector(at: null).detect();
    expect(result.position, isNull);
    expect(result.match, isNull);
  });

  test('detect() with GPS but no nearby history returns position, null match', () async {
    final result = await _detector(at: const GeoPoint(45.07, 7.68)).detect();
    expect(result.position, isNotNull);
    expect(result.match, isNull);
  });

  test('readReceipt() pipes OCR lines through the parser', () async {
    final d = _detector(ocrLines: ['ENI', 'IMPORTO EURO 50,99']);
    final data = await d.readReceipt('/tmp/x.jpg');
    expect(data.station, 'Eni');
    expect(data.amount, closeTo(50.99, 1e-9));
  });

  group('shouldOfferDetection', () {
    final now = DateTime(2026, 6, 23, 14, 30);
    test('true when the entry date is now', () {
      expect(shouldOfferDetection(now, now), isTrue);
    });
    test('true within 5 minutes', () {
      expect(shouldOfferDetection(now.subtract(const Duration(minutes: 3)), now), isTrue);
    });
    test('false for a back-dated entry', () {
      expect(shouldOfferDetection(now.subtract(const Duration(days: 3)), now), isFalse);
    });
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/features/station_detector_test.dart`
Expected: FAIL — `station_detector.dart` not found.

- [ ] **Step 4: Write the implementation**

```dart
// lib/src/features/fillups/station_detector.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/detected_station.dart';
import '../../domain/models/geo_point.dart';
import '../../domain/models/receipt_data.dart';
import '../../domain/repositories/fill_up_repository.dart';
import '../../domain/services/location_service.dart';
import '../../domain/services/ocr_service.dart';
import '../../domain/services/receipt_parser.dart';
import '../../domain/services/station_lookup_service.dart';
import '../../domain/services/station_matcher.dart';
import '../../providers.dart';

part 'station_detector.g.dart';

/// Result of one GPS detection attempt.
class StationDetection {
  const StationDetection({this.position, this.match});
  final GeoPoint? position;
  final DetectedStation? match;
}

/// Should the form offer auto-detection? Only for real-time entries — within
/// 5 minutes of now. Back-dated fill-ups never trigger GPS.
bool shouldOfferDetection(DateTime entryDate, DateTime now) =>
    entryDate.difference(now).abs() <= const Duration(minutes: 5);

/// Orchestrates GPS history-matching, optional online lookup, and receipt OCR.
class StationDetector {
  StationDetector({
    required LocationService location,
    required FillUpRepository fillUps,
    required StationMatcher matcher,
    required StationLookupService lookup,
    required OcrService ocr,
    required ReceiptParser receiptParser,
  })  : _location = location,
        _fillUps = fillUps,
        _matcher = matcher,
        _lookup = lookup,
        _ocr = ocr,
        _receiptParser = receiptParser;

  final LocationService _location;
  final FillUpRepository _fillUps;
  final StationMatcher _matcher;
  final StationLookupService _lookup;
  final OcrService _ocr;
  final ReceiptParser _receiptParser;

  Future<StationDetection> detect() async {
    final pos = await _location.current();
    if (pos == null) return const StationDetection();
    final history = await _fillUps.all();
    final match = _matcher.match(
      latitude: pos.latitude,
      longitude: pos.longitude,
      history: history,
    );
    return StationDetection(position: pos, match: match);
  }

  Future<List<DetectedStation>> lookupOnline(GeoPoint at) =>
      _lookup.nearby(at.latitude, at.longitude);

  Future<ReceiptData> readReceipt(String imagePath) async {
    final lines = await _ocr.readLines(imagePath);
    return _receiptParser.parse(lines);
  }
}

@riverpod
StationDetector stationDetector(Ref ref) => StationDetector(
      location: ref.watch(locationServiceProvider),
      fillUps: ref.watch(fillUpRepositoryProvider),
      matcher: const StationMatcher(),
      lookup: ref.watch(stationLookupServiceProvider),
      ocr: ref.watch(ocrServiceProvider),
      receiptParser: const ReceiptParser(),
    );
```

- [ ] **Step 5: Run codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: generates `station_detector.g.dart` and `providers.g.dart` updates, no errors.

- [ ] **Step 6: Run test to verify it passes**

Run: `flutter test test/features/station_detector_test.dart`
Expected: PASS (7 tests).

- [ ] **Step 7: Commit**

```bash
git add lib/src/features/fillups/station_detector.dart lib/src/features/fillups/station_detector.g.dart lib/src/providers.dart lib/src/providers.g.dart test/features/station_detector_test.dart
git commit -m "feat: add StationDetector orchestrator and service providers

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 8: Wire detection into `FillUpFormScreen`

**Files:**
- Modify: `lib/src/features/fillups/fill_up_form_screen.dart`
- Test: `test/features/fill_up_form_detection_test.dart`

**Interfaces:**
- Consumes: `stationDetectorProvider`, `StationDetection`, `shouldOfferDetection` (Task 7); existing `image_picker`.
- Produces: no new public API; behavior only.

**Behavior to implement:**
1. New nullable state fields: `double? _latitude;`, `double? _longitude;`, `String? _receiptPhotoPath;`.
2. `_save()` must now persist `latitude: _latitude`, `longitude: _longitude`, `receiptPhotoPath: _receiptPhotoPath` on the `FillUp` (today it drops them).
3. On a NEW entry (`widget.initial == null`), after the first frame, if `shouldOfferDetection(_date, DateTime.now())`, show an `AlertDialog` "Sei al distributore adesso?" with **[Sì]**, **[No]**, **[Inserisci dopo]**.
4. **Sì** → `await ref.read(stationDetectorProvider).detect()`:
   - `match != null` → set `_station.text = match.name`, `_latitude/_longitude = match.lat/lng`; show a `SnackBar`/chip "Rilevato: <name>".
   - `match == null && position != null` → show a secondary dialog offering **[Cerca online]** / **[Usa scontrino]** / **[A mano]**.
     - **Cerca online** → show a one-time notice that coordinates go to OpenStreetMap, then `await ref.read(stationDetectorProvider).lookupOnline(position)`; present results in a list; on tap set station + coords.
   - `position == null` → `SnackBar('Posizione non disponibile')`, stay on manual form.
5. **No** → run the receipt flow (Step "receipt flow" below).
6. **Inserisci dopo** → close dialog, do nothing.
7. Receipt flow: `ImagePicker().pickImage(source: ImageSource.camera)` (fallback gallery); if a file is returned, set `_receiptPhotoPath = file.path`, then `final data = await ref.read(stationDetectorProvider).readReceipt(file.path)` and prefill any non-null field (`_station`, `_amount`, `_liters`, `_note` left as-is; set `_amount.text`, `_liters.text`, and station). All values remain editable.
8. Guard every `await` with `if (!mounted) return;` before touching controllers/context.

- [ ] **Step 1: Write the failing widget test**

```dart
// test/features/fill_up_form_detection_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:carburo/src/data/database/database.dart';
import 'package:carburo/src/domain/models/geo_point.dart';
import 'package:carburo/src/domain/services/location_service.dart';
import 'package:carburo/src/features/fillups/fill_up_form_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

class _FixedLocation implements LocationService {
  _FixedLocation(this._point);
  final GeoPoint? _point;
  @override
  Future<GeoPoint?> current() async => _point;
}

Future<void> _seed(AppDatabase db) async {
  await db.into(db.vehicles).insert(
    VehiclesCompanion.insert(
      make: 'Fiat', model: 'Panda', fuelType: 'petrol',
      createdAt: DateTime(2026), updatedAt: DateTime(2026),
    ),
  );
  // A past fill-up with coords + station -> the history match target.
  await db.into(db.fillUps).insert(
    FillUpsCompanion.insert(
      vehicleId: 1, date: DateTime(2026, 1, 1), amount: 50, odometer: 1000,
      categoryId: const Value(1),
      latitude: const Value(45.07), longitude: const Value(7.68),
      station: const Value('Eni Corso Francia'),
      createdAt: DateTime(2026), updatedAt: DateTime(2026),
    ),
  );
}

void main() {
  testWidgets('Sì at a known station pre-fills the station field', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await _seed(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          locationServiceProvider.overrideWithValue(
            _FixedLocation(const GeoPoint(45.07, 7.68)),
          ),
        ],
        child: const MaterialApp(home: FillUpFormScreen(vehicleId: 1)),
      ),
    );
    await tester.pumpAndSettle();

    // Dialog appears for a real-time (default = now) entry.
    expect(find.text('Sei al distributore adesso?'), findsOneWidget);
    await tester.tap(find.text('Sì'));
    await tester.pumpAndSettle();

    expect(find.text('Eni Corso Francia'), findsOneWidget);
  });

  testWidgets('no dialog for a back-dated entry', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await _seed(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          locationServiceProvider.overrideWithValue(
            _FixedLocation(const GeoPoint(45.07, 7.68)),
          ),
        ],
        child: MaterialApp(
          home: FillUpFormScreen(
            vehicleId: 1,
            initialDate: DateTime(2026).subtract(const Duration(days: 3)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sei al distributore adesso?'), findsNothing);
  });
}
```

> NOTE: check `FillUpsCompanion.insert` / `VehiclesCompanion.insert` required-vs-optional fields against the generated `database.g.dart`; adjust the seed if a column is required (e.g. wrap optionals in `Value(...)`). The `categoryId` default category `1` is seeded by `AppDatabase`; if the test DB does not seed categories, insert a fuel category first.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/fill_up_form_detection_test.dart`
Expected: FAIL — dialog text not found (detection not wired yet).

- [ ] **Step 3: Implement the form changes**

In `lib/src/features/fillups/fill_up_form_screen.dart`:

a) Add imports:
```dart
import 'package:image_picker/image_picker.dart';
import 'station_detector.dart';
```

b) Add state fields (next to the existing controllers):
```dart
double? _latitude;
double? _longitude;
String? _receiptPhotoPath;
```
Initialize from `widget.initial` in the field initializers:
```dart
late double? _latitude = widget.initial?.latitude;
late double? _longitude = widget.initial?.longitude;
late String? _receiptPhotoPath = widget.initial?.receiptPhotoPath;
```

c) Add an `initState` that offers detection for new, real-time entries:
```dart
@override
void initState() {
  super.initState();
  if (widget.initial == null &&
      shouldOfferDetection(_date, DateTime.now())) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _offerDetection());
  }
}
```

d) Add the orchestration methods (paste verbatim):
```dart
Future<void> _offerDetection() async {
  final choice = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Sei al distributore adesso?'),
      content: const Text(
        'Posso provare a rilevare il distributore dalla tua posizione, '
        'oppure leggerlo dallo scontrino.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, 'later'),
          child: const Text('Inserisci dopo'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, 'no'),
          child: const Text('No'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, 'yes'),
          child: const Text('Sì'),
        ),
      ],
    ),
  );
  if (!mounted) return;
  if (choice == 'yes') {
    await _detectFromGps();
  } else if (choice == 'no') {
    await _useReceipt();
  }
}

Future<void> _detectFromGps() async {
  final result = await ref.read(stationDetectorProvider).detect();
  if (!mounted) return;
  if (result.position == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Posizione non disponibile')),
    );
    return;
  }
  final match = result.match;
  if (match != null) {
    setState(() {
      _station.text = match.name;
      _latitude = match.latitude;
      _longitude = match.longitude;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rilevato: ${match.name}')),
    );
    return;
  }
  // No history match — record the coords and offer fallbacks.
  setState(() {
    _latitude = result.position!.latitude;
    _longitude = result.position!.longitude;
  });
  await _offerFallback(result.position!);
}

Future<void> _offerFallback(GeoPoint at) async {
  final choice = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Distributore non riconosciuto'),
      content: const Text('Come vuoi inserirlo?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, 'manual'),
          child: const Text('A mano'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, 'receipt'),
          child: const Text('Usa scontrino'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, 'online'),
          child: const Text('Cerca online'),
        ),
      ],
    ),
  );
  if (!mounted) return;
  if (choice == 'online') {
    await _lookupOnline(at);
  } else if (choice == 'receipt') {
    await _useReceipt();
  }
}

Future<void> _lookupOnline(GeoPoint at) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Cerca online'),
      content: const Text(
        'Le coordinate verranno inviate a OpenStreetMap per cercare i '
        'distributori vicini. Procedere?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Procedi'),
        ),
      ],
    ),
  );
  if (ok != true || !mounted) return;
  final candidates = await ref.read(stationDetectorProvider).lookupOnline(at);
  if (!mounted) return;
  if (candidates.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nessun distributore trovato')),
    );
    return;
  }
  final picked = await showDialog<String>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: const Text('Distributori vicini'),
      children: [
        for (final c in candidates)
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, c.name),
            child: Text('${c.name} · ${c.distanceMeters.round()} m'),
          ),
      ],
    ),
  );
  if (picked == null || !mounted) return;
  setState(() => _station.text = picked);
}

Future<void> _useReceipt() async {
  final XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
  if (file == null || !mounted) return;
  final data = await ref.read(stationDetectorProvider).readReceipt(file.path);
  if (!mounted) return;
  setState(() {
    _receiptPhotoPath = file.path;
    if (data.station != null) _station.text = data.station!;
    if (data.amount != null) _amount.text = data.amount!.toString();
    if (data.liters != null) _liters.text = data.liters!.toString();
  });
}
```

e) In `_save()`, add the three fields to the `FillUp(...)` constructor (alongside the existing args):
```dart
            latitude: _latitude,
            longitude: _longitude,
            receiptPhotoPath: _receiptPhotoPath,
```

- [ ] **Step 4: Run codegen (no new generated files expected, safe to run)**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: no errors.

- [ ] **Step 5: Run the detection widget test + the existing form test**

Run: `flutter test test/features/fill_up_form_detection_test.dart test/features/fill_up_form_test.dart`
Expected: PASS. (The existing `fill_up_form_test.dart` has no `initialDate`, so its default-now dialog will appear; if it interferes with the existing assertions, those tests open the form expecting no dialog — pass an `initialDate` in the past to those two existing tests, OR dismiss the dialog first. Prefer adding `initialDate: DateTime(2020)` to the existing tests' `FillUpFormScreen` so they keep testing the plain form.)

- [ ] **Step 6: Adjust the two existing form tests if needed**

If Step 5 shows the existing tests failing because the dialog now covers the form, edit `test/features/fill_up_form_test.dart` to construct `FillUpFormScreen(vehicleId: 1, initialDate: DateTime(2020))` in both `testWidgets`, so no detection dialog appears. Re-run:
Run: `flutter test test/features/fill_up_form_test.dart`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/src/features/fillups/fill_up_form_screen.dart test/features/fill_up_form_detection_test.dart test/features/fill_up_form_test.dart
git commit -m "feat: detect station on fill-up (GPS, online, receipt) with manual fallback

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 9: Full verification + docs

**Files:**
- Modify: `CLAUDE.md` + `AGENTS.md` (one-line note on the new feature/permission), `.claude/memory/gotchas.md` if a landmine was hit.

- [ ] **Step 1: Whole-project analyze**

Run: `flutter analyze`
Expected: "No issues found!" Fix anything reported before continuing.

- [ ] **Step 2: Full test suite**

Run: `flutter test`
Expected: all tests pass (existing + new). If any pre-existing test broke, fix it.

- [ ] **Step 3: Update docs**

In `CLAUDE.md` (Architecture → fillups bullet) add a sentence: the fill-up form auto-detects the station at fill-up time (GPS history match, opt-in Overpass online lookup, on-device receipt OCR), all local-first with manual fallback. Then resync: `cp CLAUDE.md AGENTS.md`. Add a "Build / Android" gotcha noting the new `ACCESS_*_LOCATION` permissions and that ML Kit text recognition bundles its model on-device.

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.md AGENTS.md .claude/memory/gotchas.md
git commit -m "docs: note auto station detection in CLAUDE.md and gotchas

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

- [ ] **Step 5: (optional) Manual smoke on a device**

`flutter run` on a physical Android device: open Nuovo rifornimento → confirm the dialog → grant location → verify a previously-saved station is matched within ~80 m; test the receipt path with a real receipt photo. (Emulators have no real GPS/camera — device recommended.)

---

## Self-Review

**Spec coverage:**
- Trigger "date ≈ now" → `shouldOfferDetection` (Task 7) + form `initState` (Task 8). ✅
- Popup [Sì]/[No]/[Inserisci dopo] → Task 8 `_offerDetection`. ✅
- Sì → history match → `StationDetector.detect` + `StationMatcher` (Tasks 7, 2). ✅
- No history match → online/receipt/manual fallback → Task 8 `_offerFallback`. ✅
- Optional online lookup w/ explicit consent → `OverpassStationLookup` + consent dialog (Tasks 6, 8). ✅
- No branch → receipt OCR full parse → `readReceipt` + `ReceiptParser` (Tasks 7, 3). ✅
- Manual fallback, never blocking → every path returns to the plain form. ✅
- Persist lat/lng/station/receiptPhotoPath, no migration → Task 8 `_save` edit. ✅
- Local-first / network only on explicit request → consent dialog gates `lookupOnline`. ✅
- Dependencies + permissions → Task 4. ✅
- Tests for matcher/parser/overpass/controller/form → Tasks 1,2,3,6,7,8. ✅

**Placeholder scan:** No TBD/TODO; every code step has full code. ✅

**Type consistency:** `DetectedStation` fields (`name/latitude/longitude/distanceMeters/source`), `StationDetection` (`position/match`), `StationDetector` methods (`detect/lookupOnline/readReceipt`), `shouldOfferDetection(DateTime,DateTime)`, `LocationService.current`, `OcrService.readLines`, `StationLookupService.nearby`, `ReceiptParser.parse`, `StationMatcher.match` — used identically across Tasks 2/5/6/7/8. ✅

**Known risk (flagged, not a blocker):** `ReceiptParser` full-receipt extraction is best-effort and layout-dependent; tests pin the patterns we implement, and the UI keeps everything editable. Real-world receipts may need the brand list / regexes extended over time.
