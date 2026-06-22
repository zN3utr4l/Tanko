import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_stats.freezed.dart';

@freezed
abstract class VehicleStats with _$VehicleStats {
  const factory VehicleStats({
    @Default(0) double totalSpend,
    double? avgPricePerLiter,
    double? avgConsumption,
    @Default(0) double totalKm,
    DateTime? lastFillDate,
    @Default(<int, double>{}) Map<int, double> spendByCategory,
    @Default(0) int fillUpCount,
  }) = _VehicleStats;
}
