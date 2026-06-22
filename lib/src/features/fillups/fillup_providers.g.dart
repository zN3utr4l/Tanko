// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fillup_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fillUps)
final fillUpsProvider = FillUpsFamily._();

final class FillUpsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FillUp>>,
          List<FillUp>,
          FutureOr<List<FillUp>>
        >
    with $FutureModifier<List<FillUp>>, $FutureProvider<List<FillUp>> {
  FillUpsProvider._({
    required FillUpsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'fillUpsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fillUpsHash();

  @override
  String toString() {
    return r'fillUpsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<FillUp>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FillUp>> create(Ref ref) {
    final argument = this.argument as int;
    return fillUps(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FillUpsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fillUpsHash() => r'08835997427f34215f1f5323bc4aa4b7f8a4fb8e';

final class FillUpsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<FillUp>>, int> {
  FillUpsFamily._()
    : super(
        retry: null,
        name: r'fillUpsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FillUpsProvider call(int vehicleId) =>
      FillUpsProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'fillUpsProvider';
}

/// All categories (both kinds) — for id→name/colour lookups in lists/charts.

@ProviderFor(allCategories)
final allCategoriesProvider = AllCategoriesProvider._();

/// All categories (both kinds) — for id→name/colour lookups in lists/charts.

final class AllCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  /// All categories (both kinds) — for id→name/colour lookups in lists/charts.
  AllCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return allCategories(ref);
  }
}

String _$allCategoriesHash() => r'f389692db9bd5151310c43e1cd614481645d692a';

/// Fuel categories only — for the fuel fill-up picker (never expense ones).

@ProviderFor(fuelCategories)
final fuelCategoriesProvider = FuelCategoriesProvider._();

/// Fuel categories only — for the fuel fill-up picker (never expense ones).

final class FuelCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  /// Fuel categories only — for the fuel fill-up picker (never expense ones).
  FuelCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fuelCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fuelCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return fuelCategories(ref);
  }
}

String _$fuelCategoriesHash() => r'e55723052034705def279d1ac1216150bf696a8f';
