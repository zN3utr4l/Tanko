import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/data/importer/excel_importer.dart';
import 'package:carburo/src/domain/models/fill_up.dart';

void main() {
  const importer = ExcelImporter();

  test(
    'maps data rows, skips header and empty, flags zero-odometer anomaly',
    () {
      final rows = <List<Object?>>[
        ['RENAULT Clio', null, null, null, null], // title
        [
          'Data',
          'Importo',
          'Kilometraggio',
          'Autonomia',
          'Differenza',
        ], // header
        [45146, 300, 0, 0, 3963], // anomaly: odometer 0
        [45174, 40, 3963, 590, 4553], // normal
        [null, null, null, null, null], // empty -> ignored, not counted
      ];

      final result = importer.mapRows(rows, vehicleId: 7, categoryId: 1);

      expect(result.rows, hasLength(2));
      expect(result.skipped, 0); // blank rows are not "skipped" data
      expect(result.warnings, isNotEmpty); // zero-odometer anomaly flagged

      final anomaly = result.rows.first;
      expect(anomaly.vehicleId, 7);
      expect(anomaly.amount, 300);
      expect(anomaly.odometer, 0);
      expect(anomaly.liters, isNull);
      expect(anomaly.rangeKm, 0); // Autonomia (col index 3) is 0 for this row
      expect(
        anomaly.date,
        DateTime(1899, 12, 30).add(const Duration(days: 45146)),
      );

      final normal = result.rows[1];
      expect(normal.amount, 40);
      expect(normal.odometer, 3963);
      expect(normal.rangeKm, 590); // Autonomia column
    },
  );

  test('section-label and totals rows are ignored, not counted as skipped', () {
    final rows = <List<Object?>>[
      ['title', null, null, null, null],
      ['Data', 'Importo', 'Km', 'Aut', 'Diff'],
      [DateTime(2023, 8, 21), 40, 3963, 590, 4553], // real fill-up
      [null, null, null, null, null, null, 'SPESE MIE'], // section label
      [null, null, null, null, null, null, 'SUM(B3:B7)'], // totals row
    ];

    final result = importer.mapRows(rows, vehicleId: 1, categoryId: 1);

    expect(result.rows, hasLength(1));
    expect(result.skipped, 0);
    expect(result.warnings, isEmpty);
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

  test('skips rows with an implausible date (corrupt serial)', () {
    final rows = <List<Object?>>[
      ['title', null, null, null, null],
      ['Data', 'Importo', 'Km', 'Aut', 'Diff'],
      [6686029, 40, 99999, 590, 4553], // corrupt serial -> year ~20205
      [45174, 40, 3963, 590, 4553], // valid 2023 row
    ];

    final result = importer.mapRows(rows, vehicleId: 1, categoryId: 1);

    expect(result.rows, hasLength(1));
    expect(result.rows.single.date.year, lessThan(2100));
    expect(result.skipped, 1);
    expect(result.warnings.any((w) => w.contains('non valida')), isTrue);
  });

  test('skips rows that duplicate existing fill-ups', () {
    final rows = <List<Object?>>[
      ['title', null, null, null, null],
      ['Data', 'Importo', 'Km', 'Aut', 'Diff'],
      [DateTime(2023, 8, 21), 40, 3963, 590, 4553],
      [DateTime(2023, 9, 21), 55, 4553, 610, 5163],
    ];
    final result = importer.mapRows(
      rows,
      vehicleId: 1,
      categoryId: 1,
      existing: [
        FillUp(
          id: 1,
          vehicleId: 1,
          date: DateTime(2023, 8, 21),
          amount: 40,
          odometer: 3963,
          categoryId: 1,
          createdAt: DateTime(2023, 8, 21),
          updatedAt: DateTime(2023, 8, 21),
        ),
      ],
    );

    expect(result.rows, hasLength(1));
    expect(result.rows.single.odometer, 4553);
    expect(result.duplicates, 1);
    expect(result.skipped, 1);
  });
}
