// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'796ee74efef7619c331ae494af6b73e25b263565';

@ProviderFor(vehicleRepository)
final vehicleRepositoryProvider = VehicleRepositoryProvider._();

final class VehicleRepositoryProvider
    extends
        $FunctionalProvider<
          VehicleRepository,
          VehicleRepository,
          VehicleRepository
        >
    with $Provider<VehicleRepository> {
  VehicleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicleRepositoryHash();

  @$internal
  @override
  $ProviderElement<VehicleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VehicleRepository create(Ref ref) {
    return vehicleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VehicleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VehicleRepository>(value),
    );
  }
}

String _$vehicleRepositoryHash() => r'c5e4910c59867bd369b2d43bdadfc62771227bf6';

@ProviderFor(fillUpRepository)
final fillUpRepositoryProvider = FillUpRepositoryProvider._();

final class FillUpRepositoryProvider
    extends
        $FunctionalProvider<
          FillUpRepository,
          FillUpRepository,
          FillUpRepository
        >
    with $Provider<FillUpRepository> {
  FillUpRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fillUpRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fillUpRepositoryHash();

  @$internal
  @override
  $ProviderElement<FillUpRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FillUpRepository create(Ref ref) {
    return fillUpRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FillUpRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FillUpRepository>(value),
    );
  }
}

String _$fillUpRepositoryHash() => r'541e9cc5d93f4d047d7a7ac6726accb51059ddd8';

@ProviderFor(statsService)
final statsServiceProvider = StatsServiceProvider._();

final class StatsServiceProvider
    extends $FunctionalProvider<StatsService, StatsService, StatsService>
    with $Provider<StatsService> {
  StatsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsServiceHash();

  @$internal
  @override
  $ProviderElement<StatsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatsService create(Ref ref) {
    return statsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsService>(value),
    );
  }
}

String _$statsServiceHash() => r'd51af8a0fb54418ebf0d8a8679d30e2ef01e4cef';

@ProviderFor(reminderEvaluator)
final reminderEvaluatorProvider = ReminderEvaluatorProvider._();

final class ReminderEvaluatorProvider
    extends
        $FunctionalProvider<
          ReminderEvaluator,
          ReminderEvaluator,
          ReminderEvaluator
        >
    with $Provider<ReminderEvaluator> {
  ReminderEvaluatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderEvaluatorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderEvaluatorHash();

  @$internal
  @override
  $ProviderElement<ReminderEvaluator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReminderEvaluator create(Ref ref) {
    return reminderEvaluator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderEvaluator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderEvaluator>(value),
    );
  }
}

String _$reminderEvaluatorHash() => r'b3b67e1bdd9b77fc79da42edfcbaab1658504e69';

@ProviderFor(expenseRepository)
final expenseRepositoryProvider = ExpenseRepositoryProvider._();

final class ExpenseRepositoryProvider
    extends
        $FunctionalProvider<
          ExpenseRepository,
          ExpenseRepository,
          ExpenseRepository
        >
    with $Provider<ExpenseRepository> {
  ExpenseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpenseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpenseRepository create(Ref ref) {
    return expenseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseRepository>(value),
    );
  }
}

String _$expenseRepositoryHash() => r'd22e0b0cd9612ccf60f582f18477677adba129c3';

@ProviderFor(reminderRepository)
final reminderRepositoryProvider = ReminderRepositoryProvider._();

final class ReminderRepositoryProvider
    extends
        $FunctionalProvider<
          ReminderRepository,
          ReminderRepository,
          ReminderRepository
        >
    with $Provider<ReminderRepository> {
  ReminderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReminderRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReminderRepository create(Ref ref) {
    return reminderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderRepository>(value),
    );
  }
}

String _$reminderRepositoryHash() =>
    r'f9d12e5cbb0d710510cb8fd1e0399c2f175fbb3f';

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationService,
          NotificationService,
          NotificationService
        >
    with $Provider<NotificationService> {
  NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'585c1e42ea844e71a2b76b80b165adfe2c5c8529';

@ProviderFor(catalogRepository)
final catalogRepositoryProvider = CatalogRepositoryProvider._();

final class CatalogRepositoryProvider
    extends
        $FunctionalProvider<
          CatalogRepository,
          CatalogRepository,
          CatalogRepository
        >
    with $Provider<CatalogRepository> {
  CatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<CatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogRepository create(Ref ref) {
    return catalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogRepository>(value),
    );
  }
}

String _$catalogRepositoryHash() => r'20f200af1717fa7220a1b13322edb551edd68eb1';

@ProviderFor(vehicleLookupService)
final vehicleLookupServiceProvider = VehicleLookupServiceProvider._();

