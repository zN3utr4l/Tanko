import '../models/fill_up.dart';
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
      byCategory.update(f.categoryId, (v) => v + f.amount, ifAbsent: () => f.amount);
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
      avgPricePerLiter: litersWithPrice > 0 ? costWithPrice / litersWithPrice : null,
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
      ..sort((a, b) =>
          a.year != b.year ? a.year - b.year : a.month - b.month);
    return list;
  }
}
