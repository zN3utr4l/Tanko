# Statistiche — redesign leggibilità + nuovi grafici

**Date:** 2026-06-25
**Status:** approved (design)
**Branch:** `feat/stats-redesign`

## Problem

Dopo l'import di un `Consumi.xlsx` reale (117 rifornimenti, ~3 anni) la pagina
**Statistiche** è poco leggibile e alcuni dati appaiono "vuoti":

- I grafici a barre (Spesa mensile, Costo mensile carburante vs spese) hanno
  un'etichetta per ogni mese a `fontSize 9`: su 30+ mesi si accavallano e gli
  assi sono illeggibili. Nessun asse dei valori (€), nessun tooltip.
- "Consumo medio" e "Prezzo medio" sono vuoti e "Confronto reale vs dichiarato"
  dice *"Dati insufficienti (servono litri e specifiche auto)"*.
- "Andamento prezzo al litro" dice *"Nessun dato"*.

### Causa radice (verificata sul codice e sul file reale)

L'export `Consumi.xlsx` ha colonne **Data / Importo € / Kilometraggio / Autonomia**
ma **non i litri** per rifornimento. Consumo (L/100km) e prezzo/litro (€/L) si
calcolano solo dai litri (`StatsService.compute` → `avgConsumption`,
`avgPricePerLiter`; `RangeComparator` deriva pure il range reale dai litri).
Senza litri sono matematicamente impossibili — **non è un bug e non dipende
dalle specifiche auto** (che l'utente ha inserito). Inoltre l'import Excel è
**solo-rifornimenti**: non porta spese né la stazione, quindi "Composizione
costi" mostra solo Carburante e non esiste dato stazione sugli storici.

## Goals

1. Rendere leggibili tutti i grafici esistenti (assi, etichette diradate,
   tooltip al tap).
2. Aggiungere grafici/insight che funzionano **senza litri**, dai dati
   importati (data, importo, odometro): km per pieno, €/km, spesa per anno.
3. Aggiungere "Spese mie / non mie" sui rifornimenti (nuovo campo + migrazione).
4. Aggiungere "Top distributori" (si popola sui rifornimenti futuri con stazione).
5. Chiarire i messaggi "dato mancante" (litri vs stazione) così l'utente capisce
   cosa fare invece di pensare a un bug.

## Non-goals

- Recuperare consumo/€/L sugli storici importati (litri assenti nel file). Si
  popoleranno sui **nuovi** rifornimenti in cui l'utente inserisce i litri.
- Parsing delle formule `SUM(...)` dell'Excel per dedurre i "non miei": fragile;
  i non-miei sono pochissimi (~3) → si marcano a mano.
- Stazione sugli storici: assente nell'import; "Top distributori" si riempie nel
  tempo.

## Approccio leggibilità (deciso)

**Etichette intelligenti + asse valori + tooltip al tap** (non scroll
orizzontale). Per ogni bar/line chart:

- **Asse X**: mostra al massimo ~6 etichette equidistanti calcolando un
  `interval`; in vista "Sempre" (molti mesi) le etichette sono i confini d'anno
  (es. `2023`, `2024`, `2025`, `2026`); in "12 mesi"/"Anno" il mese (`mar`).
- **Asse Y (sinistra)**: pochi tick con valore (€), `reservedSize` adeguato.
- **Tooltip**: tap su barra/punto → etichetta completa + valore esatto.
- **Barre**: larghezza/spaziatura derivata dal numero di gruppi (più sottili
  quando sono tante) così non si sovrappongono.

Questa logica di etichettatura va estratta in un piccolo helper riusabile
(`ChartAxis`/funzioni in `features/stats/widgets/`) condiviso dai tre grafici a
barre/linea, per non duplicarla.

## Nuova struttura pagina (ordine sezioni)

1. **Riepilogo** (card): Totale · Rifornimenti · **€/km** · **km totali** ·
   Prezzo medio (— se litri assenti).
2. **Confronto reale vs dichiarato**: card invariata, ma il fallback diventa
   *"Servono i litri per rifornimento (aggiungili sui nuovi rifornimenti)"*
   quando le specifiche ci sono ma manca il consumo reale.
3. **Spesa mensile** (barre) — fix leggibilità.
4. **Km per pieno** *(NEW)*: card con 🟢 pieno con **meno** km (data + km),
   🔴 pieno con **più** km (data + km), **media** km/pieno; + mini bar chart dei
   km per pieno (stesso trattamento assi). Calcolato dai delta odometro.
5. **Andamento prezzo/litro** (linea) — fix; resta "Nessun dato" senza litri,
   con nota "(servono i litri)".
6. **Composizione costi** (ciambella) — legenda con percentuali; centro con
   totale.
7. **Spese mie / non mie** *(NEW, ciambella)*: raggruppa i rifornimenti per
   **categoria carburante**. Le categorie carburante seed sono già `Mine` e
   `Not mine` (`_seedFuelCategories`), quindi la distinzione esiste già nel
   modello (`FillUp.categoryId`) — **nessun campo nuovo, nessuna migrazione**.
   L'import assegna tutto alla categoria default (`Mine`); l'utente segna i ~3
   "non miei" cambiando la **Categoria** del rifornimento col dropdown **già
   presente** nel form (`fill_up_form_screen.dart`). Se esiste una sola
   categoria carburante usata, mostro una riga-nota invece di una ciambella a
   fetta unica.
8. **Top distributori** *(NEW)*: classifica per n° rifornimenti su `station`
   non nullo; stato vuoto esplicito ("nessuna stazione registrata") sugli storici.
9. **Spesa per anno** *(NEW, opzionale)*: barre per anno, utile in "Sempre".
10. **Costo mensile (carburante vs spese)** (barre impilate) — fix leggibilità.

## Modifica dati

**Nessuna.** Niente nuovo campo, niente migrazione schema: "mie/non mie" sfrutta
le categorie carburante esistenti (`Mine`/`Not mine`) e il dropdown Categoria già
presente nel form rifornimento. Lo schema resta a v3.

## Domain logic (pura, testata)

Aggiunti a `StatsService` (dove vive già la logica analoga; niente classe nuova) — tutto da odometro/importo, niente litri:

- `kmPerFill(fills)` → lista di `(FillUp toFill, double km)` sui delta odometro
  consecutivi (ordinati per odometro, salta delta ≤ 0).
- da cui: **min** (pieno con meno km), **max** (più km), **media**.
- `costPerKm = totalSpend / totalKm` (riusa `VehicleStats.totalKm`).
- `yearlySpend(fills)` → totale per anno.
- `fuelByCategory(fills)` → `Map<int catId, double>` (specchio di
  `expenseByCategory`); la ciambella "mie/non mie" usa questa + i nomi categoria.
- `topStations(fills, {limit})` → `[(station, count, total)]` su `station != null`.

I widget di presentazione vivono in `features/stats/widgets/` (uno per
sezione/grafico); `stats_screen.dart` si limita a comporre le sezioni e a
leggere i provider — oggi è un unico file grosso, va spezzato man mano che si
aggiungono sezioni.

## Error / empty states

- Litri assenti → "Andamento prezzo/litro" e "Confronto": messaggio esplicito
  che servono i litri (non "dati insufficienti" generico).
- Stazione assente → "Top distributori": empty state dedicato.
- < 2 rifornimenti → "Km per pieno" mostra empty state (servono almeno 2 per un
  delta).

## Testing

- Unit test puri (`test/domain`) per: `kmPerFill` (min/max/media, salta delta ≤
  0, < 2 fills), `yearlySpend`, `fuelByCategory`, `topStations`, `costPerKm`.
- Widget test leggero: la pagina Statistiche mostra le nuove sezioni e gli
  empty-state corretti quando mancano litri/stazione.

## Out of scope / follow-up

- Consumo/€/L storici (impossibile senza litri).
- Auto-derivare "non miei" dall'Excel.
- Geocoding/raggruppamento stazioni oltre il match esatto del nome.

## CI / versioning

`lib/` cambia → bump `pubspec.yaml` (da 0.5.9+15 → 0.6.0+16, è una feature).
`build-apk` (release) deve restare verde; `flutter analyze` + `flutter test`
verdi prima del push. Identità commit zN3utr4l.
