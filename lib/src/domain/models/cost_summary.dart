import 'package:freezed_annotation/freezed_annotation.dart';

part 'cost_summary.freezed.dart';

@freezed
abstract class CostSummary with _$CostSummary {
  const factory CostSummary({
    @Default(0) double fuelCost,
    @Default(0) double expenseCost,
    @Default(0) double totalKm,
    @Default(0) int months,
  }) = _CostSummary;

  const CostSummary._();

  double get totalCost => fuelCost + expenseCost;
  double? get costPerKm => totalKm > 0 ? totalCost / totalKm : null;
  double? get costPerMonth => months > 0 ? totalCost / months : null;
}
