import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data/database/database.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/fill_up_repository_impl.dart';
import 'data/repositories/vehicle_repository_impl.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/fill_up_repository.dart';
import 'domain/repositories/vehicle_repository.dart';
import 'domain/services/stats_service.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) =>
    CategoryRepositoryImpl(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
VehicleRepository vehicleRepository(Ref ref) =>
    VehicleRepositoryImpl(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
FillUpRepository fillUpRepository(Ref ref) =>
    FillUpRepositoryImpl(ref.watch(appDatabaseProvider));

@riverpod
StatsService statsService(Ref ref) => const StatsService();
