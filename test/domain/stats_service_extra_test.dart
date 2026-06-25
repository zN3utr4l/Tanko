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
}
