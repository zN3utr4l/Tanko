# Tanko — Design Spec

- **Date:** 2026-06-22
- **Status:** Approved (pending written-spec review)
- **Author:** Giuseppe Chirico (zN3utr4l)
- **Repo:** `Tanko` (new, under `D:\repos\Personal`)

## 1. Overview

Tanko is a local-first Android app for tracking fuel/refueling expenses for one or
more vehicles. It replaces a manual Excel workflow (`Consumi.xlsx`) with a friendlier,
faster mobile experience and adds metrics the spreadsheet never had: price per liter,
real fuel consumption, and a comparison between **real** figures and the
**manufacturer-declared** specs of the car.

The app is built from scratch in **Flutter** (native APK), with a clean, feature-first,
layered architecture and a test-driven workflow.

### Purpose

- Log each refuel in seconds and understand: how much I spend, at what €/L I refuel,
  and how much the car actually consumes.
- Replace the spreadsheet while preserving its history (import).
- Compare real-world consumption/range against the manufacturer's declared values.
- Be expandable: multi-vehicle from day one; room for more features later.

### Success criteria

- Adding a refuel takes a few taps, offline.
- Historical Excel data is imported without loss of the fields it contained.
- Real consumption (full-to-full) and €/L are computed correctly and shown with trends.
- Vehicle specs (tank capacity, declared consumption/range) are fetched from the
  internet via dropdowns, with a manual fallback that always works.
- Data can be exported/imported (CSV + JSON) so the user is never locked in.

## 2. Goals and non-goals

**Goals (v1)**
- Multi-vehicle from v1 (UI + data).
- Rich refuel entry: amount, liters, odometer, full/partial, station, category, note,
  optional GPS location, optional receipt photo, optional displayed range.
- Online vehicle catalog (Make → Model → Year → Trim) via CarQuery, auto-filling specs,
  every field editable, specs snapshotted locally.
- Real vs manufacturer comparison (consumption and range).
- Excel/CSV import of existing history.
- CSV + JSON backup/export and restore.
- Stats dashboard with charts.
- IT (default) + EN localization; Material 3 light/dark.
- Signed release APK (sideload), mirroring the personal CI/CD convention.

**Non-goals (v1) — YAGNI**
- No cloud sync / accounts / backend (local-first only; backup is the safety net).
- No Play Store submission in v1 (sideload APK).
- No iOS/desktop build in v1 (architecture stays portable, but not a target).
- No automatic OCR of receipts (photo is stored, not parsed).
- No live fuel-price lookups by station.

## 3. Domain model

Relational, stored locally in SQLite (Drift). Money in euro, distance in km, volume in
liters (units are configurable in settings but stored canonically).

### Entities

**Vehicle**
| Field | Type | Notes |
|---|---|---|
| `id` | int (pk) | |
| `make` | text | from catalog or manual |
| `model` | text | from catalog or manual |
| `year` | int? | from catalog or manual |
| `trim` | text? | "style"/allestimento |
| `fuelType` | enum | petrol, diesel, lpg, cng, hybrid, electric |
| `plate` | text? | optional |
| `colorTag` | int | UI accent for the vehicle |
| `isDefault` | bool | default vehicle on dashboard |
| `specs` | embedded `VehicleSpecs` | snapshot, see below |
| `createdAt` / `updatedAt` | datetime | |

**VehicleSpecs** (snapshot of catalog data, frozen at selection time; all editable)
| Field | Type | Notes |
|---|---|---|
| `tankCapacityL` | double? | from CarQuery `model_fuel_cap_l` |
| `mfrConsumption` | double? | declared L/100km (CarQuery `model_lkm_mixed`) |
| `mfrRangeKm` | double? | declared range; or derived = `tankCapacityL * 100 / mfrConsumption` |
| `powerPs` | int? | from CarQuery `model_engine_power_ps` |
| `source` | enum | `carquery` \| `manual` |
| `catalogRef` | text? | CarQuery model id, for traceability |

