import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/vehicle.dart';
import '../../providers.dart';
import '../dashboard/dashboard_providers.dart';
import 'vehicle_providers.dart';
import 'vehicle_form_screen.dart';
import 'add_vehicle_wizard_screen.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Vehicle v,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminare il veicolo?'),
        content: Text(
          'Verranno eliminati anche tutti i rifornimenti, le spese e le '
          'scadenze di "${v.make} ${v.model}". L\'operazione non è reversibile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(vehicleRepositoryProvider).delete(v.id);
    ref.invalidate(vehiclesProvider);
    ref.invalidate(dashboardVehicleProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Veicoli')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddVehicleWizardScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: vehiclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (vehicles) => vehicles.isEmpty
            ? const Center(child: Text('Nessun veicolo. Aggiungine uno.'))
            : ListView(
                children: [
                  for (final v in vehicles)
                    ListTile(
                      leading: const Icon(Icons.directions_car),
                      title: Text('${v.make} ${v.model}'),
                      subtitle: Text(v.trim ?? ''),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VehicleFormScreen(initial: v),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (v.isDefault)
                            const Icon(Icons.star, color: Colors.amber),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                _confirmDelete(context, ref, v);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete_outline),
                                  title: Text('Elimina'),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
