# App Visual Refresh Design

## Direction

Carburo should feel like a practical automotive logbook with more craft than the default Material seed theme. The visual direction is a clean garage: light graphite surfaces, teal instrumentation, amber service accents, restrained cards, and typography that makes data easy to scan.

## Scope

The first pass refreshes the global theme and the dashboard only. Other screens inherit improved colors, shape, navigation, app bars, inputs, and buttons without bespoke redesigns. This keeps the change cohesive without rewriting every feature surface at once.

## Dashboard

The dashboard becomes a cockpit view:

- A full-width vehicle hero with the current vehicle name, fuel type, and primary total-cost figure.
- A compact quick-action strip for `Rifornimento` and `Spesa`, replacing the hidden-only FAB workflow with visible first-screen actions.
- Metric cards with icons, labels, and subtle accent treatments for total cost, cost per km, fuel spend, consumption, average price, and total km.
- The existing FAB remains as a secondary entry point for users who already rely on it.

## Theme

Palette:

- Garage paper: `#F4F6F3`
- Surface: `#FFFFFF`
- Ink: `#14201E`
- Instrument teal: `#006C67`
- Fuel teal: `#00A896`
- Service amber: `#E2A100`
- Graphite: `#22302D`

Dark mode uses graphite surfaces with teal and amber accents. Components keep 8-16 px radii, clear focus states, and Material 3 behavior.

## Testing

Widget tests cover the new dashboard structure and visible actions. Theme tests assert the deliberate palette and component defaults so the app does not regress to a generic seed-only look.
