import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/domain/models/vehicle.dart';
import 'package:tanko/src/domain/models/vehicle_stats.dart';
import 'package:tanko/src/domain/services/range_comparator.dart';

void main() {
  const comparator = RangeComparator();

  test('computes consumption and range deltas vs declared specs', () {
    const stats = VehicleStats(avgConsumption: 5.0);
    const specs = VehicleSpecs(
      tankCapacityL: 40,
      mfrConsumption: 4.0,
      mfrRangeKm: 900,
    );

    final c = comparator.compare(stats, specs);

    expect(c.hasConsumption, isTrue);
    expect(c.consumptionDeltaPct, closeTo(25.0, 1e-9)); // 5 vs 4 -> +25%
    expect(c.realRangeKm, closeTo(800.0, 1e-9)); // 40 * 100 / 5
    expect(c.rangeDeltaPct, closeTo((800 - 900) / 900 * 100, 1e-9));
  });

  test('null specs yield no comparison', () {
    const stats = VehicleStats(avgConsumption: 5.0);
    const specs = VehicleSpecs();
    final c = comparator.compare(stats, specs);
    expect(c.hasConsumption, isFalse);
    expect(c.consumptionDeltaPct, isNull);
    expect(c.realRangeKm, isNull);
  });
}
