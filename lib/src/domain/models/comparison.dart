import 'package:freezed_annotation/freezed_annotation.dart';

part 'comparison.freezed.dart';

/// Real (measured) figures vs the manufacturer-declared specs.
@freezed
abstract class ConsumptionComparison with _$ConsumptionComparison {
  const factory ConsumptionComparison({
    double? realConsumption,
    double? mfrConsumption,
    double? consumptionDeltaPct,
    double? realRangeKm,
    double? mfrRangeKm,
    double? rangeDeltaPct,
  }) = _ConsumptionComparison;

  const ConsumptionComparison._();

  bool get hasConsumption => realConsumption != null && mfrConsumption != null;
  bool get hasRange => realRangeKm != null && mfrRangeKm != null;
}
