import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/domain/models/expense.dart';
import 'package:tanko/src/domain/models/fill_up.dart';
import 'package:tanko/src/domain/services/stats_service.dart';

FillUp fuel(int month, double amount, double odo) => FillUp(
  id: 0,
  vehicleId: 1,
  date: DateTime(2026, month, 10),
  amount: amount,
  odometer: odo,
  categoryId: 1,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

Expense exp(int month, double amount, int categoryId) => Expense(
  id: 0,
  vehicleId: 1,
  date: DateTime(2026, month, 15),
  categoryId: categoryId,
  amount: amount,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  const s = StatsService();

  test('costSummary combines fuel + expenses with per-km and per-month', () {
    final c = s.costSummary(
      [fuel(1, 50, 1000), fuel(2, 50, 2000)],
      [exp(1, 300, 3), exp(2, 100, 4)],
    );
    expect(c.fuelCost, 100);
    expect(c.expenseCost, 400);
    expect(c.totalCost, 500);
    expect(c.totalKm, 1000);
    expect(c.costPerKm, closeTo(0.5, 1e-9));
    expect(c.months, 2);
    expect(c.costPerMonth, 250);
  });

  test('expenseByCategory sums per category', () {
    final m = s.expenseByCategory([
      exp(1, 300, 3),
      exp(2, 100, 3),
      exp(2, 50, 4),
    ]);
    expect(m[3], 400);
    expect(m[4], 50);
  });

  test('monthlyStacked splits fuel vs expense per month', () {
    final rows = s.monthlyStacked(
      [fuel(1, 50, 1000), fuel(1, 20, 1100)],
      [exp(1, 300, 3), exp(2, 100, 4)],
    );
    expect(rows, hasLength(2));
    expect(rows.first.fuel, 70);
    expect(rows.first.expense, 300);
    expect(rows.first.total, 370);
    expect(rows[1].fuel, 0);
    expect(rows[1].expense, 100);
  });
}
