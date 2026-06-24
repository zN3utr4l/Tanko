import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/data/lookup/overpass_parser.dart';
import 'package:carburo/src/domain/models/enums.dart';

void main() {
  test('maps fuel nodes to DetectedStation, nearest first, source=online', () {
    final json = {
      'elements': [
        {
          'type': 'node',
          'lat': 45.072,
          'lon': 7.68,
          'tags': {'name': 'Far Eni'},
        },
        {
          'type': 'node',
          'lat': 45.0701,
          'lon': 7.68,
          'tags': {'brand': 'Q8'},
        },
        {
          'type': 'node',
          'lat': 45.07,
          'lon': 7.68,
          'tags': {'amenity': 'fuel'},
        }, // no name/brand
      ],
    };
    final out = parseOverpassFuelStations(
      json,
      originLat: 45.07,
      originLng: 7.68,
    );
    expect(out, hasLength(2)); // the nameless node is dropped
    expect(out.first.name, 'Q8'); // ~11 m, nearer than 'Far Eni' (~222 m)
    expect(out.first.source, StationSource.online);
    expect(out.first.distanceMeters, lessThan(out.last.distanceMeters));
  });

  test('missing or empty elements yields empty list', () {
    expect(parseOverpassFuelStations({}, originLat: 0, originLng: 0), isEmpty);
    expect(
      parseOverpassFuelStations({'elements': []}, originLat: 0, originLng: 0),
      isEmpty,
    );
  });
}
