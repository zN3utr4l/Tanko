import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/domain/models/fill_up.dart';
import 'package:tanko/src/domain/services/stats_service.dart';

FillUp fill({
  required int id,
  required double odometer,
  double? liters,
  double amount = 0,
  int categoryId = 1,
  bool isFull = true,
}) =>
    FillUp(
      id: id,
      vehicleId: 1,
      date: DateTime(2026, 1, id),
      amount: amount,
      liters: liters,
      odometer: odometer,
      isFull: isFull,
      categoryId: categoryId,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  const service = StatsService();

  test('empty input -> zeroed stats', () {
    final s = service.compute([]);
    expect(s.totalSpend, 0);
    expect(s.avgPricePerLiter, isNull);
    expect(s.fillUpCount, 0);
  });

  test('aggregates spend, price/L, consumption, km, category split', () {
    final s = service.compute([
      fill(id: 1, odometer: 1000, liters: 30, amount: 60, categoryId: 1),
      fill(id: 2, odometer: 1500, liters: 40, amount: 90, categoryId: 2),
    ]);
    expect(s.totalSpend, 150);
    expect(s.fillUpCount, 2);
    expect(s.totalKm, 500);
    expect(s.avgPricePerLiter, closeTo(150 / 70, 1e-9));
    expect(s.avgConsumption, closeTo(8.0, 1e-9));
    expect(s.spendByCategory[1], 60);
    expect(s.spendByCategory[2], 90);
    expect(s.lastFillDate, DateTime(2026, 1, 2));
  });
}
