import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/importer/excel_importer.dart';
import '../../providers.dart';
import '../vehicles/vehicle_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );
    final bytes = picked?.files.single.bytes;
    if (bytes == null) return;

    final vehicles = await ref.read(vehicleRepositoryProvider).all();
    final cats = await ref.read(categoryRepositoryProvider).all();
    if (vehicles.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crea prima un veicolo.')),
        );
      }
      return;
    }
    final defaultCat =
        cats.firstWhere((c) => c.isDefault, orElse: () => cats.first);
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
            onTap: () => _import(context, ref),
          ),
        ],
      ),
    );
  }
}
