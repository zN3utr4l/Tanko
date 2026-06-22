import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/domain/models/fill_up.dart';
import 'package:tanko/src/domain/services/consumption_calculator.dart';

FillUp fill({
  required int id,
  required double odometer,
  double? liters,
  double amount = 0,
  bool isFull = true,
}) => FillUp(
  id: id,
  vehicleId: 1,
  date: DateTime(2026, 1, id),
  amount: amount,
  liters: liters,
  odometer: odometer,
  isFull: isFull,
  categoryId: 1,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  const calc = ConsumptionCalculator();

  test('two full tanks -> one interval with correct math', () {
    final result = calc.intervals([
      fill(id: 1, odometer: 1000, liters: 30, amount: 60),
      fill(id: 2, odometer: 1500, liters: 40, amount: 80),
    ]);
    expect(result, hasLength(1));
    final i = result.single;
    expect(i.distanceKm, 500);
    expect(i.liters, 40);
    expect(i.cost, 80);
    expect(i.litersPer100Km, closeTo(8.0, 1e-9));
    expect(i.kmPerLiter, closeTo(12.5, 1e-9));
    expect(i.costPer100Km, closeTo(16.0, 1e-9));
  });

  test('partial fill between two fulls accumulates into the interval', () {
    final result = calc.intervals([
      fill(id: 1, odometer: 1000, liters: 30, amount: 60),
      fill(id: 2, odometer: 1200, liters: 10, amount: 20, isFull: false),
      fill(id: 3, odometer: 1500, liters: 30, amount: 60),
    ]);
    expect(result, hasLength(1));
    final i = result.single;
    expect(i.distanceKm, 500);
    expect(i.liters, 40);
    expect(i.cost, 80);
  });

  test('interval containing a null-liters fill is skipped', () {
    final result = calc.intervals([
      fill(id: 1, odometer: 1000, liters: 30),
      fill(id: 2, odometer: 1200, liters: null, isFull: false),
      fill(id: 3, odometer: 1500, liters: 30),
    ]);
    expect(result, isEmpty);
  });

  test('single fill-up produces no interval', () {
    expect(calc.intervals([fill(id: 1, odometer: 1000, liters: 30)]), isEmpty);
  });

  test('unordered input is sorted by odometer', () {
    final result = calc.intervals([
      fill(id: 2, odometer: 1500, liters: 40, amount: 80),
      fill(id: 1, odometer: 1000, liters: 30, amount: 60),
    ]);
    expect(result.single.fromFillUpId, 1);
    expect(result.single.toFillUpId, 2);
  });
}
