import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/models/receipt_data.dart';
import 'package:carburo/src/domain/services/receipt_parser.dart';

void main() {
  const parser = ReceiptParser();

  test(
    'extracts brand, amount, liters, price and date from a typical receipt',
    () {
      final data = parser.parse([
        'ENI STATION',
        'VIA ROMA 12 - TORINO',
        'DIESEL',
        'LITRI 28,50',
        'PREZZO 1,789 EUR/L',
        'IMPORTO EURO 50,99',
        'DATA 23/06/2026 14:32',
      ]);
      expect(data.station, 'Eni');
      expect(data.liters, closeTo(28.50, 1e-9));
      expect(data.pricePerLiter, closeTo(1.789, 1e-9));
      expect(data.amount, closeTo(50.99, 1e-9));
      expect(data.date, DateTime(2026, 6, 23));
    },
  );

  test('brand match is case-insensitive and matches as substring', () {
    expect(parser.parse(['stazione q8 di rossi']).station, 'Q8');
  });

  test('totally unreadable input yields all-null, never throws', () {
    final data = parser.parse(['@@@@', '......']);
    expect(data.station, isNull);
    expect(data.amount, isNull);
    expect(data.liters, isNull);
    expect(data.pricePerLiter, isNull);
    expect(data.date, isNull);
  });

  test('empty input yields all-null', () {
    final data = parser.parse([]);
    expect(data, const ReceiptData());
  });
}
