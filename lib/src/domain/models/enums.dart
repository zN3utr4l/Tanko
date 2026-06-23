enum FuelType { petrol, diesel, lpg, cng, hybrid, electric }

/// Where a vehicle's specs came from. [catalog] = pre-filled from the bundled
/// offline catalog; [manual] = typed by the user.
enum SpecSource { catalog, manual }

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
