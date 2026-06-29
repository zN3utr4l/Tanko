# App Visual Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refresh Carburo's global styling and dashboard so the app feels more curated while keeping the existing information architecture.

**Architecture:** Keep the current Flutter/Riverpod structure. Add visual richness through `appTheme`, `DashboardScreen`, and `StatCard`; do not introduce new state, new packages, or a broad screen-by-screen redesign.

**Tech Stack:** Flutter Material 3, Riverpod providers already present in the app, existing widget tests.

---

### Task 1: Theme Token Refresh

**Files:**
- Modify: `lib/src/app/theme.dart`
- Test: `test/app/theme_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/app/theme_test.dart` with assertions for the light palette, app bar background, card surface, navigation bar, filled buttons, and input shapes.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/app/theme_test.dart`
Expected: FAIL because the current theme is generated only from `Colors.teal`.

- [ ] **Step 3: Write minimal implementation**

Update `appTheme` with explicit light/dark color schemes and component themes for scaffold, app bar, cards, navigation bar, FAB, buttons, chips, and inputs.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/app/theme_test.dart`
Expected: PASS.

### Task 2: Dashboard Cockpit

**Files:**
- Modify: `lib/src/features/dashboard/dashboard_screen.dart`
- Modify: `lib/src/features/dashboard/widgets/stat_card.dart`
- Test: `test/features/dashboard_test.dart`

- [ ] **Step 1: Write the failing test**

Extend `dashboard_test.dart` to expect a `dashboard-hero`, visible `Rifornimento` and `Spesa` actions, and metric keys such as `metric-total-cost`.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/dashboard_test.dart`
Expected: FAIL because the current dashboard has only a title, grid, and hidden FAB action sheet.

- [ ] **Step 3: Write minimal implementation**

Add a vehicle hero, visible action strip, and icon/accent-aware metric cards using the existing stats and cost providers.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/dashboard_test.dart`
Expected: PASS.

### Task 3: Verification and PR Update

**Files:**
- All changed files from Tasks 1 and 2.

- [ ] **Step 1: Format**

Run: `dart format lib/src/app/theme.dart lib/src/features/dashboard/dashboard_screen.dart lib/src/features/dashboard/widgets/stat_card.dart test/app/theme_test.dart test/features/dashboard_test.dart`
Expected: files formatted without errors.

- [ ] **Step 2: Analyze**

Run: `flutter analyze`
Expected: `No issues found`.

- [ ] **Step 3: Test**

Run: `flutter test`
Expected: all tests pass.

- [ ] **Step 4: Commit and push**

Run: `git add -A && git commit -m "Refresh app visuals and dashboard" && git push`
Expected: PR #17 receives the new visual refresh commit.
