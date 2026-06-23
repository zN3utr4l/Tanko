# Auto Station Detection — Design

**Date:** 2026-06-23
**Status:** Approved (brainstorming)
**Scope:** Single feature / single PR.

## Summary

When the user records a fuel fill-up *in the moment* (date ≈ now), Carburo tries
to figure out **which station** they are at, asks for confirmation, and pre-fills
the station name (plus GPS coordinates). When the user is no longer at the
station, it offers to read a photo of the **receipt** to auto-extract the
fill-up data. Everything always degrades to today's plain manual entry — the
feature is never blocking and never required.

The app stays **local-first**: GPS is read only on demand at fill-up time, and
the network is touched **only** if the user explicitly taps "search online".

## User-facing behaviour

On opening **"Nuovo rifornimento"**, if the form date is within a few minutes of
`now` (i.e. a real-time entry, not a back-dated one):

1. **Dialog** — "📍 Sei al distributore adesso?" with three actions:
   **[Sì]**, **[No]**, **[Inserisci dopo]**.

2. **Sì** → request location permission (first time only), read coordinates, then:
   - **History match** within ~80 m of a past fill-up that has coordinates and a
     station name → pre-fill the station name + store lat/lng. Show a chip
     "Eni Corso Francia · cambia".
   - **No match** → offer, in order, **[🔎 Cerca online]** (opt-in, one-shot) /
     **[📄 Usa scontrino]** / type by hand.

3. **No** → "Vuoi rilevare i dati dallo scontrino?" → pick/take a photo →
   **on-device OCR** extracts, best-effort, station name + amount + liters +
   price/L + date → pre-fill those fields (all editable) and attach the photo.

4. **Inserisci dopo** / permission denied / GPS off / any failure → the form
   behaves exactly as it does today (manual entry). **Never blocking.**

If the form date is **not** ≈ now (a back-dated fill-up), no dialog appears and
GPS is never read.

## Architecture

Follows the existing one-directional layering: **`features/` → `domain/` ← `data/`**.
New logic lives in `domain/` as pure, tested functions wherever possible.

### `domain/` (pure, unit-tested)

- **`StationMatcher`** (service) — `match(lat, lng, List<FillUp> history, {radiusMeters})`
  → nearest past fill-up with coordinates + a non-empty station name, within the
  radius (Haversine distance). Returns a `DetectedStation?`. Pure; no I/O.
- **`ReceiptParser`** (service) — `parse(List<String> ocrLines)` → `ReceiptData`.
  Best-effort extraction:
  - **station name** via brand keyword matching against a known-brand list
    (ENI, Agip, Q8, IP, Esso, Tamoil, Repsol, Beyfin, Api, TotalErg, …) plus a
    nearby street/town line when recognizable;
  - **amount / liters / price-per-liter / date** via regex over common Italian
    receipt patterns (e.g. `EURO`, `LITRI`, `€/L`, `dd/mm/yyyy`).
  - Every field is nullable; the parser never throws — unreadable fields are
    simply left null for manual entry.
- **Models (freezed):**
  - `DetectedStation` — `{ String name, double lat, double lng, double distanceMeters, StationSource source }`.
  - `ReceiptData` — `{ String? station, double? amount, double? liters, double? pricePerLiter, DateTime? date }`.
  - `StationSource` enum (in `domain/models/enums.dart`): `history | online | receipt | manual`.
- **Interfaces (abstract):** `LocationService`, `OcrService`, `StationLookupService`
  — so the I/O implementations are mockable in tests.

### `data/` (I/O, behind the domain interfaces)

- **`GeolocatorLocationService`** implements `LocationService` — wraps
  `geolocator`: checks/requests permission, returns current position; returns
  `null` on denial / disabled / timeout. Best-effort.
- **`MlKitOcrService`** implements `OcrService` — wraps
  `google_mlkit_text_recognition`: image path → list of text lines. Fully
  on-device / offline.
