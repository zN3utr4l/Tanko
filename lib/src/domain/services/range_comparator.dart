import '../models/comparison.dart';
import '../models/vehicle.dart';
import '../models/vehicle_stats.dart';

/// Compares real measured consumption/range against the manufacturer specs.
class RangeComparator {
  const RangeComparator();

  ConsumptionComparison compare(VehicleStats stats, VehicleSpecs specs) {
    final real = stats.avgConsumption;
    final mfr = specs.mfrConsumption;

    double? consumptionDeltaPct;
    if (real != null && mfr != null && mfr > 0) {
      consumptionDeltaPct = (real - mfr) / mfr * 100;
    }

    // Estimated real range on a full tank, using real consumption.
    double? realRangeKm;
    if (specs.tankCapacityL != null && real != null && real > 0) {
      realRangeKm = specs.tankCapacityL! * 100 / real;
    }
    final mfrRange = specs.mfrRangeKm;

    double? rangeDeltaPct;
    if (realRangeKm != null && mfrRange != null && mfrRange > 0) {
      rangeDeltaPct = (realRangeKm - mfrRange) / mfrRange * 100;
    }

    return ConsumptionComparison(
      realConsumption: real,
      mfrConsumption: mfr,
      consumptionDeltaPct: consumptionDeltaPct,
      realRangeKm: realRangeKm,
      mfrRangeKm: mfrRange,
      rangeDeltaPct: rangeDeltaPct,
    );
  }
}
