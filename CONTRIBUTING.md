# Contributing

Carburo is open source under the MIT license. Contributions are welcome.

## Development setup

See [`README.md`](README.md) for prerequisites and how to build and run. After
changing models, the database, or providers, regenerate the code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Before submitting a PR, make sure the suite is green:

```bash
flutter analyze
flutter test
```

## Architecture

Feature-first + layered (one direction): `features/` (UI, Riverpod) →
`domain/` (pure models + services) ← `data/` (drift, catalog, backup). See
[`CLAUDE.md`](CLAUDE.md) for the full map, and `docs/superpowers/specs/` /
`docs/superpowers/plans/` for designs and implementation plans.

Put new logic in `domain/` as a pure, tested function whenever possible.

## Conventions

- **UI in Italian, code and docs in English.**
- **Lint:** run bare `flutter analyze` (whole project) before pushing.
  Generated `*.g.dart` / `*.freezed.dart` are analyzer-excluded — never
  hand-edit them.
- **Commits** use the **zN3utr4l** identity (git `includeIf`); verify before
  pushing.
- **Versioning:** when `lib/` or `pubspec.yaml` changes, bump `x.y.z` in
  `pubspec.yaml` and add an entry to [`CHANGELOG.md`](CHANGELOG.md). CD releases
  `v<version>` (APK attached) on merge to `main`.

## Pull requests

`main` is PR-gated with required checks. Open a PR against `main`; keep changes
focused and the tests green.
