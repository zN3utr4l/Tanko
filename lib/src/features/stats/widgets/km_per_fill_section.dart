import 'package:flutter/material.dart';
import '../../../core/formatters.dart';
import '../../../domain/models/fill_up.dart';
import '../../../domain/services/stats_service.dart';

/// "Km per pieno": fewest/most km between two fills and the average — all from
/// odometer deltas, no liters needed.
class KmPerFillSection extends StatelessWidget {
  const KmPerFillSection(this.fills, {super.key});
  final List<FillUp> fills;

  @override
  Widget build(BuildContext context) {
    final intervals = const StatsService().kmPerFill(fills);
    if (intervals.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Servono almeno due rifornimenti per i km percorsi.'),
        ),
      );
    }
    final min = intervals.reduce((a, b) => a.km <= b.km ? a : b);
    final max = intervals.reduce((a, b) => a.km >= b.km ? a : b);
    final avg = intervals.fold(0.0, (s, e) => s + e.km) / intervals.length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row(context, Icons.south, Colors.green, 'Meno km', min.km,
                min.to.date),
            const SizedBox(height: 8),
            _row(context, Icons.north, Colors.red, 'Più km', max.km,
                max.to.date),
            const SizedBox(height: 8),
            Text('Media: ${fmtKm(avg)} tra un pieno e l\'altro'),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, Color color, String label,
      double km, DateTime date) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text('$label: ${fmtKm(km)}')),
        Text(fmtDate(date), style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
