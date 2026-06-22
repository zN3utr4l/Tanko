import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/data/catalog/carquery_parser.dart';

void main() {
  const parser = CarQueryParser();

  test('stripJsonp unwraps a JSONP envelope', () {
    expect(parser.stripJsonp(r'?({"Makes":[]});'), '{"Makes":[]}');
    expect(parser.stripJsonp('{"Makes":[]}'), '{"Makes":[]}');
  });

  test('parseMakes reads id and display name', () {
    const body =
        r'?({"Makes":[{"make_id":"renault","make_display":"Renault"},{"make_id":"","make_display":""}]});';
    final makes = parser.parseMakes(body);
    expect(makes, hasLength(1));
    expect(makes.single.id, 'renault');
    expect(makes.single.name, 'Renault');
  });

  test('parseModels reads model names', () {
    const body = '{"Models":[{"model_name":"Clio"},{"model_name":"Megane"}]}';
    expect(parser.parseModels(body), ['Clio', 'Megane']);
  });

  test('parseTrims parses string numbers and maps fuel', () {
    const body =
        '{"Trims":[{'
        '"model_id":"45123",'
        '"model_make_id":"renault",'
        '"model_name":"Clio",'
        '"model_trim":"E-Tech 145 Techno",'
        '"model_year":"2023",'
        '"model_engine_fuel":"Gasoline Hybrid",'
        '"model_lkm_mixed":"4.2",'
        '"model_fuel_cap_l":"39",'
        '"model_engine_power_ps":"145"'
        '}]}';
    final trims = parser.parseTrims(body);
    expect(trims, hasLength(1));
    final t = trims.single;
    expect(t.make, 'renault');
    expect(t.model, 'Clio');
    expect(t.year, 2023);
    expect(t.trim, 'E-Tech 145 Techno');
    expect(t.fuelType, FuelType.hybrid);
    expect(t.consumptionL100, 4.2);
    expect(t.tankCapacityL, 39);
    expect(t.powerPs, 145);
    expect(t.label, '2023 · E-Tech 145 Techno');
  });

  test('mapFuel handles common fuels', () {
    expect(parser.mapFuel('Diesel'), FuelType.diesel);
    expect(parser.mapFuel('Electric'), FuelType.electric);
    expect(parser.mapFuel('Petrol'), FuelType.petrol);
    expect(parser.mapFuel(null), isNull);
  });
}
