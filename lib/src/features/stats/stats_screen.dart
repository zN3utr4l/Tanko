import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../domain/models/comparison.dart';
import '../../domain/models/monthly_total.dart';
import '../dashboard/dashboard_providers.dart';
import '../fillups/fillup_providers.dart';
import 'stats_providers.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(dashboardVehicleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiche')),
      body: vehicleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (vehicle) {
          if (vehicle == null) {
            return const Center(child: Text('Aggiungi un veicolo per iniziare.'));
          }
          final months = ref.watch(monthlySpendProvider(vehicle.id));
          final comparison = ref.watch(vehicleComparisonProvider(vehicle.id));
          final fills = ref.watch(fillUpsProvider(vehicle.id));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Confronto reale vs dichiarato',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              comparison.maybeWhen(
                data: (c) => _ComparisonCard(c),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              Text('Spesa mensile',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: months.maybeWhen(
                  data: (m) => m.isEmpty
                      ? const Center(child: Text('Nessun dato'))
                      : _MonthlySpendChart(m),
                  orElse: () => const Center(child: CircularProgressIndicator()),
                ),
              ),
              const SizedBox(height: 24),
              Text('Andamento prezzo al litro',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: fills.maybeWhen(
                  data: (list) {
                    final spots = <FlSpot>[];
                    final sorted = [...list]
                      ..sort((a, b) => a.date.compareTo(b.date));
                    var i = 0;
                    for (final f in sorted) {
                      if (f.liters != null && f.liters! > 0) {
                        spots.add(FlSpot(i.toDouble(), f.amount / f.liters!));
                        i++;
                      }
                    }
                    return spots.isEmpty
                        ? const Center(child: Text('Nessun dato'))
                        : _PriceTrendChart(spots);
                  },
                  orElse: () => const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard(this.c);
  final ConsumptionComparison c;

  String _pct(double? v) =>
      v == null ? '' : ' (${v >= 0 ? '+' : ''}${v.toStringAsFixed(1)}%)';

  @override
  Widget build(BuildContext context) {
    if (!c.hasConsumption && !c.hasRange) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Dati insufficienti (servono litri e specifiche auto).'),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (c.hasConsumption)
              Text(
                'Consumo: ${fmtConsumption(c.realConsumption!)} reale '
                'vs ${fmtConsumption(c.mfrConsumption!)} dichiarato'
                '${_pct(c.consumptionDeltaPct)}',
              ),
            if (c.hasRange) ...[
              const SizedBox(height: 8),
              Text(
                'Autonomia: ${fmtKm(c.realRangeKm!)} stimata '
                'vs ${fmtKm(c.mfrRangeKm!)} dichiarata'
                '${_pct(c.rangeDeltaPct)}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MonthlySpendChart extends StatelessWidget {
  const _MonthlySpendChart(this.months);
  final List<MonthlyTotal> months;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          for (var i = 0; i < months.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(toY: months[i].total)],
            ),
        ],
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= months.length) return const SizedBox.shrink();
                return Text(months[i].label,
                    style: const TextStyle(fontSize: 9));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceTrendChart extends StatelessWidget {
  const _PriceTrendChart(this.spots);
  final List<FlSpot> spots;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(spots: spots, isCurved: true, dotData: const FlDotData(show: false)),
        ],
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          bottomTitles: AxisTitles(),
        ),
      ),
    );
  }
}
