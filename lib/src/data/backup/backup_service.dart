import 'dart:convert';
import 'package:csv/csv.dart';
import '../../domain/models/backup_data.dart';
import '../../domain/models/expense.dart';
import '../../domain/models/fill_up.dart';

/// Serializes/deserializes the full dataset for backup. Pure (no I/O).
class BackupService {
  const BackupService();

  static const currentSchemaVersion = 3;
  static const _supportedVersions = {1, 2, 3};

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

  BackupPreview preview(BackupData data) => BackupPreview(
    schemaVersion: data.schemaVersion,
    vehicles: data.vehicles.length,
    categories: data.categories.length,
    fillUps: data.fillUps.length,
    expenses: data.expenses.length,
    reminders: data.reminders.length,
  );

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

  String expensesCsv(
    List<Expense> expenses, {
    Map<int, String> categoryNames = const {},
  }) {
    final rows = <List<Object?>>[
      [
        'date',
        'amount',
        'categoryId',
        'categoryName',
        'odometer',
        'description',
        'isRecurring',
      ],
      for (final e in expenses)
        [
          e.date.toIso8601String(),
          e.amount,
          e.categoryId,
          categoryNames[e.categoryId],
          e.odometer,
          e.description,
          e.isRecurring,
        ],
    ];
    return Csv(lineDelimiter: '\n').encode(rows);
  }
}

class BackupPreview {
  const BackupPreview({
    required this.schemaVersion,
    required this.vehicles,
    required this.categories,
    required this.fillUps,
    required this.expenses,
    required this.reminders,
  });

  final int schemaVersion;
  final int vehicles;
  final int categories;
  final int fillUps;
  final int expenses;
  final int reminders;

  String get summary {
    return [
      'Schema backup v$schemaVersion',
      _line(vehicles, 'veicolo', 'veicoli'),
      _line(categories, 'categoria', 'categorie'),
      _line(fillUps, 'rifornimento', 'rifornimenti'),
      _line(expenses, 'spesa', 'spese'),
      _line(reminders, 'scadenza', 'scadenze'),
    ].join('\n');
  }

  String _line(int count, String singular, String plural) =>
      '$count ${count == 1 ? singular : plural}';
}
