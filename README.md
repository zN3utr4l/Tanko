# Carburo ⛽

> App display name: **Carburo**. Repository / package id: `carburo` (`io.github.zn3utr4l.carburo`).

Free, open-source, **local-first** Android app to track fuel/refueling expenses:
how much you spend, your real price per liter, real consumption (L/100km, km/L),
and how your real figures compare to the **manufacturer-declared** specs.

All data lives on the device (SQLite) — no account, no server, no cost. Adding a
car uses a **bundled offline catalog** to suggest makes/models and pre-fill
specs; anything not in the catalog can simply be typed in.

> The UI is in Italian; the codebase and docs are in English.

## Features

- **Multi-vehicle** garage.
- **Rich fill-up logging**: amount, liters, odometer, full/partial, station,
  category (mine / not mine), notes.
- **Real metrics**: price/L, full-to-full consumption (L/100km, km/L, €/100km),
  monthly spend, totals — derived automatically.
- **Add a vehicle fast**: type-ahead Make/Model fields backed by a bundled
  offline catalog auto-fill tank capacity, declared consumption, power and fuel
  type. Every field stays editable, and anything not in the catalog is just
  typed in — no network required.
- **Real vs declared comparison**: measured consumption/range against the
  manufacturer specs.
- **Charts**: monthly spend, price/L trend.
- **Excel import**: bring in your old `Consumi.xlsx` history.
- **Backup**: versioned JSON export/restore + CSV export.

## Stack

Flutter · **Riverpod 3** (code-gen) · **drift** (SQLite, local-first) ·
**freezed** · go_router · fl_chart · intl. Tests with `flutter_test` + in-memory
drift. Clean feature-first / layered architecture (`domain` is pure and has no
I/O).

## Quick start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run                 # debug on a connected device/emulator

flutter analyze
flutter test                # unit + widget tests
flutter build apk --release # release APK (debug-signed without a keystore)
```

After changing models/DB/providers, re-run `build_runner`. Generated files
(`*.g.dart`, `*.freezed.dart`) are analyzer-excluded — never hand-edit them.

## CI / CD

GitHub Actions, gated through PRs to `main` (mirrors the personal NE.* template):

- **CI** (`ci-carburo.yml`) — `flutter analyze` + tests + coverage + OSV scan.
- **Version guard** (`ci-version-bump.yml`) — when `lib/` or `pubspec.yaml`
  changes, the `x.y.z` in `pubspec.yaml` must be a new, unreleased version.
- **CD** (`cd-release.yml`) — on push to `main`, build the APK and publish a
  `v<version>` GitHub Release with the APK attached.

## Release signing

The release APK is **debug-signed** unless these repository secrets are set, in
which case it is signed with your upload keystore (required for stable
over-install updates):

| Secret | Meaning |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 release.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | keystore (store) password |
| `ANDROID_KEY_ALIAS` | key alias |
| `ANDROID_KEY_PASSWORD` | key password |

Generate one with:

```bash
keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias carburo
base64 -w0 release.jks   # paste into ANDROID_KEYSTORE_BASE64
```

`key.properties` and `*.jks` are git-ignored — never commit them.

## License

MIT — see [LICENSE](LICENSE).
