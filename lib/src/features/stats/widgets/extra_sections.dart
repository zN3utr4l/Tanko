import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/formatters.dart';
import '../../../domain/models/fill_up.dart';
import '../../../domain/services/stats_service.dart';
import 'chart_axis.dart';

/// Fuel grouped by fuel-category (the seeded `Mie`/`Non mie`).
class MieNonMieDonut extends StatelessWidget {
  const MieNonMieDonut(this.fills, this.catName, this.catColor, {super.key});
  final List<FillUp> fills;
  final Map<int, String> catName;
  final Map<int, int> catColor;

  @override
  Widget build(BuildContext context) {
    final byCat = const StatsService().fuelByCategory(fills);
    if (byCat.length < 2) {
      return const Text('Tutti i rifornimenti sono nella stessa categoria.');
    }
    final slices = byCat.entries.toList();
    return Row(
      children: [
        SizedBox(
          height: 160,
          width: 160,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: [
                for (final e in slices)
                  PieChartSectionData(
                    value: e.value,
                    color: Color(catColor[e.key] ?? 0xFF9E9E9E),
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
              for (final e in slices)
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: Color(catColor[e.key] ?? 0xFF9E9E9E),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        catName[e.key] ?? 'Categoria',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(fmtEuro(e.value)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Most-used stations by fill count.
class TopStationsList extends StatelessWidget {
  const TopStationsList(this.fills, {super.key});
  final List<FillUp> fills;

  @override
  Widget build(BuildContext context) {
    final top = const StatsService().topStations(fills);
    if (top.isEmpty) {
      return const Text(
        'Nessuna stazione registrata (i rifornimenti importati non hanno il '
        'distributore; si popola sui nuovi).',
      );
    }
    return Column(
      children: [
        for (final s in top)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.local_gas_station, color: Colors.teal),
            title: Text(s.station),
            subtitle: Text('${s.count} rifornimenti'),
            trailing: Text(fmtEuro(s.total)),
          ),
      ],
    );
  }
}

/// Total fuel spend per year.
class YearlySpendChart extends StatelessWidget {
  const YearlySpendChart(this.fills, {super.key});
  final List<FillUp> fills;

  @override
  Widget build(BuildContext context) {
    final rows = const StatsService().yearlySpend(fills);
    if (rows.length < 2) return const SizedBox.shrink();
    final labels = [for (final r in rows) r.year.toString()];
    final maxY = rows.fold(0.0, (mx, r) => r.total > mx ? r.total : mx);
    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxY * 1.15,
          barGroups: [
            for (var i = 0; i < rows.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: rows[i].total,
                    width: 22,
                    color: Colors.teal,
                  ),
                ],
              ),
          ],
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barTouchData: currencyBarTouch(labels),
          titlesData: barTitles(labels: labels, maxY: maxY),
        ),
      ),
    );
  }
}
