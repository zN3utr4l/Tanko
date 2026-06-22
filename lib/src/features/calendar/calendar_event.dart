enum CalendarEventType { fuel, expense, reminder }

/// A lightweight, UI-facing aggregation of something that happened (or is due)
/// on a given day, shown on the calendar grid and day-detail sheet.
class CalendarEvent {
  const CalendarEvent({
    required this.date,
    required this.type,
    required this.title,
    this.amount,
    this.overdue = false,
    this.refId,
  });

  final DateTime date;
  final CalendarEventType type;
  final String title;
  final double? amount;
  final bool overdue;
  final int? refId;
}
