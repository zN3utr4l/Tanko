import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'vehicle_providers.dart';
import 'vehicle_form_screen.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Veicoli')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const VehicleFormScreen()),
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
                      trailing: v.isDefault ? const Icon(Icons.star) : null,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VehicleFormScreen(initial: v),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
