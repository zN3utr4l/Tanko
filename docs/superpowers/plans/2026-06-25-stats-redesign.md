# Statistiche Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the Statistiche page readable and add charts/insights that work from the imported data (date, amount, odometer) without liters.

**Architecture:** Pure aggregation logic lives in `StatsService` (domain, unit-tested with records as return types). The screen composes sections; chart-axis readability logic is extracted into a small reusable helper. "Mie/non mie" reuses the existing fuel categories (`Mine`/`Not mine`) — no schema change.

**Tech Stack:** Flutter, fl_chart, Riverpod, Drift, intl (it_IT formatters in `core/formatters.dart`).

## Global Constraints

- Flutter 3.44 / Dart `^3.12`. No new dependencies.
- Domain stays pure (no I/O); heavy logic is unit-tested. Generated `*.g.dart`/`*.freezed.dart` are never hand-edited.
- Italian UI, English code/comments.
- `flutter analyze` (whole project) and `flutter test` must be green before push.
- `lib/` changes → bump `pubspec.yaml` from `0.5.9+15` to `0.6.0+16`.
- `build-apk` (release) is a required check; commit identity is zN3utr4l.
- Schema stays at **v3** (no migration in this work).

---

### Task 1: `StatsService.costPerKm` + `yearlySpend`

**Files:**
- Modify: `lib/src/domain/services/stats_service.dart`
- Test: `test/domain/stats_service_extra_test.dart` (create)

**Interfaces:**
- Produces: `double? costPerKm(List<FillUp> fills)`, `List<({int year, double total})> yearlySpend(List<FillUp> fills)`

- [ ] **Step 1: Write the failing test**

Create `test/domain/stats_service_extra_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/services/stats_service.dart';

FillUp _f({
  required double amount,
  required double odometer,
  DateTime? date,
  double? liters,
  int categoryId = 1,
  String? station,
}) => FillUp(
  id: 0,
  vehicleId: 1,
  date: date ?? DateTime(2024, 1, 1),
  amount: amount,
  liters: liters,
  odometer: odometer,
  categoryId: categoryId,
  station: station,
  createdAt: DateTime(2024),
  updatedAt: DateTime(2024),
);

void main() {
  const s = StatsService();

  test('costPerKm = total spend / km span; null when < 2 fills', () {
    expect(s.costPerKm([_f(amount: 50, odometer: 1000)]), isNull);
    final r = s.costPerKm([
      _f(amount: 40, odometer: 1000),
      _f(amount: 60, odometer: 1500),
    ]);
    expect(r, closeTo(100 / 500, 1e-9));
  });

  test('yearlySpend totals per year, sorted ascending', () {
    final r = s.yearlySpend([
      _f(amount: 10, odometer: 100, date: DateTime(2023, 5, 1)),
      _f(amount: 20, odometer: 200, date: DateTime(2024, 1, 1)),
      _f(amount: 5, odometer: 300, date: DateTime(2023, 8, 1)),
    ]);
    expect(r, [(year: 2023, total: 15.0), (year: 2024, total: 20.0)]);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/domain/stats_service_extra_test.dart`
Expected: FAIL — `costPerKm`/`yearlySpend` not defined.

- [ ] **Step 3: Add the methods to `StatsService`** (after `monthlySpend`)

```dart
  /// Cost per km over the odometer span. Null when fewer than 2 fills or no
  /// distance. Needs no liters.
  double? costPerKm(List<FillUp> fills) {
    final stats = compute(fills);
    return stats.totalKm > 0 ? stats.totalSpend / stats.totalKm : null;
  }

  /// Total fuel spend per calendar year, sorted ascending.
  List<({int year, double total})> yearlySpend(List<FillUp> fills) {
    final byYear = <int, double>{};
    for (final f in fills) {
      byYear.update(f.date.year, (v) => v + f.amount, ifAbsent: () => f.amount);
    }
    final years = byYear.keys.toList()..sort();
    return [for (final y in years) (year: y, total: byYear[y]!)];
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/domain/stats_service_extra_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/src/domain/services/stats_service.dart test/domain/stats_service_extra_test.dart
git commit -m "feat(stats): costPerKm and yearlySpend aggregations"
```

---

### Task 2: `StatsService.kmPerFill`

