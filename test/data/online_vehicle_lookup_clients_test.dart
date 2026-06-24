import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:carburo/src/data/lookup/car_api_catalog_lookup.dart';
import 'package:carburo/src/data/lookup/openapi_vehicle_lookup.dart';
import 'package:carburo/src/domain/models/enums.dart';

void main() {
  test('Openapi client maps Italian car and insurance responses', () async {
    final requests = <Uri>[];
    final client = MockClient((request) async {
      requests.add(request.url);
      expect(request.headers['Authorization'], 'Bearer test-key');
      if (request.url.path.contains('IT-insurance')) {
        return http.Response(
          jsonEncode({'company': 'Generali', 'expiry': '31/12/2026'}),
          200,
        );
      }
      return http.Response(
        jsonEncode({
          'CarMake': 'Fiat',
          'CarModel': 'Panda',
          'Version': 'City Cross',
          'RegistrationYear': '2020',
          'FuelType': 'Benzina',
          'PowerCV': 70,
        }),
        200,
      );
    });

    final lookup = OpenApiVehicleLookup(client: client);
    final data = await lookup.lookupItalianPlate(
      plate: 'ab123cd',
      apiKey: 'test-key',
    );

    expect(data.plate, 'AB123CD');
    expect(data.make, 'Fiat');
    expect(data.model, 'Panda');
    expect(data.trim, 'City Cross');
    expect(data.year, 2020);
    expect(data.fuelType, FuelType.petrol);
    expect(data.powerPs, 70);
    expect(data.insuranceCompany, 'Generali');
    expect(data.insuranceExpiry, DateTime(2026, 12, 31));
    expect(requests, hasLength(2));
  });

  test('CarAPI catalog client maps trim entries into catalog trims', () async {
    final client = MockClient((request) async {
      expect(request.url.queryParameters['make'], 'Fiat');
      expect(request.url.queryParameters['model'], 'Panda');
      return http.Response(
        jsonEncode({
          'data': [
            {
              'trim': 'City Cross',
              'engine': {'fuel_type': 'regular unleaded', 'horsepower_hp': 70},
              'mileage': {'fuel_tank_capacity': 9.8, 'combined_mpg': 40},
            },
            {'trim': 'City Cross'},
            {'trim': 'Lounge'},
          ],
        }),
        200,
      );
    });

    final lookup = CarApiCatalogLookup(client: client);
    final trims = await lookup.trims(make: 'Fiat', model: 'Panda');

    expect(trims.map((t) => t.name), ['City Cross', 'Lounge']);
    expect(trims.first.fuelType, FuelType.petrol);
    expect(trims.first.powerPs, 70);
    expect(trims.first.tankCapacityL, closeTo(37.1, 0.1));
    expect(trims.first.consumptionL100, closeTo(5.9, 0.1));
  });
}
