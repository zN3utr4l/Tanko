enum FuelType { petrol, diesel, lpg, cng, hybrid, electric }

/// Italian emission class — libretto (carta di circolazione) field **V.9**.
/// Drives the per-kW bollo rate. Index 0..6 maps to "Euro 0".."Euro 6".
enum EuroClass { euro0, euro1, euro2, euro3, euro4, euro5, euro6 }

/// Where a vehicle's specs came from. [catalog] = bundled offline catalog,
/// [online] = user-assisted online lookup, [manual] = typed by the user.
enum SpecSource { catalog, online, manual }

/// Discriminates fuel vs general-expense categories (they share one table).
enum CategoryKind { fuel, expense }

enum ReminderType {
  bollo,
  assicurazione,
  revisione,
  tagliando,
  gomme,
  patente,
  custom,
}

/// What makes a reminder due: a calendar date, an odometer threshold, or both
/// (whichever comes first).
enum TriggerMode { date, distance, both }

/// Recurrence unit. [fixedDate] recurs on a fixed calendar day (seasonal tyres).
enum RecurUnit { day, month, year, km, fixedDate }

/// Derived (never stored) reminder state.
enum ReminderStatus { ok, upcoming, overdue, completed }

/// Where an auto-detected station name came from.
enum StationSource { history, online, receipt, manual }