**FillUp** (refuel)
| Field | Type | Notes |
|---|---|---|
| `id` | int (pk) | |
| `vehicleId` | int (fk) | |
| `date` | datetime | |
| `amount` | double | € spent |
| `liters` | double? | null for imported historical rows |
| `odometer` | double | km on the odometer at refuel |
| `isFull` | bool | full tank vs partial; drives consumption algorithm |
| `rangeKm` | double? | range displayed by the car (the old Excel "Autonomia") |
| `station` | text? | brand/station |
| `categoryId` | int (fk) | "Mine" / "Not mine" (extensible) |
| `note` | text? | |
| `latitude` / `longitude` | double? | optional |
| `receiptPhotoPath` | text? | local file path |
| `createdAt` / `updatedAt` | datetime | |

**Category** (extensible; seeded with the two the user has today)
| Field | Type | Notes |
|---|---|---|
| `id` | int (pk) | |
| `name` | text | "Mine", "Not mine", … |
| `color` | int | |
| `isDefault` | bool | default selection on new fill-up |

### Relationships
- `Vehicle 1—* FillUp`
- `Category 1—* FillUp`
- Deleting a vehicle cascades to its fill-ups (with a confirm dialog). Categories cannot
  be deleted while referenced (reassign first).

## 4. Vehicle catalog integration (CarQuery)

**Source:** CarQuery API (free, no API key, attribution for non-commercial use).
Endpoints: `getMakes`, `getModels` (per make + year), `getTrims` (per make/model/year).

**Flow (Add Vehicle wizard):**
1. Online check. If offline → skip straight to manual entry (clear message).
2. Make dropdown ← `getMakes`.
3. Model dropdown ← `getModels?make=&year=`.
4. Year + Trim dropdowns ← `getTrims`.
5. On trim selection, map fields into `VehicleSpecs` and pre-fill an **editable** form:
   - `model_fuel_cap_l` → `tankCapacityL`
   - `model_lkm_mixed` → `mfrConsumption`
   - `model_engine_power_ps` → `powerPs`
   - `model_engine_fuel` → `fuelType` (mapped to our enum)
   - `mfrRangeKm` derived if not provided.
6. User can edit any field, then saves. `specs.source` = `carquery` (or `manual` if the
   user typed everything). `catalogRef` keeps the CarQuery model id.

**Robustness:**
- CarQuery often wraps JSON in a JSONP envelope `?(...)` — the client strips it before
  parsing. Requests sent from native Flutter, so no CORS concerns.
- dio with sensible timeouts + one retry; any failure degrades gracefully to manual entry.
- Coverage is imperfect for the latest EU trims; the manual fallback is the contract that
  makes the feature always usable.
- Specs are **snapshotted** into the Vehicle row, so the app is fully offline afterward and
  the comparison baseline never drifts if CarQuery changes.

## 5. Metrics and consumption logic

Derived on the fly (not persisted), with a small cache layer for stats screens.

**Per fill-up**
- `pricePerLiter = amount / liters` (when liters present).
- `distance = odometer − previousOdometer(sameVehicle)`.

**Consumption — full-to-full algorithm (the careful bit):**
Real consumption is only computed between two **full** tanks. Partial fills in between
accumulate their liters and distance into the next full-tank interval:

```
For a vehicle's fill-ups ordered by odometer:
  find consecutive full-tank fill-ups F_prev … F_curr
  litersInInterval  = sum of liters of all fill-ups AFTER F_prev up to and incl. F_curr
  distanceInInterval = odometer(F_curr) − odometer(F_prev)
  L/100km = litersInInterval / distanceInInterval * 100
  km/L    = distanceInInterval / litersInInterval
  €/100km = (sum of amount in interval) / distanceInInterval * 100
```

Edge cases:
- A lone partial fill yields no consumption number on its own (shown as "—").
- Missing `liters` (imported history) → interval consumption is null, shown as "—".
- Odometer not strictly increasing → non-blocking warning at entry; interval skipped.
- First-ever fill-up has no previous reference → distance/consumption null.

**Aggregates (StatsService)**
- Total / monthly spend, average €/L, average consumption, total km.
- Split by category (Mine vs Not mine), matching the spreadsheet's totals.

**Comparisons (RangeComparator)**
- Real average consumption vs `specs.mfrConsumption` (Δ and %).
- Real range achieved on a full tank vs `specs.mfrRangeKm`.

## 6. Excel/CSV import

**Input:** the user's `Consumi.xlsx` (and generic CSV later).

