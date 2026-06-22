import '../../domain/models/expense.dart';
import '../../domain/models/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/services/reminder_evaluator.dart';
import '../database/database.dart';
import '../database/mappers.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(this._db, {ReminderEvaluator? evaluator})
    : _evaluator = evaluator ?? const ReminderEvaluator();

  final AppDatabase _db;
  final ReminderEvaluator _evaluator;

  @override
  Future<List<Reminder>> forVehicle(int vehicleId) async {
    final rows = await (_db.select(
      _db.reminders,
    )..where((t) => t.vehicleId.equals(vehicleId))).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<Reminder>> all() async {
    final rows = await _db.select(_db.reminders).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<int> upsert(Reminder reminder) =>
      _db.into(_db.reminders).insertOnConflictUpdate(reminder.toCompanion());

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.reminders)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> complete(
    int reminderId, {
    required DateTime date,
    double? odometer,
    bool createExpense = false,
    double? expenseAmount,
  }) async {
    final row = await (_db.select(
      _db.reminders,
    )..where((t) => t.id.equals(reminderId))).getSingle();
    final reminder = row.toDomain();
    final odo = odometer ?? reminder.dueOdometer ?? 0;
    final now = DateTime.now();

    if (createExpense &&
        reminder.linkedExpenseCategoryId != null &&
        expenseAmount != null) {
      await _db
          .into(_db.expenses)
          .insert(
            Expense(
              id: 0,
              vehicleId: reminder.vehicleId,
              date: date,
              odometer: odometer ?? reminder.dueOdometer,
              categoryId: reminder.linkedExpenseCategoryId!,
              amount: expenseAmount,
              reminderId: reminder.id,
              createdAt: now,
              updatedAt: now,
            ).toCompanion(),
          );
    }

    final next = _evaluator.nextOccurrence(
      reminder,
      completedDate: date,
      completedOdometer: odo,
    );
    final updated =
        (next ??
                reminder.copyWith(
                  active: false,
                  lastCompletedDate: date,
                  lastCompletedOdometer: odo,
                ))
            .copyWith(updatedAt: now);
    await upsert(updated);
  }
}
