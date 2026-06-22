# Tanko — Design Addendum: Scadenze, Costi generali, Calendario

- **Date:** 2026-06-22
- **Status:** Approved (one-PR additions to the v1 design)
- **Author:** Giuseppe Chirico (zN3utr4l)
- **Builds on:** `2026-06-22-tanko-design.md`
- **Ships in:** ONE pull request (`feat/drivvo-features`). `lib/`/`pubspec.yaml` change ⇒ bump version; CD releases the APK on merge.

## 1. Overview

Extends Tanko from a fuel tracker into a Drivvo-style vehicle cost manager, staying
local-first and keeping the feature-first/layered architecture. Three modules:

1. **Costi generali (Expenses)** — any non-fuel cost (insurance, bollo, revisione,
   fines, tolls, parking, wash, accessories, repairs, custom).
2. **Scadenze (Reminders)** — dual-trigger (date / odometer / both), completion-anchored
   recurrence, fixed-date seasonal variant, lead time, on-device notifications,
   pre-seeded Italian templates.
3. **Calendario** — month grid aggregating fuel-ups, expenses, reminder due-dates +
   day-detail bottom sheet.

Plus **cost-of-ownership** dashboard/stats additions and **backup v2** coverage.

Load-bearing logic stays in `domain/` as pure, unit-tested functions — `ReminderEvaluator`
joins `ConsumptionCalculator`/`StatsService`/`RangeComparator`.

## 2. Data model

### 2.1 Reuse `Categories` with a `kind` discriminator

Extend the existing `Categories` table (already backs `FillUp.categoryId`, seeded
'Mine'/'Not mine') rather than add a separate expense-category table. Every picker/query
MUST filter by `kind`. Migration backfills existing rows to `kind='fuel'`.

New columns:
```dart
TextColumn get kind => text().withDefault(const Constant('fuel'))();   // fuel | expense
IntColumn get iconCode => integer().nullable()();                       // Material icon codepoint
IntColumn get ord => integer().withDefault(const Constant(0))();
```

### 2.2 `Expenses` (NEW) — `@DataClassName('ExpenseRow')`

`id, vehicleId(FK cascade), date, odometer?, categoryId(FK, kind=expense), amount,
description?, isRecurring(def false), reminderId?(FK Reminders setNull),
receiptPhotoPath?, createdAt, updatedAt`.

### 2.3 `Reminders` (NEW) — `@DataClassName('ReminderRow')`

`id, vehicleId(FK cascade), type, title, triggerMode(DATE|DISTANCE|BOTH), dueDate?,
dueOdometer?, recurEvery?, recurUnit?(DAY|MONTH|YEAR|KM|FIXED_DATE), recurKmEvery?,
leadDays?, leadKm?, notify(def true), lastCompletedDate?, lastCompletedOdometer?,
linkedExpenseCategoryId?, active(def true), createdAt, updatedAt`. **Status is derived,
never stored.**

> FK ordering: declare `Reminders` before `Expenses` in `@DriftDatabase(tables: [...])`
> and create `reminders` before `expenses` in `onUpgrade`.

### 2.4 Migration 1 → 2

`schemaVersion => 2`. `onUpgrade(from<2)`: addColumn kind/iconCode/ord, backfill
`UPDATE categories SET kind='fuel'`, createTable reminders, createTable expenses, seed
expense categories. Keep `PRAGMA foreign_keys = ON` in beforeOpen. Seeded expense
categories (Italian, kind='expense'): Assicurazione, Bollo, Revisione, Multe, Pedaggi,
Parcheggio, Autolavaggio, Accessori, Riparazioni, Altro (color + iconCode each).
**A drift migration test (open v1 → migrate → assert) is mandatory.**

## 3. Domain

Enums: `CategoryKind {fuel, expense}`, `ReminderType {bollo, assicurazione, revisione,
tagliando, gomme, patente, custom}`, `TriggerMode {date, distance, both}`,
`RecurUnit {day, month, year, km, fixedDate}`, `ReminderStatus {ok, upcoming, overdue, completed}`.

Models (freezed, `abstract class … with _$X`, fromJson): `Expense`, `Reminder`,
`ReminderEvaluation {reminder, status, daysRemaining?, kmRemaining?}`. Extend `Category`
with `kind`, `iconCode?`, `ord` (defaults keep v1 JSON backward-compatible).

### 3.1 `ReminderEvaluator` (pure)

Status given `today` + `currentOdometer` (= max odometer across fuel-ups + expenses):
```
dueByDate = dueDate != null && !today.isBefore(dueDate)
dueByKm   = dueOdometer != null && currentOdo >= dueOdometer
OVERDUE   if dueByDate || dueByKm
UPCOMING  else if (leadDays!=null && today >= dueDate-leadDays) || (leadKm!=null && currentOdo >= dueOdometer-leadKm)
OK        otherwise
daysRemaining = dueDate==null ? null : dueDate.difference(today).inDays
kmRemaining   = dueOdometer==null ? null : dueOdometer - currentOdo
```
`nextOccurrence(reminder, completedDate, completedOdo)`: DAY/MONTH/YEAR → date+interval;
KM → odo+(recurKmEvery??recurEvery); BOTH → both; FIXED_DATE → next calendar (month,day)
after completedDate; one-shot → none. Set `lastCompleted*` to the completion anchor.

## 4. Completion flow & notifications

`ReminderRepository.complete(id, date, odometer, {createExpense})`: optionally insert a
linked `Expense`; if recurring update next due + lastCompleted*, else `active=false`;
reschedule notifications.

