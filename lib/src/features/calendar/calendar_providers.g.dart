// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(calendarEvents)
final calendarEventsProvider = CalendarEventsFamily._();

final class CalendarEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DateTime, List<CalendarEvent>>>,
          Map<DateTime, List<CalendarEvent>>,
          FutureOr<Map<DateTime, List<CalendarEvent>>>
        >
    with
        $FutureModifier<Map<DateTime, List<CalendarEvent>>>,
        $FutureProvider<Map<DateTime, List<CalendarEvent>>> {
  CalendarEventsProvider._({
    required CalendarEventsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'calendarEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$calendarEventsHash();

  @override
  String toString() {
    return r'calendarEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<DateTime, List<CalendarEvent>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<DateTime, List<CalendarEvent>>> create(Ref ref) {
    final argument = this.argument as int;
    return calendarEvents(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calendarEventsHash() => r'8f6c37a501e93de9a9cbc48ce6e2344d939001c4';

final class CalendarEventsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<DateTime, List<CalendarEvent>>>,
          int
        > {
  CalendarEventsFamily._()
    : super(
        retry: null,
        name: r'calendarEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CalendarEventsProvider call(int vehicleId) =>
      CalendarEventsProvider._(argument: vehicleId, from: this);

  @override
  String toString() => r'calendarEventsProvider';
}
