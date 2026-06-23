import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide XFile;
import '../../data/backup/backup_service.dart';
import '../../data/importer/excel_importer.dart';
import '../../domain/models/backup_data.dart';
import '../../providers.dart';
import '../dashboard/dashboard_providers.dart';
import '../updates/update_providers.dart';
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
    final expenses = await ref.read(expenseRepositoryProvider).all();
    final reminders = await ref.read(reminderRepositoryProvider).all();
    return BackupData(
      vehicles: vehicles,
      categories: categories,
      fillUps: fills,
      expenses: expenses,
      reminders: reminders,
    );
  }

  Future<void> _exportJson(WidgetRef ref) async {
    final data = await _gather(ref);
    await _share(_backup.toJson(data), 'carburo_backup.json');
  }

  Future<void> _exportCsv(WidgetRef ref) async {
    final data = await _gather(ref);
    await _share(_backup.toCsv(data.fillUps), 'carburo_rifornimenti.csv');
  }

  Future<void> _exportExpensesCsv(WidgetRef ref) async {
    final data = await _gather(ref);
    await _share(_backup.expensesCsv(data.expenses), 'carburo_spese.csv');
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    const typeGroup = XTypeGroup(label: 'Carburo backup', extensions: ['json']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;
    final content = await file.readAsString();

    final BackupData data;
    try {
      data = _backup.fromJson(content);
    } on FormatException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup non valido: ${e.message}')),
        );
      }
      return;
    }

    // Atomic restore: a malformed/FK-violating backup must not half-overwrite
    // the only local copy. Insert in FK order inside one transaction.
    final cats = ref.read(categoryRepositoryProvider);
    final vehicles = ref.read(vehicleRepositoryProvider);
    final fills = ref.read(fillUpRepositoryProvider);
    final expenses = ref.read(expenseRepositoryProvider);
    final reminders = ref.read(reminderRepositoryProvider);
    try {
      await ref.read(appDatabaseProvider).transaction(() async {
        for (final c in data.categories) {
          await cats.upsert(c);
        }
        for (final v in data.vehicles) {
          await vehicles.upsert(v);
        }
        for (final r in data.reminders) {
          await reminders.upsert(r);
        }
        for (final f in data.fillUps) {
          await fills.upsert(f);
        }
        for (final e in data.expenses) {
          await expenses.upsert(e);
        }
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ripristino fallito (annullato): $e')),
        );
      }
      return;
    }
    ref.invalidate(vehiclesProvider);
    ref.invalidate(dashboardVehicleProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ripristinati ${data.vehicles.length} veicoli, '
            '${data.fillUps.length} rifornimenti, '
            '${data.expenses.length} spese.',
          ),
        ),
      );
    }
  }

  Future<void> _importExcel(BuildContext context, WidgetRef ref) async {
    const typeGroup = XTypeGroup(label: 'Excel', extensions: ['xlsx']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;
    final bytes = await file.readAsBytes();

    final vehicles = await ref.read(vehicleRepositoryProvider).all();
    final categories = await ref.read(categoryRepositoryProvider).all();
    if (vehicles.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Crea prima un veicolo.')));
      }
      return;
    }
    final defaultCat = categories.firstWhere(
      (c) => c.isDefault,
      orElse: () => categories.first,
    );
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

  Future<void> _checkUpdates(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final current = await ref.read(currentVersionProvider.future);
      final release = await ref
          .read(updateServiceProvider)
          .checkForUpdate(current);
      if (!context.mounted) return;
      if (release == null) {
        messenger.showSnackBar(const SnackBar(content: Text('Sei aggiornato')));
        return;
      }
      ref.read(availableUpdateProvider.notifier).set(release);
      await showUpdateAvailableDialog(context, ref, release);
    } catch (error) {
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Controllo non riuscito: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVersion = ref.watch(currentVersionProvider).asData?.value;
    final availableUpdate = ref.watch(availableUpdateProvider);
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
            leading: const Icon(Icons.table_chart_outlined),
            title: const Text('Esporta spese (CSV)'),
            onTap: () => _exportExpensesCsv(ref),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Ripristina da backup (JSON)'),
            onTap: () => _restore(context, ref),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.system_update),
            title: const Text('Aggiornamenti'),
            subtitle: Text(
              availableUpdate == null
                  ? 'Versione attuale: ${currentVersion ?? '...'}'
                  : 'Carburo v${availableUpdate.version} disponibile',
            ),
            trailing: availableUpdate == null
                ? null
                : TextButton.icon(
                    onPressed: () =>
                        showUpdateDownloadDialog(context, ref, availableUpdate),
                    icon: const Icon(Icons.download),
                    label: const Text('Aggiorna'),
                  ),
            onTap: () => _checkUpdates(context, ref),
          ),
        ],
      ),
    );
  }
}
