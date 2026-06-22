import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/domain/models/fill_up.dart';
import 'package:tanko/src/domain/services/stats_service.dart';

FillUp fill(int year, int month, double amount) => FillUp(
  id: 0,
  vehicleId: 1,
  date: DateTime(year, month, 15),
  amount: amount,
  odometer: 0,
  categoryId: 1,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  const service = StatsService();

  test('monthlySpend groups by month and sorts chronologically', () {
    final months = service.monthlySpend([
      fill(2026, 2, 30),
      fill(2026, 1, 20),
      fill(2026, 1, 10),
      fill(2025, 12, 5),
    ]);

    expect(months.map((m) => m.label), ['12/25', '1/26', '2/26']);
    expect(months[1].total, 30); // Jan 2026: 20 + 10
    expect(months[2].total, 30); // Feb 2026
  });
}
