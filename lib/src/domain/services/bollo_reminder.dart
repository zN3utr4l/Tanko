import '../models/enums.dart';
import '../models/reminder.dart';

/// Builds a pre-filled annual bollo [Reminder] (id 0 = new) from a computed
/// amount, ready to hand to the reminder form for review. Reminders carry no
/// amount field, so the figure lives in the title; recurrence is yearly and the
/// due date defaults to today (the user adjusts it in the form).
Reminder bolloReminderDraft({
  required int vehicleId,
  required double amount,
  int? linkedExpenseCategoryId,
  required DateTime now,
}) {
  final euro = amount.toStringAsFixed(2).replaceAll('.', ',');
  return Reminder(
    id: 0,
    vehicleId: vehicleId,
    type: ReminderType.bollo,
    title: 'Bollo — € $euro',
    triggerMode: TriggerMode.date,
    dueDate: DateTime(now.year, now.month, now.day),
    recurEvery: 1,
    recurUnit: RecurUnit.year,
    notify: true,
    linkedExpenseCategoryId: linkedExpenseCategoryId,
    active: true,
    createdAt: now,
    updatedAt: now,
  );
}
