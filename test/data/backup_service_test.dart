import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/data/backup/backup_service.dart';
import 'package:carburo/src/domain/models/backup_data.dart';
import 'package:carburo/src/domain/models/category.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/expense.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/models/reminder.dart';
import 'package:carburo/src/domain/models/vehicle.dart';

void main() {
  const service = BackupService();

  final data = BackupData(
    vehicles: [
      Vehicle(
        id: 1,
        make: 'Renault',
        model: 'Clio',
        fuelType: FuelType.hybrid,
        specs: const VehicleSpecs(
          tankCapacityL: 39,
          source: SpecSource.catalog,
        ),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    ],
    categories: const [
      Category(id: 1, name: 'Mine', color: 0xFF4CAF50, isDefault: true),
    ],
    fillUps: [
      FillUp(
        id: 1,
        vehicleId: 1,
        date: DateTime(2026, 1, 2),
        amount: 40,
        liters: 32,
        odometer: 1000,
        categoryId: 1,
        createdAt: DateTime(2026, 1, 2),
        updatedAt: DateTime(2026, 1, 2),
      ),
    ],
    expenses: [
      Expense(
        id: 1,
        vehicleId: 1,
        date: DateTime(2026, 3, 1),
        categoryId: 3,
        amount: 350,
        description: 'RCA',
        createdAt: DateTime(2026, 3, 1),
        updatedAt: DateTime(2026, 3, 1),
      ),
    ],
    reminders: [
      Reminder(
        id: 1,
        vehicleId: 1,
        type: ReminderType.assicurazione,
        title: 'RCA',
        triggerMode: TriggerMode.date,
        dueDate: DateTime(2027, 1, 1),
        recurEvery: 1,
        recurUnit: RecurUnit.year,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    ],
  );

  test('JSON export -> import round-trips losslessly (v3 with Euro class)', () {
    final restored = service.fromJson(service.toJson(data));
    expect(restored.copyWith(schemaVersion: data.schemaVersion), data);
    expect(restored.schemaVersion, BackupService.currentSchemaVersion);
  });

  test('fromJson accepts a legacy v1 backup (no expenses/reminders)', () {
    final restored = service.fromJson(
      '{"schemaVersion": 1, "vehicles": [], "categories": [], "fillUps": []}',
    );
    expect(restored.schemaVersion, 1);
    expect(restored.expenses, isEmpty);
    expect(restored.reminders, isEmpty);
  });

  test('fromJson accepts a v2 backup without vehicle Euro class', () {
    final restored = service.fromJson(
      '{"schemaVersion": 2, "vehicles": [], "categories": [], "fillUps": [], "expenses": [], "reminders": []}',
    );
    expect(restored.schemaVersion, 2);
  });

  test('fromJson rejects an unsupported schema version', () {
    expect(
      () => service.fromJson('{"schemaVersion": 99}'),
      throwsA(isA<FormatException>()),
    );
  });

  test('CSV export has a header and one row per fill-up', () {
    final csv = service.toCsv(data.fillUps);
    final lines = csv.trim().split('\n');
    expect(lines.first, contains('date'));
    expect(lines.first, contains('odometer'));
    expect(lines, hasLength(2)); // header + 1 fill-up
  });
}
