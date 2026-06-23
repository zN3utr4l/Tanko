import 'package:carburo/src/data/catalog/offline_catalog.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

const _json = '''
{
  "version": 1,
  "makes": [
    {"name": "Renault", "models": [
      {"name": "Clio", "fuel": "hybrid", "consumption": 4.3, "tankL": 39, "powerPs": 145}
    ]},
    {"name": "Fiat", "models": [
      {"name": "Panda", "fuel": "petrol", "consumption": 5.7, "tankL": 37, "powerPs": 70,
        "trims": [{"name": "Lounge"}, {"name": "4x4", "powerPs": 85}]},
      {"name": "500e", "fuel": "electric"}
    ]}
  ]
}
''';

void main() {
  OfflineCatalog build() =>
      OfflineCatalog(loadAsset: (_) async => _json);

  test('makes are returned alphabetically', () async {
    expect(await build().makes(), ['Fiat', 'Renault']);
  });

  test('models lookup is case-insensitive and carries specs', () async {
    final cat = build();
    final models = await cat.models('fIaT');
    expect(models.map((m) => m.name), ['Panda', '500e']);

    final panda = models.first;
    expect(panda.make, 'Fiat');
    expect(panda.fuelType, FuelType.petrol);
    expect(panda.consumptionL100, 5.7);
    expect(panda.tankCapacityL, 37);
    expect(panda.powerPs, 70);
  });

  test('electric model has null fuel-economy specs', () async {
    final ev = (await build().models('Fiat')).last;
    expect(ev.name, '500e');
    expect(ev.fuelType, FuelType.electric);
    expect(ev.consumptionL100, isNull);
    expect(ev.tankCapacityL, isNull);
  });

  test('unknown make returns empty list', () async {
    expect(await build().models('DeLorean'), isEmpty);
  });

  test('trims parse with optional spec overrides; absent trims is empty', () async {
    final models = await build().models('Fiat');
    final panda = models.firstWhere((m) => m.name == 'Panda');
    expect(panda.trims.map((t) => t.name), ['Lounge', '4x4']);
    expect(panda.trims.first.powerPs, isNull);
    expect(panda.trims[1].powerPs, 85);

    final ev = models.firstWhere((m) => m.name == '500e');
    expect(ev.trims, isEmpty);
  });
}