**Files:**
- Modify: `lib/src/domain/services/stats_service.dart`
- Test: `test/domain/stats_service_extra_test.dart`

**Interfaces:**
- Produces: `List<({FillUp from, FillUp to, double km})> kmPerFill(List<FillUp> fills)` — consecutive odometer deltas, sorted by odometer, skipping deltas ≤ 0.

- [ ] **Step 1: Write the failing test** (append to the file from Task 1)

```dart
  test('kmPerFill returns consecutive odometer deltas, skips non-positive', () {
    final a = _f(amount: 1, odometer: 1000);
    final b = _f(amount: 1, odometer: 1450);
    final c = _f(amount: 1, odometer: 1450); // zero delta -> skipped
    final d = _f(amount: 1, odometer: 2000);
    final r = s.kmPerFill([d, b, a, c]); // unsorted input
    expect(r.map((e) => e.km).toList(), [450.0, 550.0]);
    expect(r.first.to.odometer, 1450);
  });

  test('kmPerFill is empty with fewer than 2 fills', () {
    expect(s.kmPerFill([_f(amount: 1, odometer: 10)]), isEmpty);
    expect(s.kmPerFill(const []), isEmpty);
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/domain/stats_service_extra_test.dart`
Expected: FAIL — `kmPerFill` not defined.

- [ ] **Step 3: Add the method to `StatsService`**

```dart
  /// Distance driven between consecutive fill-ups (odometer deltas), ordered by
  /// odometer. Skips non-positive deltas (duplicate/rolled-back odometer).
  List<({FillUp from, FillUp to, double km})> kmPerFill(List<FillUp> fills) {
    if (fills.length < 2) return const [];
    final sorted = [...fills]..sort((a, b) => a.odometer.compareTo(b.odometer));
    final out = <({FillUp from, FillUp to, double km})>[];
    for (var i = 1; i < sorted.length; i++) {
      final km = sorted[i].odometer - sorted[i - 1].odometer;
      if (km > 0) out.add((from: sorted[i - 1], to: sorted[i], km: km));
    }
    return out;
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/domain/stats_service_extra_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/src/domain/services/stats_service.dart test/domain/stats_service_extra_test.dart
git commit -m "feat(stats): kmPerFill odometer-delta intervals"
```

---

### Task 3: `StatsService.fuelByCategory` + `topStations`

**Files:**
- Modify: `lib/src/domain/services/stats_service.dart`
- Test: `test/domain/stats_service_extra_test.dart`

**Interfaces:**
- Produces: `Map<int, double> fuelByCategory(List<FillUp> fills)`; `List<({String station, int count, double total})> topStations(List<FillUp> fills, {int limit})`

- [ ] **Step 1: Write the failing test** (append)

```dart
  test('fuelByCategory sums amount per categoryId', () {
    final r = s.fuelByCategory([
      _f(amount: 10, odometer: 1, categoryId: 1),
      _f(amount: 5, odometer: 2, categoryId: 1),
      _f(amount: 7, odometer: 3, categoryId: 2),
    ]);
    expect(r, {1: 15.0, 2: 7.0});
  });

  test('topStations ranks by count, ignores null stations, respects limit', () {
    final r = s.topStations([
      _f(amount: 1, odometer: 1, station: 'Esso'),
      _f(amount: 2, odometer: 2, station: 'Esso'),
      _f(amount: 3, odometer: 3, station: 'Q8'),
      _f(amount: 4, odometer: 4, station: null),
    ], limit: 1);
    expect(r, [(station: 'Esso', count: 2, total: 3.0)]);
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/domain/stats_service_extra_test.dart`
Expected: FAIL — methods not defined.

- [ ] **Step 3: Add the methods to `StatsService`**

