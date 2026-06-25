import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/formatters.dart';

/// Which x-axis indices to label so they don't overlap: all of them when there
/// are few, otherwise an evenly spaced subset of at most [maxLabels].
Set<int> labelIndices(int count, {int maxLabels = 6}) {
  if (count <= 0) return const {};
  if (count <= maxLabels) {
    return {for (var i = 0; i < count; i++) i};
  }
  final step = (count / maxLabels).ceil();
  final out = <int>{};
  for (var i = 0; i < count; i += step) {
    out.add(i);
  }
  return out;
}

/// Bottom (thinned labels from [labels]) + left (currency) axes for bar charts.
FlTitlesData barTitles({required List<String> labels, required double maxY}) {
  final shown = labelIndices(labels.length);
  return FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (value, meta) => value == meta.max
            ? const SizedBox.shrink()
            : Text(_compactEuro(value), style: const TextStyle(fontSize: 9)),
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTitlesWidget: (value, meta) {
          final i = value.toInt();
          if (!shown.contains(i) || i < 0 || i >= labels.length) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(labels[i], style: const TextStyle(fontSize: 9)),
          );
        },
      ),
    ),
  );
}

String _compactEuro(double v) =>
    v >= 1000 ? '${(v / 1000).toStringAsFixed(0)}k' : v.toStringAsFixed(0);

/// Tap tooltip showing the bar's label + exact euro value.
BarTouchData currencyBarTouch(List<String> labels) => BarTouchData(
  touchTooltipData: BarTouchTooltipData(
    getTooltipItem: (group, groupIndex, rod, rodIndex) {
      final label = group.x >= 0 && group.x < labels.length
          ? labels[group.x]
          : '';
      return BarTooltipItem(
        '$label\n${fmtEuro(rod.toY)}',
        const TextStyle(color: Colors.white, fontSize: 11),
      );
    },
  ),
);
