import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/domain/models/category.dart';
import 'package:tanko/src/domain/models/vehicle.dart';
import 'package:tanko/src/domain/models/fill_up.dart';
import 'package:tanko/src/domain/models/enums.dart';

void main() {
  test('Vehicle has default empty specs and round-trips JSON', () {
    final v = Vehicle(
      id: 1,
      make: 'Renault',
      model: 'Clio',
      fuelType: FuelType.hybrid,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
    expect(v.specs.source, SpecSource.manual);
    expect(Vehicle.fromJson(v.toJson()), v);
  });

  test('FillUp allows null liters and round-trips JSON', () {
    final f = FillUp(
      id: 1,
      vehicleId: 1,
      date: DateTime(2026, 1, 1),
      amount: 40,
      odometer: 1000,
      categoryId: 1,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
    expect(f.liters, isNull);
    expect(f.isFull, isTrue);
    expect(FillUp.fromJson(f.toJson()), f);
  });

  test('Category round-trips JSON', () {
    const c = Category(id: 1, name: 'Mine', color: 0xFF4CAF50, isDefault: true);
    expect(Category.fromJson(c.toJson()), c);
  });
}
