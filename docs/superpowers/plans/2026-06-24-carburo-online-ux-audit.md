# Carburo Online Lookup and UX Audit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add optional online vehicle assistance and close the audited UX gaps without breaking the local-first app.

**Architecture:** Keep network behavior behind settings and services. Update UI surfaces incrementally, reusing current repositories and Riverpod providers.

**Tech Stack:** Flutter, Riverpod, Drift, SharedPreferences, Flutter widget tests.

---

### Task 1: Network Foundation

**Files:**
- Modify: `android/app/src/main/AndroidManifest.xml`
- Create: `lib/src/domain/services/vehicle_lookup_service.dart`
- Create: `lib/src/data/settings/lookup_settings.dart`
- Modify: `lib/src/providers.dart`
- Test: `test/domain/vehicle_lookup_service_test.dart`
- Test: `test/data/lookup_settings_test.dart`
- Test: `test/domain/android_manifest_test.dart`

- [ ] Write failing tests for internet permission, lookup parsing, and settings defaults.
- [ ] Add `INTERNET` to the release manifest.
- [ ] Implement plate normalization, official URLs, pasted text parsing, and settings persistence.
- [ ] Register providers.
- [ ] Run targeted tests.

### Task 2: Vehicle Wizard Assistance

**Files:**
- Modify: `lib/src/features/vehicles/add_vehicle_wizard_screen.dart`
- Test: `test/features/add_vehicle_wizard_test.dart`

- [ ] Write failing widget tests for plate input, official verification actions, and pasted lookup prefill.
- [ ] Add plate field, lookup assist section, and pasted-result parser.
- [ ] Preserve offline catalog/autocomplete behavior.
- [ ] Run targeted tests.

### Task 3: Import, Backup, and Movement UX

**Files:**
- Modify: `lib/src/data/importer/excel_importer.dart`
- Modify: `lib/src/domain/models/import_result.dart`
- Modify: `lib/src/data/backup/backup_service.dart`
- Modify: `lib/src/features/settings/settings_screen.dart`
- Modify: `lib/src/features/movimenti/movimenti_screen.dart`
- Test: `test/data/excel_importer_test.dart`
- Test: `test/data/backup_service_test.dart`
- Test: `test/features/movimenti_screen_test.dart`

- [ ] Write failing tests for duplicate skip, backup v3, target vehicle chooser, and movement delete.
- [ ] Implement duplicate detection in importer.
- [ ] Let settings choose the import target vehicle.
- [ ] Add movement search/filter/delete and provider invalidation.
- [ ] Run targeted tests.

### Task 4: Calendar and Stats

**Files:**
- Modify: `lib/src/features/calendar/calendar_screen.dart`
- Modify: `lib/src/features/stats/stats_screen.dart`
- Modify: `lib/src/features/stats/stats_providers.dart`
- Test: `test/features/calendar_test.dart`
- Test: `test/features/stats_test.dart`

- [ ] Write failing widget tests for opening calendar events and stats range filtering.
- [ ] Link fuel/expense/reminder events to edit/complete flows.
- [ ] Add stats range selector and simple insights.
- [ ] Run targeted tests.

### Task 5: Verification

**Files:**
- Generated outputs from `build_runner`

- [ ] Run `dart run build_runner build --delete-conflicting-outputs`.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Summarize any external provider limitation that remains by design.
