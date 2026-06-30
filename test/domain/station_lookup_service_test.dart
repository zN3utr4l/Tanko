import 'package:carburo/src/domain/models/detected_station.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/services/station_lookup_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// A service that only implements [nearby], to exercise the default [probe].
class _FakeLookup extends StationLookupService {
  _FakeLookup(this._rows);
  final List<DetectedStation> _rows;

  @override
  Future<List<DetectedStation>> nearby(
    double latitude,
    double longitude, {
    double radiusMeters = 150,
  }) async => _rows;
}

DetectedStation _station() => const DetectedStation(
  name: 'Eni',
  latitude: 45,
  longitude: 7,
  distanceMeters: 10,
  source: StationSource.online,
);

void main() {
  test('default probe wraps nearby and never reports an error', () async {
    final result = await _FakeLookup([_station(), _station()]).probe(45, 7);
    expect(result.count, 2);
    expect(result.ok, isTrue);
    expect(result.error, isNull);
  });

  test('StationProbeResult.ok is false only when an error is set', () {
    expect(const StationProbeResult(count: 0).ok, isTrue);
    expect(const StationProbeResult(count: 0, error: 'Timeout').ok, isFalse);
  });
}
