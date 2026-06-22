import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/data/database/database.dart';
import 'package:tanko/src/data/repositories/expense_repository_impl.dart';
import 'package:tanko/src/data/repositories/reminder_repository_impl.dart';
import 'package:tanko/src/data/repositories/vehicle_repository_impl.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/models/expense.dart';
import 'package:tanko/src/domain/models/reminder.dart';
import 'package:tanko/src/domain/models/vehicle.dart';
import '../helpers/test_db.dart';

Future<int> _vehicle(AppDatabase db) => VehicleRepositoryImpl(db).upsert(
  Vehicle(
    id: 0,
    make: 'R',
    model: 'C',
    fuelType: FuelType.petrol,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  ),
);

void main() {
  test('expense CRUD round-trip', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vid = await _vehicle(db);
    final repo = ExpenseRepositoryImpl(db);

    final id = await repo.upsert(
      Expense(
        id: 0,
        vehicleId: vid,
        date: DateTime(2026, 3, 1),
        categoryId: 3, // a seeded expense category
        amount: 350,
        description: 'RCA',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    expect((await repo.forVehicle(vid)).single.amount, 350);
    await repo.delete(id);
    expect(await repo.forVehicle(vid), isEmpty);
  });

  test(
    'completing a recurring reminder advances it and records an expense',
    () async {
      final db = makeTestDb();
      addTearDown(db.close);
      final vid = await _vehicle(db);
      final reminders = ReminderRepositoryImpl(db);
      final expenses = ExpenseRepositoryImpl(db);

      final rid = await reminders.upsert(
        Reminder(
          id: 0,
          vehicleId: vid,
          type: ReminderType.assicurazione,
          title: 'RCA',
          triggerMode: TriggerMode.date,
          dueDate: DateTime(2026, 1, 1),
          recurEvery: 1,
          recurUnit: RecurUnit.year,
          linkedExpenseCategoryId: 3,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );

      await reminders.complete(
        rid,
        date: DateTime(2026, 2, 15),
        createExpense: true,
        expenseAmount: 400,
      );

      final r = (await reminders.forVehicle(vid)).single;
      expect(r.active, isTrue);
      expect(
        r.dueDate,
        DateTime(2027, 2, 15),
      ); // advanced one year from completion
      expect(r.lastCompletedDate, DateTime(2026, 2, 15));

      final e = (await expenses.forVehicle(vid)).single;
      expect(e.amount, 400);
      expect(e.reminderId, rid);
      expect(e.categoryId, 3);
    },
  );

  test('completing a one-shot reminder deactivates it', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vid = await _vehicle(db);
    final reminders = ReminderRepositoryImpl(db);

    final rid = await reminders.upsert(
      Reminder(
        id: 0,
        vehicleId: vid,
        type: ReminderType.custom,
        title: 'Once',
        triggerMode: TriggerMode.date,
        dueDate: DateTime(2026, 1, 1),
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    await reminders.complete(rid, date: DateTime(2026, 1, 2));
    expect((await reminders.forVehicle(vid)).single.active, isFalse);
  });
}
