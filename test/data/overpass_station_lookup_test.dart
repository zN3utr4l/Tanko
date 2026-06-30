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

  group('probe (diagnostic)', () {
    test('counts stations on success with no error', () async {
      final client = _MockClient();
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
        (_) async => http.Response(
          '{"elements":[{"lat":45.0,"lon":7.6,"tags":{"name":"Eni"}}]}',
          200,
        ),
      );
      final result = await OverpassStationLookup(client: client).probe(45, 7.6);
      expect(result.count, 1);
      expect(result.error, isNull);
      expect(result.ok, isTrue);
    });

    test('an empty area is a success (0 results), not an error', () async {
      final client = _MockClient();
      when(
        () => client.post(any(), body: any(named: 'body')),
      ).thenAnswer((_) async => http.Response('{"elements":[]}', 200));
      final result = await OverpassStationLookup(client: client).probe(45, 7.6);
      expect(result.count, 0);
      expect(result.ok, isTrue);
    });

    test('surfaces the HTTP status as an error', () async {
      final client = _MockClient();
      when(
        () => client.post(any(), body: any(named: 'body')),
      ).thenAnswer((_) async => http.Response('busy', 504));
      final result = await OverpassStationLookup(client: client).probe(45, 7.6);
      expect(result.ok, isFalse);
      expect(result.error, contains('504'));
    });

    test('reports a network failure instead of swallowing it', () async {
      final client = _MockClient();
      when(
        () => client.post(any(), body: any(named: 'body')),
      ).thenThrow(Exception('offline'));
      final result = await OverpassStationLookup(client: client).probe(45, 7.6);
      expect(result.ok, isFalse);
      expect(result.error, 'Errore di rete');
    });
  });
}
