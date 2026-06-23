// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_detector.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stationDetector)
final stationDetectorProvider = StationDetectorProvider._();

final class StationDetectorProvider
    extends
        $FunctionalProvider<StationDetector, StationDetector, StationDetector>
    with $Provider<StationDetector> {
  StationDetectorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stationDetectorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stationDetectorHash();

  @$internal
  @override
  $ProviderElement<StationDetector> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StationDetector create(Ref ref) {
    return stationDetector(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StationDetector value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StationDetector>(value),
    );
  }
}

String _$stationDetectorHash() => r'ba304987c18f8d1e2b71c232b2a54a0071bc0ce3';
