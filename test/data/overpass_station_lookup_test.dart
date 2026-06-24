import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:carburo/src/data/lookup/overpass_station_lookup.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() => registerFallbackValue(Uri()));

  test('parses a 200 response into candidates', () async {
    final client = _MockClient();
    when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
      (_) async => http.Response(
        '{"elements":[{"lat":45.07,"lon":7.68,"tags":{"name":"Eni"}}]}',
        200,
      ),
    );
    final lookup = OverpassStationLookup(client: client);
    final out = await lookup.nearby(45.07, 7.68);
    expect(out.single.name, 'Eni');
  });

  test('non-200 response yields empty list', () async {
    final client = _MockClient();
    when(
      () => client.post(any(), body: any(named: 'body')),
    ).thenAnswer((_) async => http.Response('error', 503));
    final lookup = OverpassStationLookup(client: client);
    expect(await lookup.nearby(45.07, 7.68), isEmpty);
  });

  test('network exception yields empty list (never throws)', () async {
    final client = _MockClient();
    when(
      () => client.post(any(), body: any(named: 'body')),
    ).thenThrow(Exception('offline'));
    final lookup = OverpassStationLookup(client: client);
    expect(await lookup.nearby(45.07, 7.68), isEmpty);
  });
}
