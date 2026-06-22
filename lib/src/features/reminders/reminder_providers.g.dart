// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Highest odometer seen across fuel-ups and expenses — the basis for
/// distance-based reminder evaluation.

@ProviderFor(currentOdometer)
final currentOdometerProvider = CurrentOdometerFamily._();

/// Highest odometer seen across fuel-ups and expenses — the basis for
/// distance-based reminder evaluation.

final class CurrentOdometerProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Highest odometer seen across fuel-ups and expenses — the basis for
  /// distance-based reminder evaluation.
  CurrentOdometerProvider._({
    required CurrentOdometerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'currentOdometerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentOdometerHash();

  @override
  String toString() {
    return r'currentOdometerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as int;
    return currentOdometer(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentOdometerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentOdometerHash() => r'846635fd82a7e8b78f367044144c3612c982165a';

/// Highest odometer seen across fuel-ups and expenses — the basis for
/// distance-based reminder evaluation.

final class CurrentOdometerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, int> {
  CurrentOdometerFamily._()
    : super(
        retry: null,
        name: r'currentOdometerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Highest odometer seen across fuel-ups and expenses — the basis for
  /// distance-based reminder evaluation.

  CurrentOdometerProvider call(int vehicleId) =>
      CurrentOdometerProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'currentOdometerProvider';
}

@ProviderFor(reminderEvaluations)
final reminderEvaluationsProvider = ReminderEvaluationsFamily._();

final class ReminderEvaluationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReminderEvaluation>>,
          List<ReminderEvaluation>,
          FutureOr<List<ReminderEvaluation>>
        >
    with
        $FutureModifier<List<ReminderEvaluation>>,
        $FutureProvider<List<ReminderEvaluation>> {
  ReminderEvaluationsProvider._({
    required ReminderEvaluationsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'reminderEvaluationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reminderEvaluationsHash();

  @override
  String toString() {
    return r'reminderEvaluationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ReminderEvaluation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReminderEvaluation>> create(Ref ref) {
    final argument = this.argument as int;
    return reminderEvaluations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReminderEvaluationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reminderEvaluationsHash() =>
    r'2b0aed085cffc914edf334f348cfdb2204ca162a';

final class ReminderEvaluationsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ReminderEvaluation>>, int> {
  ReminderEvaluationsFamily._()
    : super(
        retry: null,
        name: r'reminderEvaluationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReminderEvaluationsProvider call(int vehicleId) =>
      ReminderEvaluationsProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'reminderEvaluationsProvider';
}
