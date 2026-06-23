import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../domain/models/comparison.dart';
import '../../domain/models/monthly_stacked.dart';
import '../../domain/models/monthly_total.dart';
import '../../providers.dart';
import '../dashboard/dashboard_providers.dart';
import '../expenses/expense_providers.dart';
import '../fillups/fillup_providers.dart';
import '../vehicles/widgets/empty_vehicle_prompt.dart';
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
            return const EmptyVehiclePrompt();
          }
          final months = ref.watch(monthlySpendProvider(vehicle.id));
          final comparison = ref.watch(vehicleComparisonProvider(vehicle.id));
          final fills = ref.watch(fillUpsProvider(vehicle.id));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Confronto reale vs dichiarato',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              comparison.maybeWhen(
                data: (c) => _ComparisonCard(c),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              Text(
                'Spesa mensile',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: months.maybeWhen(
                  data: (m) => m.isEmpty
                      ? const Center(child: Text('Nessun dato'))
                      : _MonthlySpendChart(m),
                  orElse: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Andamento prezzo al litro',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
                  orElse: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
              const SizedBox(height: 24),
              ..._costComposition(context, ref, vehicle.id),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _costComposition(
    BuildContext context,
    WidgetRef ref,
    int vehicleId,
  ) {
    final fillsAsync = ref.watch(fillUpsProvider(vehicleId));
    final expensesAsync = ref.watch(expensesForVehicleProvider(vehicleId));
    final catsAsync = ref.watch(allCategoriesProvider);
    final fills = fillsAsync.asData?.value;
    final expenses = expensesAsync.asData?.value;
    final cats = catsAsync.asData?.value;
    if (fills == null || expenses == null || cats == null) {
      return const [Center(child: CircularProgressIndicator())];
    }
    final service = ref.watch(statsServiceProvider);
    final fuelTotal = fills.fold(0.0, (s, f) => s + f.amount);
    final byCat = service.expenseByCategory(expenses);
    final stacked = service.monthlyStacked(fills, expenses);
    final catColor = {for (final c in cats) c.id: Color(c.color)};
    final catName = {for (final c in cats) c.id: c.name};

    final slices = <(String, double, Color)>[
      if (fuelTotal > 0) ('Carburante', fuelTotal, Colors.teal),
      for (final entry in byCat.entries)
        (
          catName[entry.key] ?? 'Spesa',
          entry.value,
          catColor[entry.key] ?? Colors.grey,
        ),
    ];

    return [
      Text(
        'Composizione costi',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      if (slices.isEmpty)
        const Text('Nessun dato')
      else
        Row(
          children: [
            SizedBox(
              height: 160,
              width: 160,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,
                  sections: [
                    for (final s in slices)
                      PieChartSectionData(
                        value: s.$2,
                        color: s.$3,
                        title: '',
                        radius: 44,
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final s in slices)
                    Row(
                      children: [
                        Container(width: 12, height: 12, color: s.$3),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(s.$1, overflow: TextOverflow.ellipsis),
                        ),
                        Text(fmtEuro(s.$2)),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      const SizedBox(height: 24),
      Text(
        'Costo mensile (carburante vs spese)',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 200,
        child: stacked.isEmpty
            ? const Center(child: Text('Nessun dato'))
            : _StackedChart(stacked),
      ),
    ];
  }
}

class _StackedChart extends StatelessWidget {
  const _StackedChart(this.rows);
  final List<MonthlyStacked> rows;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          for (var i = 0; i < rows.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: rows[i].total,
                  width: 14,
                  rodStackItems: [
                    BarChartRodStackItem(0, rows[i].fuel, Colors.teal),
                    BarChartRodStackItem(
                      rows[i].fuel,
                      rows[i].total,
                      Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
        ],
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= rows.length) return const SizedBox.shrink();
                return Text(rows[i].label, style: const TextStyle(fontSize: 9));
              },
            ),
          ),
        ),
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
                return Text(
                  months[i].label,
                  style: const TextStyle(fontSize: 9),
                );
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
          LineChartBarData(
            spots: spots,
            isCurved: true,
            dotData: const FlDotData(show: false),
          ),
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
