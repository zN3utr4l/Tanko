# Project Map

Feature-first + layered Flutter app under `lib/src/`. One direction:
`features/` (UI) → `domain/` (pure) ← `data/` (I/O). `providers.dart` is the
composition root.

## `lib/src/domain/` — pure types + services (no I/O)
- `models/` — freezed data classes: `Vehicle`/`VehicleSpecs`, `FillUp`,
  `Expense`, `Category`, `Reminder` (+`ReminderEvaluation`), `Catalog*`,
  `CostSummary`, `VehicleStats`, `ConsumptionInterval`, `Comparison`,
  `Monthly*`, `BackupData`, `ImportResult`; `enums.dart`.
- `services/` — `ConsumptionCalculator`, `StatsService`, `RangeComparator`,
  `ReminderEvaluator` (heavily unit-tested).
- `repositories/` — repository interfaces (vehicle, fill_up, expense, category,
  reminder, **catalog**).

## `lib/src/data/` — adapters (I/O)
- `database/` — drift `AppDatabase` (schemaVersion **2**), `tables.dart`,
  `mappers.dart`, `connection.dart`.
- `repositories/` — drift-backed repository impls.
- `catalog/` — `OfflineCatalog` (loads bundled `assets/catalog/catalog.json`).
- `importer/` — `excel_importer.dart` (old `Consumi.xlsx`).
- `backup/` — `backup_service.dart` (JSON v2 + CSV).
- `notifications/` — `NotificationService` (flutter_local_notifications, best-effort).

## `lib/src/features/` — UI (Riverpod Consumer widgets)
- `dashboard/`, `calendar/`, `reminders/` (scadenze), `stats/`, `altro/`,
  `movimenti/` (fuel+expenses), `expenses/`, `fillups/`, `settings/`.
- `vehicles/` — `vehicles_screen`, `vehicle_form_screen`,
  `add_vehicle_wizard_screen` (smart type-ahead catalog form),
  `catalog_providers`, `widgets/empty_vehicle_prompt.dart` (shared tappable
  first-run empty state → wizard).
- `dashboardVehicleProvider` is the single "current vehicle" source (default
  else first), derived from `vehiclesProvider`.

## `lib/src/app/` — `app.dart`, `router.dart` (go_router, 5-tab shell), `theme.dart`.
## `lib/src/core/` — `formatters.dart`, `result.dart`.
## Entry point — `lib/main.dart`.

## Persistence
drift SQLite under `getApplicationDocumentsDirectory()`. Reminder status is
**derived** (never stored); categories carry a `kind` (fuel|expense).
