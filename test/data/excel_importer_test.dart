import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/data/importer/excel_importer.dart';

void main() {
  const importer = ExcelImporter();

  test('maps data rows, skips header and empty, flags zero-odometer anomaly', () {
    final rows = <List<Object?>>[
      ['RENAULT Clio', null, null, null, null], // title
      ['Data', 'Importo', 'Kilometraggio', 'Autonomia', 'Differenza'], // header
      [45146, 300, 0, 0, 3963], // anomaly: odometer 0
      [45174, 40, 3963, 590, 4553], // normal
      [null, null, null, null, null], // empty -> skipped
    ];

    final result = importer.mapRows(rows, vehicleId: 7, categoryId: 1);

    expect(result.rows, hasLength(2));
    expect(result.skipped, 1);
    expect(result.warnings, isNotEmpty); // zero-odometer anomaly flagged

    final anomaly = result.rows.first;
    expect(anomaly.vehicleId, 7);
    expect(anomaly.amount, 300);
    expect(anomaly.odometer, 0);
    expect(anomaly.liters, isNull);
    expect(anomaly.rangeKm, 0); // Autonomia (col index 3) is 0 for this row
    expect(anomaly.date, DateTime(1899, 12, 30).add(const Duration(days: 45146)));

    final normal = result.rows[1];
    expect(normal.amount, 40);
    expect(normal.odometer, 3963);
    expect(normal.rangeKm, 590); // Autonomia column
  });

  test('accepts DateTime values in the date column', () {
    final rows = <List<Object?>>[
      ['title', null, null, null, null],
      ['Data', 'Importo', 'Km', 'Aut', 'Diff'],
      [DateTime(2023, 8, 21), 40, 3963, 590, 4553],
    ];
    final result = importer.mapRows(rows, vehicleId: 1, categoryId: 1);
    expect(result.rows.single.date, DateTime(2023, 8, 21));
  });
}
