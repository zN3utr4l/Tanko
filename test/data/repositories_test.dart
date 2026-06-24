import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/data/repositories/category_repository_impl.dart';
import 'package:carburo/src/data/repositories/expense_repository_impl.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/data/repositories/fill_up_repository_impl.dart';
import 'package:carburo/src/data/repositories/reminder_repository_impl.dart';
import 'package:carburo/src/domain/models/expense.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/models/reminder.dart';
import 'package:carburo/src/domain/models/vehicle.dart';
import '../helpers/test_db.dart';

void main() {
  test('vehicle upsert/getById/default + fill-up CRUD round-trip', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final cats = CategoryRepositoryImpl(db);
    final vehicles = VehicleRepositoryImpl(db);
    final fills = FillUpRepositoryImpl(db);

    final defaultCat = (await cats.all()).firstWhere((c) => c.isDefault);

    final id = await vehicles.upsert(
      Vehicle(
        id: 0,
        make: 'Renault',
        model: 'Clio',
        fuelType: FuelType.hybrid,
        isDefault: true,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    expect((await vehicles.getById(id)).make, 'Renault');
    expect((await vehicles.defaultVehicle())!.id, id);

    final fid = await fills.upsert(
      FillUp(
        id: 0,
        vehicleId: id,
        date: DateTime(2026, 1, 1),
        amount: 40,
        liters: 30,
        odometer: 1000,
        categoryId: defaultCat.id,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    expect(await fills.forVehicle(id), hasLength(1));

    await fills.delete(fid);
    expect(await fills.forVehicle(id), isEmpty);
  });

  test('vehicle Euro class round-trips through the database', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vehicles = VehicleRepositoryImpl(db);

    final id = await vehicles.upsert(
      Vehicle(
        id: 0,
        make: 'Fiat',
        model: 'Panda',
        fuelType: FuelType.petrol,
        euroClass: EuroClass.euro5,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    expect((await vehicles.getById(id)).euroClass, EuroClass.euro5);
  });

  test(
    'deleting a vehicle cascades fill-ups, expenses, and reminders',
    () async {
      final db = makeTestDb();
      addTearDown(db.close);
      final cats = CategoryRepositoryImpl(db);
      final vehicles = VehicleRepositoryImpl(db);
      final fills = FillUpRepositoryImpl(db);
      final expenses = ExpenseRepositoryImpl(db);
      final reminders = ReminderRepositoryImpl(db);

      final categories = await cats.all();
      final fuelCat = categories.firstWhere((c) => c.kind == CategoryKind.fuel);
      final expenseCat = categories.firstWhere((c) => c.name == 'Bollo');
      final id = await vehicles.upsert(
        Vehicle(
          id: 0,
          make: 'Renault',
          model: 'Clio',
          fuelType: FuelType.hybrid,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );
      await fills.upsert(
        FillUp(
          id: 0,
          vehicleId: id,
          date: DateTime(2026, 1, 1),
          amount: 40,
          liters: 30,
          odometer: 1000,
          categoryId: fuelCat.id,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );
      await expenses.upsert(
        Expense(
          id: 0,
          vehicleId: id,
          date: DateTime(2026, 1, 2),
          categoryId: expenseCat.id,
          amount: 200,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );
      await reminders.upsert(
        Reminder(
          id: 0,
          vehicleId: id,
          type: ReminderType.bollo,
          title: 'Bollo',
          triggerMode: TriggerMode.date,
          dueDate: DateTime(2026, 1, 31),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );

      await vehicles.delete(id);

      expect(await vehicles.all(), isEmpty);
      expect(await fills.forVehicle(id), isEmpty);
      expect(await expenses.forVehicle(id), isEmpty);
      expect(await reminders.forVehicle(id), isEmpty);
    },
  );
}
