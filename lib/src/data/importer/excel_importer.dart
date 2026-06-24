import 'dart:typed_data';
import 'package:excel/excel.dart';
import '../../domain/models/fill_up.dart';
import '../../domain/models/import_result.dart';

class ExcelImporter {
  const ExcelImporter();

  static final _epoch = DateTime(1899, 12, 30);

  double? _num(Object? v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll(',', '.'));
  }

  DateTime? _date(Object? v) {
    if (v is DateTime) return v;
    final n = _num(v);
    return n == null ? null : _epoch.add(Duration(days: n.toInt()));
  }

  /// Unwraps a drift `CellValue` into a raw `num` / `DateTime` / `String`.
  Object? _raw(CellValue? v) => switch (v) {
    null => null,
    IntCellValue() => v.value,
    DoubleCellValue() => v.value,
    DateCellValue() => DateTime(v.year, v.month, v.day),
    DateTimeCellValue() => DateTime(
      v.year,
      v.month,
      v.day,
      v.hour,
      v.minute,
      v.second,
    ),
    TextCellValue() => v.value.toString(),
    _ => v.toString(),
  };

  /// Maps already-extracted rows. Row 0 = title, row 1 = header, data from row 2.
  /// Columns: 0=date (serial or DateTime), 1=amount, 2=odometer, 3=rangeKm.
  ImportResult mapRows(
    List<List<Object?>> rows, {
    required int vehicleId,
    required int categoryId,
    List<FillUp> existing = const [],
  }) {
    final out = <FillUp>[];
    final warnings = <String>[];
    var skipped = 0;
    var duplicates = 0;
    final now = DateTime.now();
    final seen = {
      for (final f in existing)
        _duplicateKey(f.date, f.amount, f.odometer): true,
    };

    for (var i = 2; i < rows.length; i++) {
      final r = rows[i];
      final date = _date(r.isNotEmpty ? r[0] : null);
      final amount = _num(r.length > 1 ? r[1] : null);
      final odometer = _num(r.length > 2 ? r[2] : null);

      if (date == null && amount == null && odometer == null) {
        skipped++;
        continue;
      }
      if (date == null || amount == null || odometer == null) {
        skipped++;
        warnings.add('Riga ${i + 1}: dati incompleti, saltata.');
        continue;
      }
      if (odometer == 0) {
        warnings.add(
          'Riga ${i + 1}: odometro 0 (anomalia) — importata comunque.',
        );
      }
      final key = _duplicateKey(date, amount, odometer);
      if (seen.containsKey(key)) {
        skipped++;
        duplicates++;
        warnings.add('Riga ${i + 1}: rifornimento duplicato, saltato.');
        continue;
      }
      seen[key] = true;

      out.add(
        FillUp(
          id: 0,
          vehicleId: vehicleId,
          date: date,
          amount: amount,
          odometer: odometer,
          rangeKm: _num(r.length > 3 ? r[3] : null),
          categoryId: categoryId,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    return ImportResult(
      rows: out,
      skipped: skipped,
      duplicates: duplicates,
      warnings: warnings,
    );
  }

  String _duplicateKey(DateTime date, double amount, double odometer) =>
      '${DateTime(date.year, date.month, date.day).toIso8601String()}|'
      '${amount.toStringAsFixed(2)}|${odometer.toStringAsFixed(1)}';

  ImportResult parseBytes(
    Uint8List bytes, {
    required int vehicleId,
    required int categoryId,
    List<FillUp> existing = const [],
  }) {
    final book = Excel.decodeBytes(bytes);
    final sheet = book.tables[book.tables.keys.first]!;
    final rows = sheet.rows
        .map((row) => row.map((cell) => _raw(cell?.value)).toList())
        .toList();
    return mapRows(
      rows,
      vehicleId: vehicleId,
      categoryId: categoryId,
      existing: existing,
    );
  }
}
