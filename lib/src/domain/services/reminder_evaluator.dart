import '../models/enums.dart';
import '../models/reminder.dart';
import '../models/reminder_evaluation.dart';

/// Pure logic for reminder status and recurrence. No I/O.
///
/// Status is derived from `today` and the vehicle's current odometer (the max
/// odometer across fuel-ups and expenses) — it is never stored.
class ReminderEvaluator {
  const ReminderEvaluator();

  /// Adds [months] to [from], clamping the day to the target month's last day
  /// (so Jan 31 + 1 month = Feb 28/29, not early March).
  static DateTime addMonths(DateTime from, int months) {
    final total = from.month - 1 + months;
    final y = from.year + (total ~/ 12);
    final m = (total % 12) + 1;
    final lastDay = DateTime(y, m + 1, 0).day; // day 0 of next month
    return DateTime(y, m, from.day < lastDay ? from.day : lastDay);
  }

  ReminderEvaluation evaluate(
    Reminder r, {
    required DateTime today,
    required double currentOdometer,
  }) {
    // Compare on whole days: the picker yields midnight dates, `today` carries
    // a time-of-day, so a raw diff would be off by one for most of the day.
    final t = DateTime(today.year, today.month, today.day);
    final due = r.dueDate == null
        ? null
        : DateTime(r.dueDate!.year, r.dueDate!.month, r.dueDate!.day);

    final daysRemaining = due?.difference(t).inDays;
    final kmRemaining = r.dueOdometer == null
        ? null
        : r.dueOdometer! - currentOdometer;

    if (!r.active) {
      return ReminderEvaluation(
        reminder: r,
        status: ReminderStatus.completed,
        daysRemaining: daysRemaining,
        kmRemaining: kmRemaining,
      );
    }

    final dueByDate = due != null && !t.isBefore(due);
    final dueByKm = r.dueOdometer != null && currentOdometer >= r.dueOdometer!;

    final ReminderStatus status;
    if (dueByDate || dueByKm) {
      status = ReminderStatus.overdue;
    } else {
      final upcomingByDate =
          r.leadDays != null &&
          due != null &&
          !t.isBefore(due.subtract(Duration(days: r.leadDays!)));
      final upcomingByKm =
          r.leadKm != null &&
          r.dueOdometer != null &&
          currentOdometer >= (r.dueOdometer! - r.leadKm!);
      status = (upcomingByDate || upcomingByKm)
          ? ReminderStatus.upcoming
          : ReminderStatus.ok;
    }

    return ReminderEvaluation(
      reminder: r,
      status: status,
      daysRemaining: daysRemaining,
      kmRemaining: kmRemaining,
    );
  }

  /// The next occurrence after a completion, or null for a one-shot reminder.
  ///
  /// Each axis is driven only by its own recurrence rule: an axis without a
  /// rule is cleared in the next occurrence so it can't be born already-due
  /// (e.g. a BOTH reminder that only repeats by date drops its odometer
  /// threshold instead of keeping the just-passed one).
  Reminder? nextOccurrence(
    Reminder r, {
    required DateTime completedDate,
    required double completedOdometer,
  }) {
    final isFixed = r.recurUnit == RecurUnit.fixedDate;
    final hasTimeRecur =
        r.recurEvery != null &&
        r.recurUnit != null &&
        r.recurUnit != RecurUnit.km &&
        !isFixed;
    final kmEvery =
        r.recurKmEvery ?? (r.recurUnit == RecurUnit.km ? r.recurEvery : null);
    final hasKmRecur = kmEvery != null;

    if (!isFixed && !hasTimeRecur && !hasKmRecur) {
      return null; // one-shot
    }

    DateTime? nextDue;
    if (isFixed) {
      final base = r.dueDate ?? completedDate;
      nextDue = _nextFixedDate(base.month, base.day, completedDate);
    } else if (hasTimeRecur) {
      nextDue = _addInterval(completedDate, r.recurEvery!, r.recurUnit!);
    }
    final nextOdo = hasKmRecur ? completedOdometer + kmEvery : null;

    return r.copyWith(
      dueDate: nextDue,
      dueOdometer: nextOdo,
      lastCompletedDate: completedDate,
      lastCompletedOdometer: completedOdometer,
    );
  }

  DateTime _addInterval(DateTime from, int n, RecurUnit unit) => switch (unit) {
    RecurUnit.day => from.add(Duration(days: n)),
    RecurUnit.month => addMonths(from, n),
    RecurUnit.year => addMonths(from, 12 * n),
    _ => from,
  };

  DateTime _nextFixedDate(int month, int day, DateTime after) {
    var d = DateTime(after.year, month, day);
    if (!d.isAfter(after)) d = DateTime(after.year + 1, month, day);
    return d;
  }
}
