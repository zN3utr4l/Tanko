import '../models/fill_up.dart';
import '../models/consumption_interval.dart';

/// Computes fuel consumption between consecutive *full* tanks.
/// Partial fills accumulate into the next full-to-full interval.
class ConsumptionCalculator {
  const ConsumptionCalculator();

  List<ConsumptionInterval> intervals(List<FillUp> fills) {
    final sorted = [...fills]..sort((a, b) => a.odometer.compareTo(b.odometer));
    final result = <ConsumptionInterval>[];

    FillUp? lastFull;
    var liters = 0.0;
    var cost = 0.0;
    var hasNullLiters = false;

    for (final f in sorted) {
      if (lastFull != null) {
        if (f.liters == null) {
          hasNullLiters = true;
        } else {
          liters += f.liters!;
        }
        cost += f.amount;
      }
      if (f.isFull) {
        final isValid =
            lastFull != null &&
            f.odometer > lastFull.odometer &&
            !hasNullLiters &&
            liters > 0;
        if (isValid) {
          result.add(
            ConsumptionInterval(
              fromFillUpId: lastFull.id,
              toFillUpId: f.id,
              distanceKm: f.odometer - lastFull.odometer,
              liters: liters,
              cost: cost,
            ),
          );
        }
        lastFull = f;
        liters = 0.0;
        cost = 0.0;
        hasNullLiters = false;
      }
    }
    return result;
  }
}
