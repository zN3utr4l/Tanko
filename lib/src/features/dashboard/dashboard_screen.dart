import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../domain/models/vehicle.dart';
import '../expenses/expense_form_screen.dart';
import '../fillups/fill_up_form_screen.dart';
import '../stats/stats_providers.dart';
import 'dashboard_providers.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(dashboardVehicleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tanko')),
      body: vehicleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (vehicle) {
          if (vehicle == null) {
            return const Center(
              child: Text('Aggiungi un veicolo per iniziare.'),
            );
          }
          final stats = ref.watch(vehicleStatsProvider(vehicle.id));
          final cost = ref.watch(costSummaryProvider(vehicle.id));
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text(
                  '${vehicle.make} ${vehicle.model}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                children: [
                  StatCard(
                    label: 'Costo totale',
                    value: cost.maybeWhen(
                      data: (c) => fmtEuro(c.totalCost),
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    label: 'Costo / km',
                    value: cost.maybeWhen(
                      data: (c) => c.costPerKm == null
                          ? '—'
                          : '${fmtEuro(c.costPerKm!)}/km',
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    label: 'Spesa carburante',
                    value: stats.maybeWhen(
                      data: (s) => fmtEuro(s.totalSpend),
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    label: 'Consumo medio',
                    value: stats.maybeWhen(
                      data: (s) => s.avgConsumption == null
                          ? '—'
                          : fmtConsumption(s.avgConsumption!),
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    label: 'Prezzo medio',
                    value: stats.maybeWhen(
                      data: (s) => s.avgPricePerLiter == null
                          ? '—'
                          : '${fmtEuro(s.avgPricePerLiter!)}/L',
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    label: 'Km totali',
                    value: stats.maybeWhen(
                      data: (s) => fmtKm(s.totalKm),
                      orElse: () => '—',
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: vehicleAsync.maybeWhen(
        data: (v) => v == null ? null : _AddFab(vehicle: v),
        orElse: () => null,
      ),
    );
  }
}

class _AddFab extends StatelessWidget {
  const _AddFab({required this.vehicle});
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.local_gas_station,
                  color: Colors.teal,
                ),
                title: const Text('Rifornimento'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FillUpFormScreen(vehicleId: vehicle.id),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.payments, color: Colors.amber),
                title: const Text('Spesa'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ExpenseFormScreen(vehicleId: vehicle.id),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      child: const Icon(Icons.add),
    );
  }
}