```dart
  /// Total fuel amount per fuel-category id (mirror of expenseByCategory).
  Map<int, double> fuelByCategory(List<FillUp> fills) {
    final m = <int, double>{};
    for (final f in fills) {
      m.update(f.categoryId, (v) => v + f.amount, ifAbsent: () => f.amount);
    }
    return m;
  }

  /// Most-used stations by fill-up count (then total spent), ignoring fills
  /// without a station.
  List<({String station, int count, double total})> topStations(
    List<FillUp> fills, {
    int limit = 5,
  }) {
    final count = <String, int>{};
    final total = <String, double>{};
    for (final f in fills) {
      final st = f.station;
      if (st == null || st.trim().isEmpty) continue;
      count.update(st, (v) => v + 1, ifAbsent: () => 1);
      total.update(st, (v) => v + f.amount, ifAbsent: () => f.amount);
    }
    final entries = count.keys
        .map((st) => (station: st, count: count[st]!, total: total[st]!))
        .toList()
      ..sort((a, b) => b.count != a.count
          ? b.count - a.count
          : b.total.compareTo(a.total));
    return entries.take(limit).toList();
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/domain/stats_service_extra_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/src/domain/services/stats_service.dart test/domain/stats_service_extra_test.dart
git commit -m "feat(stats): fuelByCategory and topStations aggregations"
```

---

### Task 4: Chart-axis readability helper

**Files:**
- Create: `lib/src/features/stats/widgets/chart_axis.dart`
- Test: `test/features/chart_axis_test.dart` (create)

**Interfaces:**
- Produces: `Set<int> labelIndices(int count, {int maxLabels})`; `FlTitlesData barTitles({required List<String> labels, required double maxY})`; `BarTouchData currencyBarTouch()`.

- [ ] **Step 1: Write the failing test**

Create `test/features/chart_axis_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/features/stats/widgets/chart_axis.dart';

void main() {
  test('labelIndices shows all when count <= maxLabels', () {
    expect(labelIndices(4, maxLabels: 6), {0, 1, 2, 3});
  });

  test('labelIndices thins evenly when count > maxLabels', () {
    final r = labelIndices(36, maxLabels: 6);
    expect(r.length, lessThanOrEqualTo(6));
    expect(r, contains(0));
    // evenly spaced: step = (36/6).ceil() = 6 -> 0,6,12,18,24,30
    expect(r, containsAll(<int>{0, 6, 12, 18, 24, 30}));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/chart_axis_test.dart`
Expected: FAIL — file/function missing.

- [ ] **Step 3: Create the helper**

```dart
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/chart_axis_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/src/features/stats/widgets/chart_axis.dart test/features/chart_axis_test.dart
git commit -m "feat(stats): reusable chart axis helper (thinned labels, value axis, tooltip)"
```

---

### Task 5: Apply readability to the existing charts

**Files:**
- Modify: `lib/src/features/stats/stats_screen.dart` (the `_MonthlySpendChart`, `_StackedChart`, `_PriceTrendChart` classes)

**Interfaces:**
- Consumes: `barTitles`, `currencyBarTouch`, `labelIndices` from `widgets/chart_axis.dart`.

- [ ] **Step 1: Import the helper** at the top of `stats_screen.dart`

```dart
import 'widgets/chart_axis.dart';
```

- [ ] **Step 2: Replace `_MonthlySpendChart.build` body**

```dart
  @override
  Widget build(BuildContext context) {
    final labels = [for (final m in months) m.label];
    final maxY = months.fold(0.0, (mx, m) => m.total > mx ? m.total : mx);
    return BarChart(
      BarChartData(
        maxY: maxY == 0 ? 1 : maxY * 1.15,
        barGroups: [
          for (var i = 0; i < months.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: months[i].total,
                  width: months.length > 24 ? 5 : 10,
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
    );
  }
```

- [ ] **Step 3: Replace `_StackedChart.build`'s `titlesData` and add tooltip + width**

In `_StackedChart.build`, build `final labels = [for (final r in rows) r.label];`, set each `BarChartRodData(... width: rows.length > 24 ? 5 : 10)`, add `barTouchData: currencyBarTouch(labels),` and replace the whole `titlesData:` with `titlesData: barTitles(labels: labels, maxY: rows.fold(0.0, (mx, r) => r.total > mx ? r.total : mx)),`.

- [ ] **Step 4: Improve `_PriceTrendChart`** — add left value axis + thinned bottom index labels

Replace its `titlesData` with:

```dart
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: const AxisTitles(),
        ),
        lineTouchData: const LineTouchData(),
```

- [ ] **Step 5: Verify build + analyze**

Run: `flutter analyze lib/src/features/stats/stats_screen.dart`
Expected: No issues found.

- [ ] **Step 6: Commit**

```bash
git add lib/src/features/stats/stats_screen.dart
git commit -m "fix(stats): readable axes, thinned labels and tap tooltips on existing charts"
```

---

