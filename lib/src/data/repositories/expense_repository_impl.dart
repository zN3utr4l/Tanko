import 'package:drift/drift.dart';
import '../../domain/models/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../database/database.dart';
import '../database/mappers.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._db);
  final AppDatabase _db;

  @override
  Future<List<Expense>> forVehicle(int vehicleId) async {
    final rows =
        await (_db.select(_db.expenses)
              ..where((t) => t.vehicleId.equals(vehicleId))
              ..orderBy([(t) => OrderingTerm.desc(t.date)]))
            .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<Expense>> all() async {
    final rows = await _db.select(_db.expenses).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<int> upsert(Expense expense) =>
      _db.into(_db.expenses).insertOnConflictUpdate(expense.toCompanion());

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.expenses)..where((t) => t.id.equals(id))).go();
  }
}
