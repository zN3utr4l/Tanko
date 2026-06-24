import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/services/station_matcher.dart';

FillUp fill({required int id, double? lat, double? lng, String? station}) =>
    FillUp(
      id: id,
      vehicleId: 1,
      date: DateTime(2026, 1, id),
      amount: 50,
      liters: 30,
      odometer: 1000.0 * id,
      categoryId: 1,
      latitude: lat,
      longitude: lng,
      station: station,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  const matcher = StationMatcher();

  test('exact-coordinate history entry matches', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [
        fill(id: 1, lat: 45.07, lng: 7.68, station: 'Eni Corso Francia'),
      ],
    );
    expect(m, isNotNull);
    expect(m!.name, 'Eni Corso Francia');
    expect(m.source, StationSource.history);
    expect(m.distanceMeters, closeTo(0, 1.0));
  });

  test('entry just inside the radius matches (~55 m)', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [fill(id: 1, lat: 45.0705, lng: 7.68, station: 'Q8')],
    );
    expect(m, isNotNull);
  });

  test('entry outside the radius does not match (~222 m)', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [fill(id: 1, lat: 45.072, lng: 7.68, station: 'Q8')],
    );
    expect(m, isNull);
  });

  test('nearest of several candidates wins', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [
        fill(id: 1, lat: 45.0705, lng: 7.68, station: 'Far'), // ~55 m
        fill(id: 2, lat: 45.0701, lng: 7.68, station: 'Near'), // ~11 m
      ],
    );
    expect(m!.name, 'Near');
  });

  test('entries without coords or station name are ignored', () {
    final m = matcher.match(
      latitude: 45.07,
      longitude: 7.68,
      history: [
        fill(id: 1, lat: null, lng: null, station: 'No coords'),
        fill(id: 2, lat: 45.07, lng: 7.68, station: '   '),
        fill(id: 3, lat: 45.07, lng: 7.68, station: null),
      ],
    );
    expect(m, isNull);
  });

  test('empty history returns null', () {
    expect(
      matcher.match(latitude: 45.07, longitude: 7.68, history: []),
      isNull,
    );
  });
}
