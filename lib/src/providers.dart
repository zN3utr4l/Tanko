import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data/catalog/offline_catalog.dart';
import 'data/database/database.dart';
import 'data/location/geolocator_location_service.dart';
import 'data/lookup/overpass_station_lookup.dart';
import 'data/notifications/notification_service.dart';
import 'data/ocr/mlkit_ocr_service.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'data/repositories/fill_up_repository_impl.dart';
import 'data/repositories/reminder_repository_impl.dart';
import 'data/repositories/vehicle_repository_impl.dart';
import 'data/update/github_update_service.dart';
import 'data/update/update_prefs.dart';
import 'domain/repositories/catalog_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/expense_repository.dart';
import 'domain/repositories/fill_up_repository.dart';
import 'domain/repositories/reminder_repository.dart';
import 'domain/repositories/vehicle_repository.dart';
import 'domain/services/location_service.dart';
import 'domain/services/ocr_service.dart';
import 'domain/services/reminder_evaluator.dart';
import 'domain/services/station_lookup_service.dart';
import 'domain/services/stats_service.dart';
import 'domain/services/update_service.dart';

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
CatalogRepository catalogRepository(Ref ref) => OfflineCatalog();

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) => const GeolocatorLocationService();

@Riverpod(keepAlive: true)
OcrService ocrService(Ref ref) => MlKitOcrService();

@Riverpod(keepAlive: true)
StationLookupService stationLookupService(Ref ref) => OverpassStationLookup();

@Riverpod(keepAlive: true)
UpdateService updateService(Ref ref) => GitHubUpdateService();

@Riverpod(keepAlive: true)
UpdatePrefs updatePrefs(Ref ref) => const UpdatePrefs();

@Riverpod(keepAlive: true)
Future<String> currentVersion(Ref ref) async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
}
