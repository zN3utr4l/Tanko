import 'dart:convert';
import 'package:csv/csv.dart';
import '../../domain/models/backup_data.dart';
import '../../domain/models/expense.dart';
import '../../domain/models/fill_up.dart';

/// Serializes/deserializes the full dataset for backup. Pure (no I/O).
class BackupService {
  const BackupService();

  static const currentSchemaVersion = 2;
  static const _supportedVersions = {1, 2};

  String toJson(BackupData data) =>
      const JsonEncoder.withIndent('  ').convert(data.toJson());

  /// Throws [FormatException] on malformed JSON or an unsupported schema.
  /// Accepts v1 backups (expenses/reminders simply absent) and v2.
  BackupData fromJson(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Backup non valido');
    }
    final version = decoded['schemaVersion'];
    if (!_supportedVersions.contains(version)) {
      throw FormatException('Versione backup non supportata: $version');
    }
    return BackupData.fromJson(decoded);
  }

  String toCsv(List<FillUp> fills) {
    final rows = <List<Object?>>[
      [
        'date',
        'amount',
        'liters',
        'odometer',
        'isFull',
        'rangeKm',
        'station',
        'note',
      ],
      for (final f in fills)
        [
          f.date.toIso8601String(),
          f.amount,
          f.liters,
          f.odometer,
          f.isFull,
          f.rangeKm,
          f.station,
          f.note,
        ],
    ];
    return Csv(lineDelimiter: '\n').encode(rows);
  }

  String expensesCsv(List<Expense> expenses) {
    final rows = <List<Object?>>[
      [
        'date',
        'amount',
        'categoryId',
        'odometer',
        'description',
        'isRecurring',
      ],
      for (final e in expenses)
        [
          e.date.toIso8601String(),
          e.amount,
          e.categoryId,
          e.odometer,
          e.description,
          e.isRecurring,
        ],
    ];
    return Csv(lineDelimiter: '\n').encode(rows);
  }
}