Spreadsheet shape (sheet1): row 1 = car name; row 2 = headers
`Data | Importo [€] | Kilometraggio [km] | Autonomia [km] | Differenza [km]`;
data rows from row 3. Dates are Excel serial numbers; `Differenza = Kilometraggio + Autonomia`.

**Mapping:**
- `Data` (serial) → `FillUp.date`
- `Importo` → `amount`
- `Kilometraggio` → `odometer`
- `Autonomia` → `rangeKm`
- `Differenza` → ignored (derived).
- `liters` → **null** (not in the sheet) ⇒ historical consumption shown as "—".
- The category split (`SPESE MIE` / `SPESE NON MIE` in column G) is metadata, not per-row;
  imported rows default to category "Mine", editable afterward.

**Behavior:**
- One-shot import from Settings; row-by-row summary (imported / skipped / warnings).
- The anomalous first row (300 €, odometer 0) is flagged, not silently dropped — the user
  decides whether to keep it.
- Import is idempotent-ish: a re-import warns about likely duplicates (same vehicle + date +
  odometer) instead of blindly doubling the data.

## 7. Backup / export

- **Export:** full dataset to **JSON** (lossless, versioned schema) and to **CSV**
  (human-friendly, fill-ups flattened). Shared via `share_plus`.
- **Import/restore:** pick a JSON backup (`file_picker`), validate `schemaVersion`, restore.
- Round-trip (export → import) is covered by tests.

## 8. Screens / UX

Material 3, light/dark, seed color; bottom navigation.

1. **Dashboard** — vehicle selector; key-stat cards (total spend, avg €/L, avg consumption,
   total km, last fill-up); one headline chart; FAB "Add refuel".
2. **Add/Edit fill-up** — amount, liters (live €/L preview), odometer, date, full/partial
   toggle, category, station, note; optional GPS capture and receipt photo.
3. **History** — list grouped by month; each row shows date, amount, liters, €/L,
   interval consumption; swipe to edit/delete; filter by vehicle/category.
4. **Stats** — charts: monthly spend, €/L trend, consumption trend, km/month,
   Mine-vs-Not-mine split; real-vs-declared comparison panel.
5. **Vehicles** — list/add/edit; Add-Vehicle wizard (catalog dropdowns + editable specs);
   set default.
6. **Settings** — theme, language, units/currency, backup/export, import, about + CarQuery
   attribution.

## 9. Architecture

Feature-first + layered. Each unit has one purpose, a clear interface, and is testable in
isolation. Domain depends on nothing; data implements domain interfaces; features (UI)
depend on domain.

```
lib/
  main.dart
  src/
    app/          # App widget, router (go_router), theme (Material 3)
    core/         # formatters, units, Result/Failure, extensions, constants
    l10n/         # ARB files (it, en) + generated
    data/
      database/   # Drift database, tables, DAOs, migrations
      catalog/    # CarQuery client + DTOs + CatalogRepository impl
      importer/   # Excel/CSV import
      backup/     # JSON/CSV export + restore
      repositories/ # Vehicle/FillUp/Category repository implementations
    domain/
      models/     # Vehicle, VehicleSpecs, FillUp, Category (freezed)
      repositories/ # abstract repository interfaces
      services/   # ConsumptionCalculator, StatsService, RangeComparator
    features/
      dashboard/  # screen + widgets + Riverpod providers
      fillups/
      vehicles/   # incl. add-vehicle wizard
      stats/
      settings/
```

**Unit responsibilities (examples)**
- `ConsumptionCalculator` — pure functions over ordered fill-ups → consumption intervals.
  No I/O. Heavily unit-tested.
- `CatalogRepository` — Make/Model/Trim lookups + spec mapping; hides JSONP/HTTP details.
- `FillUpRepository` — CRUD + queries; backed by Drift DAOs.
- `StatsService` — aggregates for the dashboard/stats from repository data.

## 10. Tech stack and dependencies

**Requirement:** use the **latest stable** version of every dependency, resolved at
implementation time via `flutter pub add` (do not hand-pin to older versions). Versions
below are the current latest confirmed on pub.dev on 2026-06-22 and set the API patterns to
follow.

