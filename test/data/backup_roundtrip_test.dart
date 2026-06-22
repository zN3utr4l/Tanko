import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/data/backup/backup_service.dart';
import 'package:tanko/src/data/repositories/category_repository_impl.dart';
import 'package:tanko/src/data/repositories/fill_up_repository_impl.dart';
import 'package:tanko/src/data/repositories/vehicle_repository_impl.dart';
import 'package:tanko/src/domain/models/backup_data.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/models/fill_up.dart';
import 'package:tanko/src/domain/models/vehicle.dart';
import '../helpers/test_db.dart';

void main() {
  const backup = BackupService();

  test('export from one DB restores into a fresh DB', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vid = await VehicleRepositoryImpl(db).upsert(
      Vehicle(
        id: 0,
        make: 'Renault',
        model: 'Clio',
        fuelType: FuelType.hybrid,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    await FillUpRepositoryImpl(db).upsert(
      FillUp(
        id: 0,
        vehicleId: vid,
        date: DateTime(2026, 1, 1),
        amount: 40,
        liters: 32,
        odometer: 1000,
        categoryId: 1,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    final data = BackupData(
      vehicles: await VehicleRepositoryImpl(db).all(),
      categories: await CategoryRepositoryImpl(db).all(),
      fillUps: await FillUpRepositoryImpl(db).all(),
    );
    final restored = backup.fromJson(backup.toJson(data));

    final db2 = makeTestDb();
    addTearDown(db2.close);
    final c2 = CategoryRepositoryImpl(db2);
    final v2 = VehicleRepositoryImpl(db2);
    final f2 = FillUpRepositoryImpl(db2);
    for (final c in restored.categories) {
      await c2.upsert(c);
    }
    for (final v in restored.vehicles) {
      await v2.upsert(v);
    }
    for (final f in restored.fillUps) {
      await f2.upsert(f);
    }

    expect(await v2.all(), hasLength(1));
    expect((await v2.all()).single.make, 'Renault');
    expect(await f2.all(), hasLength(1));
    expect((await f2.all()).single.liters, 32);
  });
}