`NotificationService` (data/notifications) wraps `flutter_local_notifications` + `timezone`:
`init()` (tz init + request POST_NOTIFICATIONS, degrade gracefully), `scheduleDateReminder`
(`zonedSchedule` at dueDate-leadDays, `AndroidScheduleMode.inexactAllowWhileIdle`, NO
exact-alarm permission), `rescheduleAll()`, `cancel`. **Distance reminders can't be
pre-scheduled** → re-evaluate on every odometer entry and fire immediately past
`dueOdometer - leadKm`. All calls guarded (best-effort; never crash the app).

## 5. Italian scadenze templates

Revisione (DATE, first due explicit then YEAR×2), Bollo (DATE, YEAR×1), Assicurazione RCA
(DATE, YEAR×1), Tagliando (BOTH, YEAR×2 or ~20000 km), Cambio gomme estive (FIXED_DATE
15/04), Cambio gomme invernali (FIXED_DATE 15/11), Patente (optional, YEAR×10).

## 6. Screens / UX (Material 3, IT)

5-tab nav: **Dashboard · Calendario · Scadenze · Statistiche · Altro** (Altro = sheet with
Veicoli + Impostazioni). Per-type accent colors used identically on calendar dots / list
icons / donut: fuel=teal, expense=amber (or category color), reminder=indigo, overdue=red.

- **Calendario** — `table_calendar` month grid, ≤3 dots/day (one per TYPE), day → bottom
  sheet listing entries + "Aggiungi per questo giorno" pre-filled; agenda list of the
  selected day shown by default.
- **Scadenze** — list sorted overdue→upcoming→ok; cards with type icon, title, vehicle,
  color-coded status chip ("Scaduto da X giorni / Y km" / "Tra X…" / "OK"). Add via template
  picker → editable form. Complete via bottom sheet (date/odometer, "Registra anche la spesa").
- **Spesa form** — mirrors the fill-up form: amount, expense-category chooser (color+icon),
  M3 DatePicker, optional odometer (non-blocking monotonic warning), description, recurring
  toggle, optional receipt photo (image_picker).
- **Dashboard/Stats** — KPI cards (Total cost = fuel+expenses, Cost/km, Cost/month, fuel
  economy) → category donut (fuel + expense slices, legend €+%) → monthly stacked bar
  (fuel vs expense). Period selector drives all.
- **Movimenti** — renamed History, lists fuel-ups + expenses with a type filter chip.

Accessibility: 48×48dp targets, ≥4.5:1 contrast, never color-only (pair with icon/label),
distinct today/selected/has-events/overdue states.

## 7. StatsService additions (pure, tested)

`totalCost(period) = fuelSpend + expenseSpend`, `costPerKm`, `costPerMonth`, `categoryShare`
(fuel + each expense category → €+%), `monthlyStacked` (per month fuel vs expense). Tested
with mixed fixtures + period filtering.

## 8. Backup v2

`BackupData` gains `expenses`, `reminders`; `schemaVersion` default → 2. `BackupService`
`currentSchemaVersion = 2` but **accepts v1 and v2** (v1 → empty new lists). Add
`expensesCsv`. v1 category JSON without `kind` deserializes to default `fuel`. Round-trip
tested for both versions.

## 9. Packages & Android setup (resolve latest via `flutter pub add`)

| Package | ~Version | Android setup |
|---|---|---|
| `table_calendar` | ^3.2 | none (pure Dart) |
| `flutter_local_notifications` | ^22 | manifest POST_NOTIFICATIONS/VIBRATE/RECEIVE_BOOT_COMPLETED (NO exact-alarm); `<application>` receivers ScheduledNotificationReceiver + ScheduledNotificationBootReceiver (BOOT_COMPLETED + MY_PACKAGE_REPLACED); gradle `isCoreLibraryDesugaringEnabled = true` + `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")`; inexact scheduling |
| `timezone` | ^0.11 | none; `tz.initializeTimeZones()` at startup |
| `image_picker` | ^1.1 | none (system photo picker); copy file via path_provider |

## 10. TDD build order

1. **Migration first** (extend Categories, add tables, v2, onUpgrade) + migration test.
2. Domain models + enums (freezed) + JSON round-trip tests.
3. **`ReminderEvaluator`** — tests first (status matrix, recurrence incl. FIXED_DATE/BOTH).
4. Mappers + repositories (Expense, Reminder) following `FillUpRepositoryImpl`; DAO tests.
5. StatsService cost-of-ownership additions; unit tests.
6. Providers + feature providers; run build_runner.
7. NotificationService + manifest/gradle; distance re-evaluation hook.
8. UI — Spesa form, Scadenze list/form/complete sheet, Calendario + day sheet, dashboard/
   stats additions; widget tests.
9. Router — Calendario + Scadenze branches + add/edit routes (5-tab nav).
10. Backup v2 + expenses CSV; round-trip tests (v1 + v2).
11. `flutter analyze` + `dart format` + full `flutter test`; bump version; update CLAUDE.md/AGENTS.md.
    Add a PR-time Android APK build job to CI (native config now non-trivial).

## 11. Risks

Inexact scheduling (no exact-alarm, Android 14+); distance reminders re-evaluated on
odometer entry + daily wake; derived status never persisted; category `kind` leakage
(filter everywhere); migration correctness (only DB copy — mandatory test); desugaring
required for FLN 22; seasonal tyres need FIXED_DATE; revisione irregular first interval;
PR breadth mitigated by bottom-up TDD order; resolve dep versions via `flutter pub add`.
