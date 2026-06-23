# Carburo

Free, open-source, **local-first** Android app to track fuel/refueling expenses
(spend, real €/L, real consumption) and compare them to the manufacturer specs.
All data lives on the device (SQLite). Repo: `github.com/zN3utr4l/Carburo`.

**The UI is in Italian; the codebase and docs are in English.**

## Quick Start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
flutter analyze
flutter test
```

Flutter stable (3.44.x), Dart `^3.12`. After changing models/DB/providers,
regenerate: `dart run build_runner build --delete-conflicting-outputs`.

## Stack

Flutter · **Riverpod 3** (code-gen, `@riverpod`) · **drift** (SQLite) ·
**freezed 3** (data classes are `abstract class … with _$X`) · go_router ·
fl_chart · intl.

## Architecture — feature-first + layered (one direction)

**`features/` (UI, Riverpod) → `domain/` (pure) ← `data/` (I/O).**

- **`lib/src/domain/`** — pure models (freezed) + services
  (`ConsumptionCalculator`, `StatsService`, `RangeComparator`,
  `ReminderEvaluator`) + repository interfaces. No I/O. Heavily unit-tested.
- **`lib/src/data/`** — drift database (schemaVersion **2**) + tables + mappers,
  repository impls, **offline vehicle catalog** (`OfflineCatalog`, backed by the
  bundled `assets/catalog/catalog.json`), Excel importer, backup service,
  `NotificationService` (flutter_local_notifications, best-effort). Station-
  detection I/O lives here too, behind `domain/` interfaces:
  `GeolocatorLocationService`, `MlKitOcrService` (on-device receipt OCR), and
  `OverpassStationLookup` (opt-in online, OpenStreetMap, no API key).
- **`lib/src/features/`** — `dashboard`, `fillups`, `vehicles` (Add-Vehicle
  wizard), `stats`, `expenses` (costi generali), `reminders` (scadenze, with
  Italian templates + completion flow), `calendar` (table_calendar), `movimenti`
  (fuel + expenses), `altro`, `settings`. Riverpod `Consumer*` widgets.
- **`lib/src/providers.dart`** — composition root (db, repos, services).
- **Nav:** 5-tab bottom bar (Home · Calendario · Scadenze · Statistiche · Altro).
- **Reminders:** status is **derived** by `ReminderEvaluator` (today + max
  odometer), never stored; recurrence is anchored to completion. Categories use
  a `kind` discriminator (fuel | expense) — filter by kind in every picker/query.
- **Station auto-detection:** a new fill-up recorded in the moment (`date ≈
  now`) offers a "Sei al distributore?" dialog. `StationDetector`
  (`features/fillups`) resolves the station from GPS via `StationMatcher`
  against past fill-ups' coordinates (offline, ~80 m); on no match it offers an
  opt-in Overpass online lookup or on-device receipt OCR (`ReceiptParser`), and
  always degrades to manual entry. Network is touched **only** on explicit
  request. Reuses the existing `FillUp.latitude/longitude/station/
  receiptPhotoPath` columns — no migration.

Put new logic in `domain/` as a pure, tested function whenever possible.

## Conventions

- **Lint:** `flutter analyze` (flutter_lints + a few extra rules). Run bare
  `flutter analyze` (whole project) before pushing. Generated `*.g.dart` /
  `*.freezed.dart` are analyzer-excluded — never hand-edit.
- **Consumption** is computed **full-to-full** (partial fills accumulate);
  intervals with missing liters are shown as "—", never estimated.
- **Vehicle catalog is offline** (`assets/catalog/catalog.json`, curated EU
  specs). The Add-Vehicle wizard's Make/Model are type-ahead fields over it that
  pre-fill specs; anything not in the catalog is just typed in. Specs are
  snapshotted onto the vehicle row and stay editable (`SpecSource.catalog` vs
  `.manual`). To extend the catalog, edit the JSON asset.
- **Tests:** `flutter test`. The in-memory test DB is `makeTestDb()`
  (`test/helpers/test_db.dart`); override `appDatabaseProvider` in widget tests.

## Git / CI / CD

- `main` is **PR-gated** (strict required checks + enforce_admins). Required
  checks: `build-and-test (ubuntu-latest)`, `version-check`, and `build-apk`
  (a per-PR debug APK build that validates the Android/Gradle/manifest side —
  `flutter test` runs on the Dart VM and never compiles the app). When `lib/` or
  `pubspec.yaml` changes, bump `x.y.z` in `pubspec.yaml`; CD releases
  `v<version>` (APK attached) on merge to `main`.
- Release APK is debug-signed unless the `ANDROID_KEYSTORE_*` secrets are set
  (see README "Release signing").
- Commits use the **zN3utr4l** identity (git `includeIf`); verify before pushing.

---

`AGENTS.md` is a byte-for-byte copy of this file. After editing `CLAUDE.md`,
resync with: `cp CLAUDE.md AGENTS.md`.