final class VehicleLookupServiceProvider
    extends
        $FunctionalProvider<
          VehicleLookupService,
          VehicleLookupService,
          VehicleLookupService
        >
    with $Provider<VehicleLookupService> {
  VehicleLookupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicleLookupServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicleLookupServiceHash();

  @$internal
  @override
  $ProviderElement<VehicleLookupService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VehicleLookupService create(Ref ref) {
    return vehicleLookupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VehicleLookupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VehicleLookupService>(value),
    );
  }
}

String _$vehicleLookupServiceHash() =>
    r'08731009605083e4ee2b559f5cb8f1b298861a9b';

@ProviderFor(lookupSettingsStore)
final lookupSettingsStoreProvider = LookupSettingsStoreProvider._();

final class LookupSettingsStoreProvider
    extends
        $FunctionalProvider<
          LookupSettingsStore,
          LookupSettingsStore,
          LookupSettingsStore
        >
    with $Provider<LookupSettingsStore> {
  LookupSettingsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lookupSettingsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lookupSettingsStoreHash();

  @$internal
  @override
  $ProviderElement<LookupSettingsStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LookupSettingsStore create(Ref ref) {
    return lookupSettingsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LookupSettingsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LookupSettingsStore>(value),
    );
  }
}

String _$lookupSettingsStoreHash() =>
    r'25608ee819d019da0653e9719bf5d9e682b804e0';

@ProviderFor(lookupSettings)
final lookupSettingsProvider = LookupSettingsProvider._();

final class LookupSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<LookupSettings>,
          LookupSettings,
          FutureOr<LookupSettings>
        >
    with $FutureModifier<LookupSettings>, $FutureProvider<LookupSettings> {
  LookupSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lookupSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lookupSettingsHash();

  @$internal
  @override
  $FutureProviderElement<LookupSettings> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LookupSettings> create(Ref ref) {
    return lookupSettings(ref);
  }
}

String _$lookupSettingsHash() => r'd3c087d6c69377a74cfed87a06aefab33efae079';

@ProviderFor(locationService)
final locationServiceProvider = LocationServiceProvider._();

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'33637312fa510b0662eebf6c32e8e62519b7c7c3';

@ProviderFor(ocrService)
final ocrServiceProvider = OcrServiceProvider._();

final class OcrServiceProvider
    extends $FunctionalProvider<OcrService, OcrService, OcrService>
    with $Provider<OcrService> {
  OcrServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ocrServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ocrServiceHash();

  @$internal
  @override
  $ProviderElement<OcrService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OcrService create(Ref ref) {
    return ocrService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OcrService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OcrService>(value),
    );
  }
}

String _$ocrServiceHash() => r'c90db89812dbb8c66e7e4ef01cbe95b9ab38b2c1';

@ProviderFor(stationLookupService)
final stationLookupServiceProvider = StationLookupServiceProvider._();

final class StationLookupServiceProvider
    extends
        $FunctionalProvider<
          StationLookupService,
          StationLookupService,
          StationLookupService
        >
    with $Provider<StationLookupService> {
  StationLookupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stationLookupServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stationLookupServiceHash();

  @$internal
  @override
  $ProviderElement<StationLookupService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StationLookupService create(Ref ref) {
    return stationLookupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StationLookupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StationLookupService>(value),
    );
  }
}

String _$stationLookupServiceHash() =>
    r'afb4d69836a0eb0f3122a29d7fe179b5a2a4e2e9';

@ProviderFor(updateService)
final updateServiceProvider = UpdateServiceProvider._();

final class UpdateServiceProvider
    extends $FunctionalProvider<UpdateService, UpdateService, UpdateService>
    with $Provider<UpdateService> {
  UpdateServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateServiceHash();

  @$internal
  @override
  $ProviderElement<UpdateService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateService create(Ref ref) {
    return updateService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateService>(value),
    );
  }
}

String _$updateServiceHash() => r'e1bd354e52e2db1f329a055a68c559399449b35e';

@ProviderFor(updatePrefs)
final updatePrefsProvider = UpdatePrefsProvider._();

final class UpdatePrefsProvider
    extends $FunctionalProvider<UpdatePrefs, UpdatePrefs, UpdatePrefs>
    with $Provider<UpdatePrefs> {
  UpdatePrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updatePrefsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updatePrefsHash();

  @$internal
  @override
  $ProviderElement<UpdatePrefs> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdatePrefs create(Ref ref) {
    return updatePrefs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdatePrefs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdatePrefs>(value),
    );
  }
}

String _$updatePrefsHash() => r'8380739096205aeeda4d9dcc7812e67c36688cf8';

@ProviderFor(currentVersion)
final currentVersionProvider = CurrentVersionProvider._();

final class CurrentVersionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  CurrentVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentVersionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentVersionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return currentVersion(ref);
  }
}

String _$currentVersionHash() => r'8e4a73ecad231addb63a15cdc8ed104396145107';
