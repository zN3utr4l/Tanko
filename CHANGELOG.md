# Changelog

All notable changes to Carburo are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html). Each release maps to
a `v*` Git tag — the same tags the CD workflow attaches the APK to.

## [0.5.7] — 2026-06-24

### Fixed
- **Excel import no longer silently corrupts the calendar and stats.** A single
  garbage date cell in the source file (e.g. an odometer value typed into the
  date column) was converted into an absurd far-future date (year 20205), which
  dragged the stats chart's time axis across millennia — squashing every real
  bar to invisibility — and made the row unreachable in the calendar. The
  importer now skips rows whose date falls outside a plausible range (before
  1990 or in the future) and reports them as a warning, instead of importing
  them. The rest of the file imports normally.
- **The "Import completato" dialog could not be dismissed.** Because Settings is
  pushed onto a per-tab (branch) navigator, the OK button popped the branch
  navigator instead of the dialog, so the dialog stayed up (and Settings closed
  underneath). OK now pops the dialog's own route.

## [0.3.0] — 2026-06-22

### Changed
- **Vehicle catalog is now fully offline.** The Add-Vehicle catalog used the
  CarQuery online API, which is unreliable and was returning `502` / "account
  suspended". It is replaced by a curated, bundled catalog (36 makes, ~270
  models with representative EU specs) so make/model lookup works instantly and
  never fails on the network. Removed the `dio` dependency.
- **Add-Vehicle wizard redesigned as a single smart form.** Make and Model are
  type-ahead fields: typing suggests catalog matches and picking a known model
  pre-fills its specs. Anything not in the catalog can simply be typed in. The
  separate "Catalogo / Manuale" toggle and the "catalog unreachable" dead-end
  are gone.

### Fixed
- **First-run empty state is now actionable.** The "Aggiungi un veicolo per
  iniziare" screen (shown on Home, Calendario, Scadenze, Statistiche and
  Movimenti) is tappable anywhere and opens the Add-Vehicle screen. Adding the
  first vehicle now refreshes every screen immediately (the current-vehicle
  provider is derived from the vehicle list).

### Added
- New app icon: a fuel gauge with a euro sign, replacing the previous drop mark.

## [0.2.1] — 2026

### Changed
- Full rebrand from "Tanko" to **Carburo** (display name, package id
  `io.github.zn3utr4l.carburo`), new launcher icon, and enabled release signing.

## [0.2.0] — 2026

### Added
- Drivvo-style cost tracking: general expenses, reminders (scadenze) with
  Italian templates and a completion flow, a unified calendar, a movimenti
  (fuel + expenses) list, and a 5-tab bottom navigation.
- Backup v2 (export/import) and best-effort local notifications.
- Fuel tracking with full-to-full consumption and manufacturer-spec comparison.