### Task 6: Summary card (€/km, km totali) + clearer "insufficienti" message

**Files:**
- Modify: `lib/src/features/stats/stats_screen.dart` (`_InsightsCard`, `_ComparisonCard`)

**Interfaces:**
- Consumes: `StatsService.costPerKm`, `VehicleStats.totalKm`, `fmtKm`, `fmtEuro`.

- [ ] **Step 1: Extend `_InsightsCard`** to show €/km and km totali

Replace the `children:` of the `Wrap` in `_InsightsCard.build` with (compute `final service = const StatsService();` at top of build, plus):

```dart
    final stats = const StatsService().compute(fills);
    final costPerKm = const StatsService().costPerKm(fills);
    // ...
          children: [
            _Metric(label: 'Totale', value: fmtEuro(total)),
            _Metric(label: 'Rifornimenti', value: fills.length.toString()),
            _Metric(label: 'Km totali', value: fmtKm(stats.totalKm)),
            _Metric(
              label: '€/km',
              value: costPerKm == null ? '—' : fmtEuro(costPerKm),
            ),
            _Metric(
              label: 'Prezzo medio',
              value: price == null ? '—' : '${fmtEuro(price)}/L',
            ),
          ],
```

(Keep `StatsService` imported: add `import '../../domain/services/stats_service.dart';` if not present.)

- [ ] **Step 2: Make the comparison empty-state explicit about liters**

In `_ComparisonCard.build`, replace the fallback Text with:

```dart
          child: Text(
            'Servono i litri per rifornimento per calcolare consumo e '
            'autonomia reali. Aggiungili sui nuovi rifornimenti.',
          ),
```

- [ ] **Step 3: Analyze**

Run: `flutter analyze lib/src/features/stats/stats_screen.dart`
Expected: No issues found.

- [ ] **Step 4: Commit**

```bash
git add lib/src/features/stats/stats_screen.dart
git commit -m "feat(stats): €/km + km totali in summary; clearer liters message"
```

---

### Task 7: "Km per pieno" section

**Files:**
- Create: `lib/src/features/stats/widgets/km_per_fill_section.dart`
- Modify: `lib/src/features/stats/stats_screen.dart` (insert the section)

**Interfaces:**
- Consumes: `StatsService.kmPerFill`.
- Produces: `class KmPerFillSection extends StatelessWidget { const KmPerFillSection(this.fills); final List<FillUp> fills; }`

- [ ] **Step 1: Create the widget**

```dart
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
            _row(context, Icons.south, Colors.green,
                'Meno km', min.km, min.to.date),
            const SizedBox(height: 8),
            _row(context, Icons.north, Colors.red,
                'Più km', max.km, max.to.date),
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
```

- [ ] **Step 2: Insert into the screen** after the "Spesa mensile" section block in `stats_screen.dart`'s `ListView` children (and import it):

```dart
import 'widgets/km_per_fill_section.dart';
// ...
              const SizedBox(height: 24),
              Text('Km per pieno',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              fills.maybeWhen(
                data: (list) =>
                    KmPerFillSection(_filterByDate(list, (f) => f.date)),
                orElse: () => const SizedBox.shrink(),
              ),
```

- [ ] **Step 3: Analyze**

Run: `flutter analyze lib/src/features/stats/`
Expected: No issues found.

- [ ] **Step 4: Commit**

```bash
git add lib/src/features/stats/widgets/km_per_fill_section.dart lib/src/features/stats/stats_screen.dart
git commit -m "feat(stats): Km per pieno section (fewest/most/avg km between fills)"
```

---

### Task 8: "Spese mie/non mie", "Top distributori", "Spesa per anno" sections

**Files:**
- Create: `lib/src/features/stats/widgets/extra_sections.dart`
- Modify: `lib/src/features/stats/stats_screen.dart`

**Interfaces:**
- Consumes: `StatsService.fuelByCategory`, `StatsService.topStations`, `StatsService.yearlySpend`; category names map.
- Produces: `MieNonMieDonut(fills, catName, catColor)`, `TopStationsList(fills)`, `YearlySpendChart(fills)`.

- [ ] **Step 1: Create the widgets**

```dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/formatters.dart';
import '../../../domain/models/fill_up.dart';
import '../../../domain/services/stats_service.dart';
import 'chart_axis.dart';

/// Fuel grouped by fuel-category (the seeded `Mine`/`Not mine`).
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
                        color: Color(catColor[e.key] ?? 0xFF9E9E9E)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(catName[e.key] ?? 'Categoria',
                          overflow: TextOverflow.ellipsis),
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
                  BarChartRodData(toY: rows[i].total, width: 22, color: Colors.teal),
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
```

- [ ] **Step 2: Insert the three sections** into `stats_screen.dart` (import `widgets/extra_sections.dart`) — place "Spese mie/non mie" and "Top distributori" after "Composizione costi", "Spesa per anno" before the stacked chart. Use the already-available `cats`/`fills` from build. Example for the donut:

```dart
              const SizedBox(height: 24),
              Text('Spese mie / non mie',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (!(fills.isLoading || cats.isLoading))
                MieNonMieDonut(
                  _filterByDate(fills.asData?.value ?? const [], (f) => f.date),
                  {for (final c in cats.asData?.value ?? const []) c.id: c.name},
                  {for (final c in cats.asData?.value ?? const []) c.id: c.color},
                ),
              const SizedBox(height: 24),
              Text('Top distributori',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TopStationsList(
                  _filterByDate(fills.asData?.value ?? const [], (f) => f.date)),
              const SizedBox(height: 24),
              Text('Spesa per anno',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              YearlySpendChart(
                  _filterByDate(fills.asData?.value ?? const [], (f) => f.date)),
```

- [ ] **Step 3: Analyze**

Run: `flutter analyze lib/src/features/stats/`
Expected: No issues found.

- [ ] **Step 4: Commit**

```bash
git add lib/src/features/stats/widgets/extra_sections.dart lib/src/features/stats/stats_screen.dart
git commit -m "feat(stats): mie/non-mie donut, top stations, yearly spend sections"
```

---

### Task 9: Widget test, version bump, final verification

**Files:**
- Test: `test/features/stats_screen_test.dart` (create)
- Modify: `pubspec.yaml`

- [ ] **Step 1: Write a widget test** for empty/insufficient states

Create `test/features/stats_screen_test.dart` (mirror the override pattern used in existing widget tests; override `appDatabaseProvider` with `makeTestDb()` and a seeded default vehicle). Minimal assertion:

```dart
// Pump StatsScreen with a vehicle that has 1 fill (no liters):
//  - 'Servono i litri' message is shown (comparison)
//  - 'Km per pieno' shows the "almeno due rifornimenti" empty state
//  - 'Top distributori' shows the "Nessuna stazione registrata" empty state
```

Follow `test/features/vehicles_test.dart` for the harness (ProviderScope overrides + pumpWidget + `tester.pumpAndSettle()`), asserting `find.textContaining('Servono i litri')` etc.

- [ ] **Step 2: Run it**

Run: `flutter test test/features/stats_screen_test.dart`
Expected: PASS.

- [ ] **Step 3: Bump version**

In `pubspec.yaml`: `version: 0.5.9+15` → `version: 0.6.0+16`.

- [ ] **Step 4: Full verification**

Run: `flutter analyze` (expect "No issues found!") then `flutter test` (expect all pass).

- [ ] **Step 5: Commit**

```bash
git add test/features/stats_screen_test.dart pubspec.yaml
git commit -m "test(stats): screen empty-states; bump to 0.6.0+16"
```

---

## Self-Review

- **Spec coverage:** readability approach → Task 4-5; €/km + km totali → Task 6; km-per-fill insights → Task 2+7; price/litri message → Task 6; donut mie/non-mie via existing categories → Task 3+8; top stations → Task 3+8; yearly spend → Task 1+8; clearer empty states → Task 6-8; no schema change → respected (schema stays v3). All covered.
- **Placeholders:** none — code provided for every code step except Task 9 step 1 which references the existing widget-test harness pattern (intentional: reuse `vehicles_test.dart` rather than duplicate DB-seeding boilerplate here).
- **Type consistency:** `kmPerFill` returns `({FillUp from, FillUp to, double km})` used consistently in Task 2 + 7; `topStations` returns `({String station, int count, double total})` used in Task 3 + 8; `yearlySpend` returns `({int year, double total})` used in Task 1 + 8; `barTitles`/`currencyBarTouch`/`labelIndices` signatures consistent across Task 4/5/8.