- **`OverpassStationLookup`** implements `StationLookupService` — `http` GET to
  the Overpass API for OSM `amenity=fuel` nodes near the coordinates. **No API
  key**, free, OSM-attributed. Invoked **only** when the user taps "Cerca
  online". Returns candidate stations; returns empty/null on network failure.

### `features/fillups/`

- **`StationDetectionController`** (Riverpod) — orchestrates the flow:
  location → `StationMatcher` → (optional) `StationLookupService`; and the
  receipt branch: `image_picker` → `OcrService` → `ReceiptParser`. Exposes a
  small state the form watches.
- **`FillUpFormScreen`** — shows the dialog when date ≈ now, renders the detected
  station chip, applies pre-filled values, and always allows manual override.

### `providers.dart` (composition root)

Register the three new services (`LocationService`, `OcrService`,
`StationLookupService`) and the `StationMatcher` / `ReceiptParser` domain
services, following the existing `@Riverpod(keepAlive: true)` pattern.

## Data flow

```
Open "Nuovo rifornimento" (date ≈ now)
   └─ dialog "Sei al distributore?"
        ├─ Sì → LocationService.current()
        │         ├─ StationMatcher.match(pos, history) → DetectedStation → pre-fill name + lat/lng
        │         └─ no match → [Cerca online → OverpassStationLookup] | [Usa scontrino] | manual
        ├─ No → image_picker → OcrService.read(photo) → ReceiptParser.parse(lines)
        │         → pre-fill station/amount/liters/price/date + attach photo
        └─ Inserisci dopo → plain manual form (current behaviour)
```

## Storage

**No schema migration.** The `FillUps` table already has `latitude`,
`longitude`, `station`, and `receiptPhotoPath`. The feature only starts
populating them. `StationSource` is used in-memory for UI provenance; it is
**not** persisted in v1 (YAGNI — can be added later if history ranking needs it).

## Dependencies & permissions

- **New packages:** `geolocator`, `google_mlkit_text_recognition`, `http`.
- **AndroidManifest:** `ACCESS_COARSE_LOCATION` + `ACCESS_FINE_LOCATION`
  (when-in-use), plus the ML Kit text-recognition `<meta-data>` for the bundled
  model.
- **Privacy / local-first:** GPS is read only on demand at fill-up time; the
  network is contacted **only** when the user explicitly taps "Cerca online"
  (with a one-time notice that coordinates are sent to OpenStreetMap). Photos and
  extracted data stay on the device. All paths degrade to manual entry.

## Error handling

- Permission denied / GPS disabled / location timeout → silently fall back to the
  manual form (optionally a small "posizione non disponibile" hint).
- OCR finds nothing / partial → pre-fill what was found, leave the rest blank.
- Overpass network error / no result → show "nessun distributore trovato", fall
  back to receipt/manual.
- The existing odometer-regression warning and validation are unchanged.

## Testing

- `StationMatcher` — pure unit tests: exact hit, just-inside / just-outside the
  radius, multiple candidates (nearest wins), empty history, missing coordinates.
- `ReceiptParser` — pure unit tests over sample OCR text from several Italian
  fuel-receipt layouts: brand detection, amount/liters/price/date extraction,
  graceful nulls on garbage input.
- I/O services are behind interfaces → mocked with `mocktail` in
  `FillUpFormScreen` widget tests covering: dialog appears only when date ≈ now;
  Sì→history-match pre-fills; No→receipt pre-fills; denial→manual fallback.
- `flutter analyze` clean; regenerate codegen after model/provider changes
  (`dart run build_runner build --delete-conflicting-outputs`).

## Out of scope (v1)

- Persisting `StationSource` to the DB.
- Background geofencing / passive detection (only on-demand at fill-up time).
- Bundled offline POI dataset (rejected during brainstorming in favour of the
  history + optional-online hybrid).
- Parsing receipts other than fuel receipts.

## Open questions

None blocking. Overpass endpoint URL and exact brand keyword list are
implementation details to be finalized in the plan.
