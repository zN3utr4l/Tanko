import 'package:drift/drift.dart';
import '../../domain/models/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../database/database.dart';
import '../database/mappers.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  VehicleRepositoryImpl(this._db);
  final AppDatabase _db;

  @override
  Future<List<Vehicle>> all() async {
    final rows = await _db.select(_db.vehicles).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Vehicle> getById(int id) async {
    final row = await (_db.select(
      _db.vehicles,
    )..where((t) => t.id.equals(id))).getSingle();
    return row.toDomain();
  }

  @override
  Future<int> upsert(Vehicle vehicle) {
    if (!vehicle.isDefault) {
      return _db
          .into(_db.vehicles)
          .insertOnConflictUpdate(vehicle.toCompanion());
    }
    return _db.transaction(() async {
      await (_db.update(_db.vehicles)..where((t) => t.isDefault.equals(true)))
          .write(const VehiclesCompanion(isDefault: Value(false)));
      return _db
          .into(_db.vehicles)
          .insertOnConflictUpdate(vehicle.toCompanion());
    });
  }

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.vehicles)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<Vehicle?> defaultVehicle() async {
    final row =
        await (_db.select(_db.vehicles)
              ..where((t) => t.isDefault.equals(true))
              ..limit(1))
            .getSingleOrNull();
    return row?.toDomain();
  }
}
