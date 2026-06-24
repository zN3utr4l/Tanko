import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/data/lookup/mimit_fuel_price_lookup.dart';
import 'package:carburo/src/domain/models/enums.dart';

void main() {
  const anagrafica = '''
Estrazione del 2026-06-23
idImpianto|Gestore|Bandiera|Tipo Impianto|Nome Impianto|Indirizzo|Comune|Provincia|Latitudine|Longitudine
1|GESTORE UNO|Q8|Stradale|Q8 Torino|Via Roma 1|TORINO|TO|45.0700|7.6800
2|GESTORE DUE|Eni|Stradale|Eni Torino|Via Po 2|TORINO|TO|45.0710|7.6810
''';

  const prezzi = '''
Estrazione del 2026-06-23
idImpianto|descCarburante|prezzo|isSelf|dtComu
1|Benzina|1.899|1|22/06/2026 20:00:06
1|Gasolio|1.799|1|22/06/2026 20:00:06
2|Benzina|1.979|1|22/06/2026 20:00:06
''';

  test('parses and joins MIMIT station registry with daily prices', () {
    final candidates = parseMimitFuelPriceData(
      anagraficaCsv: anagrafica,
      pricesCsv: prezzi,
      latitude: 45.0701,
      longitude: 7.6801,
      radiusMeters: 250,
    );

    expect(candidates, hasLength(2));
    expect(candidates.first.name, 'Q8 Torino');
    expect(candidates.first.brand, 'Q8');
    expect(candidates.first.extractedAt, DateTime(2026, 6, 23));
    expect(candidates.first.bestPriceFor(FuelType.petrol)!.price, 1.899);
    expect(candidates.first.bestPriceFor(FuelType.diesel)!.price, 1.799);
  });

  test('prefers self-service price when multiple matching prices exist', () {
    final candidates = parseMimitFuelPriceData(
      anagraficaCsv: anagrafica,
      pricesCsv: '''
Estrazione del 2026-06-23
idImpianto|descCarburante|prezzo|isSelf|dtComu
1|Benzina|2.199|0|22/06/2026 20:00:07
1|Benzina|1.899|1|22/06/2026 20:00:06
''',
      latitude: 45.0701,
      longitude: 7.6801,
    );

    final price = candidates.first.bestPriceFor(FuelType.petrol)!;
    expect(price.isSelf, isTrue);
    expect(price.price, 1.899);
  });
}
