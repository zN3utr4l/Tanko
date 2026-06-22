// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monthlySpend)
final monthlySpendProvider = MonthlySpendFamily._();

final class MonthlySpendProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MonthlyTotal>>,
          List<MonthlyTotal>,
          FutureOr<List<MonthlyTotal>>
        >
    with
        $FutureModifier<List<MonthlyTotal>>,
        $FutureProvider<List<MonthlyTotal>> {
  MonthlySpendProvider._({
    required MonthlySpendFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'monthlySpendProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlySpendHash();

  @override
  String toString() {
    return r'monthlySpendProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MonthlyTotal>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MonthlyTotal>> create(Ref ref) {
    final argument = this.argument as int;
    return monthlySpend(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlySpendProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlySpendHash() => r'123ad5e9a8e495f980e7521a52480c35b827ee31';

final class MonthlySpendFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<MonthlyTotal>>, int> {
  MonthlySpendFamily._()
    : super(
        retry: null,
        name: r'monthlySpendProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MonthlySpendProvider call(int vehicleId) =>
      MonthlySpendProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'monthlySpendProvider';
}

@ProviderFor(vehicleComparison)
final vehicleComparisonProvider = VehicleComparisonFamily._();

final class VehicleComparisonProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConsumptionComparison>,
          ConsumptionComparison,
          FutureOr<ConsumptionComparison>
        >
    with
        $FutureModifier<ConsumptionComparison>,
        $FutureProvider<ConsumptionComparison> {
  VehicleComparisonProvider._({
    required VehicleComparisonFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'vehicleComparisonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vehicleComparisonHash();

  @override
  String toString() {
    return r'vehicleComparisonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ConsumptionComparison> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConsumptionComparison> create(Ref ref) {
    final argument = this.argument as int;
    return vehicleComparison(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VehicleComparisonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vehicleComparisonHash() => r'c64c97c634381a044b661198dfe9811c3dabed5f';

final class VehicleComparisonFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ConsumptionComparison>, int> {
  VehicleComparisonFamily._()
    : super(
        retry: null,
        name: r'vehicleComparisonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VehicleComparisonProvider call(int vehicleId) =>
      VehicleComparisonProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'vehicleComparisonProvider';
}
