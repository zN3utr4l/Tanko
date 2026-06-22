import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/backup/backup_service.dart';
import '../../data/importer/excel_importer.dart';
import '../../domain/models/backup_data.dart';
import '../../providers.dart';
import '../dashboard/dashboard_providers.dart';
import '../vehicles/vehicle_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _backup = BackupService();

  Future<void> _share(String content, String filename) async {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, filename));
    await file.writeAsString(content);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<BackupData> _gather(WidgetRef ref) async {
    final vehicles = await ref.read(vehicleRepositoryProvider).all();
    final categories = await ref.read(categoryRepositoryProvider).all();
    final fills = await ref.read(fillUpRepositoryProvider).all();
    return BackupData(
      vehicles: vehicles,
      categories: categories,
      fillUps: fills,
    );
  }

  Future<void> _exportJson(WidgetRef ref) async {
    final data = await _gather(ref);
    await _share(_backup.toJson(data), 'tanko_backup.json');
  }

  Future<void> _exportCsv(WidgetRef ref) async {
    final data = await _gather(ref);
    await _share(_backup.toCsv(data.fillUps), 'tanko_rifornimenti.csv');
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    final bytes = picked?.files.single.bytes;
    if (bytes == null) return;

    final BackupData data;
    try {
      data = _backup.fromJson(String.fromCharCodes(bytes));
    } on FormatException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup non valido: ${e.message}')),
        );
      }
      return;
    }

    final cats = ref.read(categoryRepositoryProvider);
    final vehicles = ref.read(vehicleRepositoryProvider);
    final fills = ref.read(fillUpRepositoryProvider);
    for (final c in data.categories) {
      await cats.upsert(c);
    }
    for (final v in data.vehicles) {
      await vehicles.upsert(v);
    }
    for (final f in data.fillUps) {
      await fills.upsert(f);
    }
    ref.invalidate(vehiclesProvider);
    ref.invalidate(dashboardVehicleProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ripristinati ${data.vehicles.length} veicoli e '
            '${data.fillUps.length} rifornimenti.',
          ),
        ),
      );
    }
  }

  Future<void> _importExcel(BuildContext context, WidgetRef ref) async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );
    final bytes = picked?.files.single.bytes;
    if (bytes == null) return;

    final vehicles = await ref.read(vehicleRepositoryProvider).all();
    final categories = await ref.read(categoryRepositoryProvider).all();
    if (vehicles.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crea prima un veicolo.')),
        );
      }
      return;
    }
    final defaultCat =
        categories.firstWhere((c) => c.isDefault, orElse: () => categories.first);
    final result = const ExcelImporter().parseBytes(
      bytes,
      vehicleId: vehicles.first.id,
      categoryId: defaultCat.id,
    );
    final repo = ref.read(fillUpRepositoryProvider);
    for (final f in result.rows) {
      await repo.upsert(f);
    }
    ref.invalidate(vehiclesProvider);
    ref.invalidate(dashboardVehicleProvider);

    if (context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Import completato'),
          content: Text(
            'Importate: ${result.rows.length}\n'
            'Saltate: ${result.skipped}\n'
            'Avvisi: ${result.warnings.length}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Importa da Excel'),
            subtitle: const Text('Carica il tuo Consumi.xlsx'),
            onTap: () => _importExcel(context, ref),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Esporta backup (JSON)'),
            subtitle: const Text('Tutti i dati, ripristinabili'),
            onTap: () => _exportJson(ref),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Esporta rifornimenti (CSV)'),
            onTap: () => _exportCsv(ref),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Ripristina da backup (JSON)'),
            onTap: () => _restore(context, ref),
          ),
        ],
      ),
    );
  }
}
