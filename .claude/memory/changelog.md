# Changelog (AI working log)

Chronological log of notable AI-assisted changes, newest first. Release history
lives in the root `CHANGELOG.md`; this is the working/tooling log.

## 2026-06-22 — Offline catalog + UX fixes + repo structure (v0.3.0)

**Catalog (root cause + fix)**
- CarQuery API confirmed dead: `HTTP 502` + support portal "Account Suspended"
  (verified via WebFetch, bypassing the corporate proxy). This was the cause of
  the "catalogo non raggiungibile" / infinite-spinner bug.
- Replaced with an **offline bundled catalog**: `assets/catalog/catalog.json`
  (36 makes / ~270 EU models, representative specs) + `OfflineCatalog`. Removed
  `dio`, the CarQuery client/parser, and their test.
- Add-Vehicle wizard rebuilt as a single smart form: type-ahead Make/Model over
  the catalog, specs pre-fill on match, free-text fallback. No more
  Catalogo/Manuale toggle or dead-end error. `SpecSource.carquery` → `.catalog`.
- Checked free alternatives: NHTSA vPIC + FuelEconomy.gov are up but US-centric
  with no EU consumption/tank — offline is the chosen answer.

**UX**
- First-run empty state ("Aggiungi un veicolo per iniziare") is now a shared
  tappable `EmptyVehiclePrompt` across 5 screens → opens the wizard on any tap.
- Fixed latent refresh bug: `dashboardVehicleProvider` now derives from
  `vehiclesProvider`, so adding the first vehicle updates all screens at once.
- New app icon: fuel gauge + € sign (replaced the drop that "looked like an egg").

**Repo structure (aligned to NE*/Personal convention)**
- Added `.gitattributes`, `CHANGELOG.md`, `CONTRIBUTING.md`, `.claude/memory/`.
- Removed stale `tanko.iml`; fixed placeholder `pubspec.yaml` description.
- Updated README + CLAUDE.md/AGENTS.md (resynced) for the offline catalog.

**Verification**: `flutter analyze` clean; `flutter test` 63/63 green (incl. new
wizard test + `OfflineCatalog` unit test). Not run on a device (no emulator).
