import '../models/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> forVehicle(int vehicleId);
  Future<List<Reminder>> all();
  Future<int> upsert(Reminder reminder);
  Future<void> delete(int id);

  /// Marks a reminder done at [date]/[odometer]. Optionally records a linked
  /// expense (of [expenseAmount] in the reminder's linkedExpenseCategory).
  /// Recurring reminders advance to their next occurrence; one-shots deactivate.
  Future<void> complete(
    int reminderId, {
    required DateTime date,
    double? odometer,
    bool createExpense = false,
    double? expenseAmount,
  });
}
