# Tanko

Free, open-source, **local-first** Android app to track fuel/refueling expenses
(spend, real €/L, real consumption) and compare them to the manufacturer specs.
All data lives on the device (SQLite). Repo: `github.com/zN3utr4l/Tanko`.

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
fl_chart · dio (CarQuery) · intl.

## Architecture — feature-first + layered (one direction)

**`features/` (UI, Riverpod) → `domain/` (pure) ← `data/` (I/O).**

- **`lib/src/domain/`** — pure models (freezed) + services
  (`ConsumptionCalculator`, `StatsService`, `RangeComparator`) + repository
  interfaces. No I/O. Heavily unit-tested.
- **`lib/src/data/`** — drift database + tables + mappers, repository impls,
  CarQuery catalog client/parser, Excel importer, backup service.
- **`lib/src/features/`** — `dashboard`, `fillups`, `vehicles` (incl.
  Add-Vehicle wizard), `stats`, `settings`. Riverpod `Consumer*` widgets.
- **`lib/src/providers.dart`** — composition root (db, repos, services, dio).

Put new logic in `domain/` as a pure, tested function whenever possible.

## Conventions

- **Lint:** `flutter analyze` (flutter_lints + a few extra rules). Run bare
  `flutter analyze` (whole project) before pushing. Generated `*.g.dart` /
  `*.freezed.dart` are analyzer-excluded — never hand-edit.
- **Consumption** is computed **full-to-full** (partial fills accumulate);
  intervals with missing liters are shown as "—", never estimated.
- **CarQuery** can be down/flaky — the Add-Vehicle wizard always falls back to
  manual entry, and selected specs are snapshotted into the vehicle row.
- **Tests:** `flutter test`. The in-memory test DB is `makeTestDb()`
  (`test/helpers/test_db.dart`); override `appDatabaseProvider` in widget tests.

## Git / CI / CD

- `main` is **PR-gated** (strict required checks + enforce_admins). Required
  checks: `build-and-test (ubuntu-latest)` and `version-check`. When `lib/` or
  `pubspec.yaml` changes, bump `x.y.z` in `pubspec.yaml`; CD releases
  `v<version>` (APK attached) on merge to `main`.
- Release APK is debug-signed unless the `ANDROID_KEYSTORE_*` secrets are set
  (see README "Release signing").
- Commits use the **zN3utr4l** identity (git `includeIf`); verify before pushing.

---

`AGENTS.md` is a byte-for-byte copy of this file. After editing `CLAUDE.md`,
resync with: `cp CLAUDE.md AGENTS.md`.
