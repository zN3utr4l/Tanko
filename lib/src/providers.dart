import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data/catalog/carquery_client.dart';
import 'data/database/database.dart';
import 'data/notifications/notification_service.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'data/repositories/fill_up_repository_impl.dart';
import 'data/repositories/reminder_repository_impl.dart';
import 'data/repositories/vehicle_repository_impl.dart';
import 'domain/repositories/catalog_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/expense_repository.dart';
import 'domain/repositories/fill_up_repository.dart';
import 'domain/repositories/reminder_repository.dart';
import 'domain/repositories/vehicle_repository.dart';
import 'domain/services/reminder_evaluator.dart';
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

@riverpod
ReminderEvaluator reminderEvaluator(Ref ref) => const ReminderEvaluator();

@Riverpod(keepAlive: true)
ExpenseRepository expenseRepository(Ref ref) =>
    ExpenseRepositoryImpl(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
ReminderRepository reminderRepository(Ref ref) => ReminderRepositoryImpl(
  ref.watch(appDatabaseProvider),
  evaluator: ref.watch(reminderEvaluatorProvider),
);

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService();

@Riverpod(keepAlive: true)
Dio catalogDio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );
  ref.onDispose(dio.close);
  return dio;
}

@Riverpod(keepAlive: true)
CatalogRepository catalogRepository(Ref ref) =>
    CarQueryClient(ref.watch(catalogDioProvider));
