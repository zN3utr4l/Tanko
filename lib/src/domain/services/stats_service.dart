import '../models/cost_summary.dart';
import '../models/expense.dart';
import '../models/fill_up.dart';
import '../models/monthly_stacked.dart';
import '../models/monthly_total.dart';
import '../models/vehicle_stats.dart';
import 'consumption_calculator.dart';

class StatsService {
  const StatsService([this._calc = const ConsumptionCalculator()]);

  final ConsumptionCalculator _calc;

  VehicleStats compute(List<FillUp> fills) {
    if (fills.isEmpty) return const VehicleStats();

    final sorted = [...fills]..sort((a, b) => a.odometer.compareTo(b.odometer));

    var totalSpend = 0.0;
    var litersWithPrice = 0.0;
    var costWithPrice = 0.0;
    final byCategory = <int, double>{};
    DateTime? lastDate;

    for (final f in sorted) {
      totalSpend += f.amount;
      byCategory.update(
        f.categoryId,
        (v) => v + f.amount,
        ifAbsent: () => f.amount,
      );
      if (f.liters != null) {
        litersWithPrice += f.liters!;
        costWithPrice += f.amount;
      }
      if (lastDate == null || f.date.isAfter(lastDate)) lastDate = f.date;
    }

    final intervals = _calc.intervals(sorted);
    double? avgConsumption;
    if (intervals.isNotEmpty) {
      final liters = intervals.fold(0.0, (s, i) => s + i.liters);
      final distance = intervals.fold(0.0, (s, i) => s + i.distanceKm);
      avgConsumption = liters / distance * 100;
    }

    return VehicleStats(
      totalSpend: totalSpend,
      avgPricePerLiter: litersWithPrice > 0
          ? costWithPrice / litersWithPrice
          : null,
      avgConsumption: avgConsumption,
      totalKm: sorted.last.odometer - sorted.first.odometer,
      lastFillDate: lastDate,
      spendByCategory: byCategory,
      fillUpCount: fills.length,
    );
  }

  /// Spend grouped by calendar month, sorted chronologically.
  List<MonthlyTotal> monthlySpend(List<FillUp> fills) {
    final byKey = <String, MonthlyTotal>{};
    for (final f in fills) {
      final key = '${f.date.year}-${f.date.month}';
      final current = byKey[key];
      byKey[key] = MonthlyTotal(
        year: f.date.year,
        month: f.date.month,
        total: (current?.total ?? 0) + f.amount,
      );
    }
    final list = byKey.values.toList()
      ..sort((a, b) => a.year != b.year ? a.year - b.year : a.month - b.month);
    return list;
  }

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
    final entries =
        count.keys
            .map((st) => (station: st, count: count[st]!, total: total[st]!))
            .toList()
          ..sort(
            (a, b) => b.count != a.count
                ? b.count - a.count
                : b.total.compareTo(a.total),
          );
    return entries.take(limit).toList();
  }

  /// Cost of ownership over fuel + general expenses.
  CostSummary costSummary(List<FillUp> fills, List<Expense> expenses) {
    final fuelCost = fills.fold(0.0, (s, f) => s + f.amount);
    final expenseCost = expenses.fold(0.0, (s, e) => s + e.amount);
    var totalKm = 0.0;
    if (fills.length >= 2) {
      final od = fills.map((f) => f.odometer).toList()..sort();
      totalKm = od.last - od.first;
    }
    final months = <String>{
      for (final f in fills) '${f.date.year}-${f.date.month}',
      for (final e in expenses) '${e.date.year}-${e.date.month}',
    };
    return CostSummary(
      fuelCost: fuelCost,
      expenseCost: expenseCost,
      totalKm: totalKm,
      months: months.length,
    );
  }

  /// Total expense amount per expense-category id (for the donut chart).
  Map<int, double> expenseByCategory(List<Expense> expenses) {
    final m = <int, double>{};
    for (final e in expenses) {
      m.update(e.categoryId, (v) => v + e.amount, ifAbsent: () => e.amount);
    }
    return m;
  }

  /// Per-month fuel vs expense totals, sorted chronologically.
  List<MonthlyStacked> monthlyStacked(
    List<FillUp> fills,
    List<Expense> expenses,
  ) {
    final map = <String, MonthlyStacked>{};
    void add(int year, int month, {double fuel = 0, double expense = 0}) {
      final key = '$year-$month';
      final c = map[key];
      map[key] = MonthlyStacked(
        year: year,
        month: month,
        fuel: (c?.fuel ?? 0) + fuel,
        expense: (c?.expense ?? 0) + expense,
      );
    }

    for (final f in fills) {
      add(f.date.year, f.date.month, fuel: f.amount);
    }
    for (final e in expenses) {
      add(e.date.year, e.date.month, expense: e.amount);
    }
    return map.values.toList()
      ..sort((a, b) => a.year != b.year ? a.year - b.year : a.month - b.month);
  }
}
