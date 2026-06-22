import 'package:drift/drift.dart';
import '../../domain/models/fill_up.dart';
import '../../domain/repositories/fill_up_repository.dart';
import '../database/database.dart';
import '../database/mappers.dart';

class FillUpRepositoryImpl implements FillUpRepository {
  FillUpRepositoryImpl(this._db);
  final AppDatabase _db;

  @override
  Future<List<FillUp>> forVehicle(int vehicleId) async {
    final rows = await (_db.select(_db.fillUps)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([(t) => OrderingTerm.asc(t.odometer)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<FillUp>> all() async {
    final rows = await _db.select(_db.fillUps).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<int> upsert(FillUp fillUp) {
    return _db.into(_db.fillUps).insertOnConflictUpdate(fillUp.toCompanion());
  }

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.fillUps)..where((t) => t.id.equals(id))).go();
  }
}
