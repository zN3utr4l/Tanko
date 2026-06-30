import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/vehicle.dart';
import '../expenses/expense_form_screen.dart';
import '../fillups/fill_up_form_screen.dart';
import '../stats/stats_providers.dart';
import '../vehicles/widgets/empty_vehicle_prompt.dart';
import 'dashboard_providers.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(dashboardVehicleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Carburo')),
      body: vehicleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (vehicle) {
          if (vehicle == null) {
            return const EmptyVehiclePrompt();
          }
          final stats = ref.watch(vehicleStatsProvider(vehicle.id));
          final cost = ref.watch(costSummaryProvider(vehicle.id));
          final cs = Theme.of(context).colorScheme;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _VehicleHero(
                vehicle: vehicle,
                totalCost: cost.maybeWhen(
                  data: (c) => fmtEuro(c.totalCost),
                  orElse: () => '—',
                ),
                costPerKm: cost.maybeWhen(
                  data: (c) =>
                      c.costPerKm == null ? '—' : '${fmtEuro(c.costPerKm!)}/km',
                  orElse: () => '—',
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Quadro costi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.25,
                children: [
                  StatCard(
                    key: const Key('metric-total-cost'),
                    label: 'Costo totale',
                    icon: Icons.account_balance_wallet_outlined,
                    accentColor: cs.primary,
                    value: cost.maybeWhen(
                      data: (c) => fmtEuro(c.totalCost),
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    key: const Key('metric-cost-per-km'),
                    label: 'Costo / km',
                    icon: Icons.route_outlined,
                    accentColor: cs.tertiary,
                    value: cost.maybeWhen(
                      data: (c) => c.costPerKm == null
                          ? '—'
                          : '${fmtEuro(c.costPerKm!)}/km',
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    label: 'Spesa carburante',
                    icon: Icons.local_gas_station_outlined,
                    accentColor: cs.secondary,
                    value: stats.maybeWhen(
                      data: (s) => fmtEuro(s.totalSpend),
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    label: 'Consumo medio',
                    icon: Icons.speed_outlined,
                    accentColor: cs.primary,
                    value: stats.maybeWhen(
                      data: (s) => s.avgConsumption == null
                          ? '—'
                          : fmtConsumption(s.avgConsumption!),
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    label: 'Prezzo medio',
                    icon: Icons.price_check_outlined,
                    accentColor: cs.tertiary,
                    value: stats.maybeWhen(
                      data: (s) => s.avgPricePerLiter == null
                          ? '—'
                          : '${fmtEuro(s.avgPricePerLiter!)}/L',
                      orElse: () => '—',
                    ),
                  ),
                  StatCard(
                    label: 'Km totali',
                    icon: Icons.timeline_outlined,
                    accentColor: cs.secondary,
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

class _VehicleHero extends StatelessWidget {
  const _VehicleHero({
    required this.vehicle,
    required this.totalCost,
    required this.costPerKm,
  });

  final Vehicle vehicle;
  final String totalCost;
  final String costPerKm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      key: const Key('dashboard-hero'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_car_filled_outlined,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              _HeroBadge(label: _fuelLabel(vehicle.fuelType)),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Garage',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${vehicle.make} ${vehicle.model}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroMeasure(label: 'Costo totale', value: totalCost),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroMeasure(label: 'Costo / km', value: costPerKm),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _fuelLabel(FuelType fuelType) => switch (fuelType) {
    FuelType.petrol => 'Benzina',
    FuelType.diesel => 'Diesel',
    FuelType.hybrid => 'Ibrida',
    FuelType.electric => 'Elettrica',
    FuelType.lpg => 'GPL',
    FuelType.cng => 'Metano',
  };
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _HeroMeasure extends StatelessWidget {
  const _HeroMeasure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
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
                  _openFillUp(context, vehicle);
                },
              ),
              ListTile(
                leading: const Icon(Icons.payments, color: Colors.amber),
                title: const Text('Spesa'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openExpense(context, vehicle);
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

void _openFillUp(BuildContext context, Vehicle vehicle) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => FillUpFormScreen(vehicleId: vehicle.id)),
  );
}

void _openExpense(BuildContext context, Vehicle vehicle) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ExpenseFormScreen(vehicleId: vehicle.id)),
  );
}
