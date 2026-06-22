// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expensesForVehicle)
final expensesForVehicleProvider = ExpensesForVehicleFamily._();

final class ExpensesForVehicleProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          FutureOr<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $FutureProvider<List<Expense>> {
  ExpensesForVehicleProvider._({
    required ExpensesForVehicleFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'expensesForVehicleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expensesForVehicleHash();

  @override
  String toString() {
    return r'expensesForVehicleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Expense>> create(Ref ref) {
    final argument = this.argument as int;
    return expensesForVehicle(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesForVehicleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesForVehicleHash() =>
    r'630575189b0053bda1f1634992339da391e0e7c6';

final class ExpensesForVehicleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Expense>>, int> {
  ExpensesForVehicleFamily._()
    : super(
        retry: null,
        name: r'expensesForVehicleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExpensesForVehicleProvider call(int vehicleId) =>
      ExpensesForVehicleProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'expensesForVehicleProvider';
}

@ProviderFor(expenseCategories)
final expenseCategoriesProvider = ExpenseCategoriesProvider._();

final class ExpenseCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  ExpenseCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return expenseCategories(ref);
  }
}

String _$expenseCategoriesHash() => r'b12a2bdf0c2020d2550033c13031de4396196e11';
