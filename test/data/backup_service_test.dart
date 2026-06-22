import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/data/backup/backup_service.dart';
import 'package:tanko/src/domain/models/backup_data.dart';
import 'package:tanko/src/domain/models/category.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/models/fill_up.dart';
import 'package:tanko/src/domain/models/vehicle.dart';

void main() {
  const service = BackupService();

  final data = BackupData(
    vehicles: [
      Vehicle(
        id: 1,
        make: 'Renault',
        model: 'Clio',
        fuelType: FuelType.hybrid,
        specs: const VehicleSpecs(tankCapacityL: 39, source: SpecSource.carquery),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    ],
    categories: const [Category(id: 1, name: 'Mine', color: 0xFF4CAF50, isDefault: true)],
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
  );

  test('JSON export -> import round-trips losslessly', () {
    final restored = service.fromJson(service.toJson(data));
    expect(restored, data);
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
