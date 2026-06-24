import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide XFile;
import '../../data/backup/backup_service.dart';
import '../../data/importer/excel_importer.dart';
import '../../data/settings/lookup_settings.dart';
import '../../domain/models/backup_data.dart';
import '../../domain/models/vehicle.dart';
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
    // Open unconstrained (*/*): a single-MIME filter greys out Google Drive
    // entries in the system picker. Validate the extension after picking.
    final file = await openFile();
    if (file == null) return;
    if (!file.name.toLowerCase().endsWith('.json')) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleziona un file .json')),
        );
      }
      return;
    }
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
    // Open unconstrained (*/*): a single-MIME filter greys out Google Drive
    // entries in the system picker. Validate the extension after picking.
    final file = await openFile();
    if (file == null) return;
    if (!file.name.toLowerCase().endsWith('.xlsx')) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleziona un file .xlsx')),
        );
      }
      return;
    }
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
    if (!context.mounted) return;
    final target = await _chooseImportVehicle(context, vehicles);
    if (target == null) return;
    final defaultCat = categories.firstWhere(
      (c) => c.isDefault,
      orElse: () => categories.first,
    );
    final existing = await ref
        .read(fillUpRepositoryProvider)
        .forVehicle(target.id);
    final result = const ExcelImporter().parseBytes(
      bytes,
      vehicleId: target.id,
      categoryId: defaultCat.id,
      existing: existing,
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
            'Duplicate: ${result.duplicates}\n'
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

  Future<Vehicle?> _chooseImportVehicle(
    BuildContext context,
    List<Vehicle> vehicles,
  ) async {
    if (vehicles.length == 1) return vehicles.single;
    return showDialog<Vehicle>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Veicolo import'),
        children: [
          for (final v in vehicles)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, v),
              child: Text('${v.make} ${v.model}'),
            ),
        ],
      ),
    );
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
    final lookupSettings = ref.watch(lookupSettingsProvider);
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
          lookupSettings.maybeWhen(
            data: (settings) => _LookupSettingsSection(
              settings: settings,
              onChanged: (next) async {
                await ref.read(lookupSettingsStoreProvider).save(next);
                ref.invalidate(lookupSettingsProvider);
              },
            ),
            orElse: () => const LinearProgressIndicator(),
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

class _LookupSettingsSection extends StatefulWidget {
  const _LookupSettingsSection({
    required this.settings,
    required this.onChanged,
  });

  final LookupSettings settings;
  final ValueChanged<LookupSettings> onChanged;

  @override
  State<_LookupSettingsSection> createState() => _LookupSettingsSectionState();
}

class _LookupSettingsSectionState extends State<_LookupSettingsSection> {
  late final TextEditingController _openApiKey;

  @override
  void initState() {
    super.initState();
    _openApiKey = TextEditingController(text: widget.settings.openApiKey);
  }

  @override
  void didUpdateWidget(covariant _LookupSettingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings.openApiKey != widget.settings.openApiKey &&
        _openApiKey.text != widget.settings.openApiKey) {
      _openApiKey.text = widget.settings.openApiKey;
    }
  }

  @override
  void dispose() {
    _openApiKey.dispose();
    super.dispose();
  }

  void _save(LookupSettings settings) => widget.onChanged(settings);

  @override
  Widget build(BuildContext context) {
    final settings = widget.settings;
    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.directions_car_filled_outlined),
          title: const Text('Lookup veicoli online'),
          value: settings.vehicleOnlineLookupEnabled,
          onChanged: (value) =>
              _save(settings.copyWith(vehicleOnlineLookupEnabled: value)),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.local_gas_station_outlined),
          title: const Text('Ricerca distributori online'),
          value: settings.stationOnlineLookupEnabled,
          onChanged: (value) =>
              _save(settings.copyWith(stationOnlineLookupEnabled: value)),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.system_update_alt_outlined),
          title: const Text('Controllo aggiornamenti online'),
          value: settings.updateChecksEnabled,
          onChanged: (value) =>
              _save(settings.copyWith(updateChecksEnabled: value)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: TextField(
            controller: _openApiKey,
            decoration: const InputDecoration(
              labelText: 'Openapi API key',
              prefixIcon: Icon(Icons.key_outlined),
            ),
            obscureText: true,
            onSubmitted: (value) =>
                _save(settings.copyWith(openApiKey: value.trim())),
          ),
        ),
      ],
    );
  }
}
