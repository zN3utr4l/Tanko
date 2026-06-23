# Carburo — AI Project Memory

Persistent memory for AI assistants working in this repo. Keep it short and
current; move detail into the linked files.

## Workflow rules

- Read [project-map.md](project-map.md) before navigating the code, and
  [gotchas.md](gotchas.md) before editing or shipping.
- `main` is PR-gated: branch → push → PR → green `build-and-test (ubuntu-latest)`
  + `version-check` → merge. Bump `pubspec.yaml` `x.y.z` when `lib/` changes and
  add a root `CHANGELOG.md` entry; CD releases `v<version>` (APK attached).
- After changing models / DB / providers, regenerate:
  `dart run build_runner build --delete-conflicting-outputs`.
- Run bare `flutter analyze` (whole project) and `flutter test` before pushing.
- Commit as **zN3utr4l** (git `includeIf` by path). Not a fork — plain `gh`.

## Current state (2026-06-22)

- `pubspec.yaml` is `version: 0.3.0+4`.
- Released: v0.2.0, v0.2.1. v0.3.0 in flight (offline catalog + smart wizard +
  tappable first-run empty-state + new icon + repo structure alignment).
- Merged so far: #1 (Drivvo features), #2 (rebrand to Carburo).

## Project identity

- Local-first Flutter **Android** app to track fuel/vehicle costs and compare
  them to manufacturer specs. All data on-device (SQLite). UI Italian, code English.
- Repo `github.com/zN3utr4l/Carburo`; package `carburo`; appId
  `io.github.zn3utr4l.carburo`. Originally "Tanko", fully rebranded.
- Feature-first + layered: `features/` (UI, Riverpod) → `domain/` (pure) ←
  `data/` (I/O). Riverpod 3 · drift · freezed 3 · go_router.

## Quick reference

| Task | Command |
|------|---------|
| Get deps | `flutter pub get` |
| Codegen | `dart run build_runner build --delete-conflicting-outputs` |
| Run | `flutter run` |
| Analyze | `flutter analyze` (from repo dir) |
| Test | `flutter test` |
| Launcher icons | `dart run flutter_launcher_icons` |

## Index

- [project-map.md](project-map.md) — module/layer map of `lib/`
- [gotchas.md](gotchas.md) — Freezed/drift/Riverpod/test/CI landmines
- [changelog.md](changelog.md) — AI working log of notable changes
