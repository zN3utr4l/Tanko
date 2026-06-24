# Carburo Online Lookup and UX Audit Design

## Goal

Turn Carburo from a strictly offline vehicle catalog into a local-first app with optional online assistance, while closing the missing product gaps found during the audit.

## Scope

- Keep all existing manual/offline flows working.
- Add the Android release internet permission required by current and future online features.
- Add a network/privacy settings area for online lookup toggles and optional API keys.
- Improve the vehicle creation flow with plate normalization, official verification links, paste-assisted data extraction, and a lookup abstraction that can later host paid/free providers.
- Improve daily usage gaps: movement deletion/filtering, calendar event opening/completion, Excel import target selection and duplicate skipping, backup schema version, and basic statistics filters/insights.

## Plate Lookup Policy

Official Italian portals may be opened for user-driven verification, but the app will not automate CAPTCHA or scrape pages. The app can provide an embedded/external browser entry point and a paste/import area where the user can copy visible results back into Carburo. API-based enrichment must stay behind an explicit provider interface and user-configured credentials.

## Architecture

- `VehicleLookupService` owns plate normalization, parsing pasted text, and source URLs.
- `LookupSettings` stores online toggles and API keys using `SharedPreferences`.
- The add-vehicle wizard remains usable offline and consumes lookup results as optional field prefill.
- UI changes reuse existing repositories and provider invalidation patterns.

## Testing

Add focused tests for:

- main Android manifest requiring `INTERNET`;
- plate normalization and pasted text parsing;
- settings defaults and persistence;
- Excel duplicate detection;
- movement delete UI behavior;
- backup schema v3 accepting v1/v2/v3;
- calendar events exposing enough data for opening forms.