| Concern | Package | Latest (2026-06-22) | Notes |
|---|---|---|---|
| State / DI | `flutter_riverpod` (+ `riverpod_annotation`, `riverpod_generator`) | **3.3.2** | Riverpod **3.x** APIs + code-gen `@riverpod` |
| Models | `freezed` (+ `freezed_annotation`, `json_serializable`) | **3.2.5** | Freezed **3.x**: `sealed`/`abstract class` + `with _$X` |
| Local DB | `drift` (+ `drift_dev`, `sqlite3_flutter_libs`) | **2.34.0** | type-safe SQLite, in-memory for tests |
| Routing | `go_router` | **17.3.0** | |
| Charts | `fl_chart` | **1.2.0** | |
| HTTP | `dio` | **5.9.2** | CarQuery client, timeouts/retry |
| i18n | `intl` + `flutter_localizations` | latest | ARB, it/en |
| Photo | `image_picker` + `path_provider` | latest | receipt photo |
| GPS | `geolocator` | latest | optional location |
| Import | `excel` | latest | reads `.xlsx` |
| Export | `csv`, `share_plus`, `file_picker` | latest | backup/export |
| Prefs | `shared_preferences` | latest | settings |
| Build | `build_runner` | latest | codegen for freezed/riverpod/drift |
| Test | `flutter_test`, `mocktail` | latest | |

- **Android:** `minSdk 24`, `applicationId io.github.zn3utr4l.tanko`.
- **Theming:** Material 3, `ColorScheme.fromSeed`, light/dark.

## 11. Error handling and validation

- `Result`/`Failure` sealed types (freezed) for DB and network operations; UI surfaces
  readable snackbars/dialogs.
- Catalog offline/failure → graceful fallback to manual entry, never a hard error.
- Form validation: `amount > 0`, `liters > 0` when present, valid date.
- Odometer monotonicity: non-blocking warning when an entry's odometer is below the previous
  one for the same vehicle.
- Backup restore validates `schemaVersion` before touching the DB.

## 12. Testing strategy (TDD)

Write tests first for the units that carry the logic:
- **Unit:** `ConsumptionCalculator` (full-to-full, partial fills, missing liters, odometer
  regressions), `StatsService` aggregates, `RangeComparator`.
- **Parsing:** CarQuery DTO parsing incl. JSONP stripping; Excel importer against a sample
  `.xlsx`; backup JSON round-trip.
- **DB:** DAO tests on in-memory Drift.
- **Widget:** fill-up form validation, dashboard rendering, add-vehicle wizard happy path +
  offline fallback.
- Coverage reported in CI.

## 13. CI/CD and distribution

Mirrors the personal NE.* convention (PR-gated CI, branch protection, auto-release CD):
- `ci-tanko.yml` (PR-gated): `flutter analyze` + `dart format --set-exit-if-changed` +
  `flutter test --coverage`.
- `ci-version-bump.yml`: bump `pubspec.yaml` version on merge to `main`.
- `cd-release.yml`: create a GitHub release on tag.
- `cd-apk.yml`: build a **signed** release APK on tag (keystore + passwords in repo secrets),
  attach to the release.
- Branch protection on `main`; git identity **zN3utr4l**.
- Distribution: sideload signed APK (no Play Store in v1).

## 14. Implementation phasing

The plan will stage v1 so each phase is shippable/testable:
1. **Core** — Drift schema + repositories, Add/Edit fill-up, Dashboard, Excel import.
2. **Catalog** — Add-Vehicle wizard with CarQuery dropdowns + editable specs + snapshot.
3. **Stats & comparison** — charts, aggregates, real-vs-declared comparison.
4. **Backup** — JSON/CSV export + restore.
5. **CI/CD** — workflows, signing, branch protection, first signed APK.

## 15. Risks and mitigations

- **CarQuery coverage/uptime** (esp. latest EU trims): mitigated by always-available manual
  entry and by snapshotting specs locally. The app never depends on the API at runtime
  beyond the one-time vehicle setup.
- **Scope size** (v1 is broad): mitigated by phasing (§14); each phase is independently
  valuable.
- **Imported history lacks liters**: consumption for historical rows is honestly shown as
  "—" rather than estimated; going forward liters are logged.

## 16. Open questions

None blocking. Settings defaults (units/currency = €/L/km, default category = "Mine") are
chosen as sensible defaults and can be revisited during implementation.
