import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

@freezed
abstract class VehicleSpecs with _$VehicleSpecs {
  const factory VehicleSpecs({
    double? tankCapacityL,
    double? mfrConsumption,
    double? mfrRangeKm,
    int? powerPs,
    @Default(SpecSource.manual) SpecSource source,
    String? catalogRef,
  }) = _VehicleSpecs;

  factory VehicleSpecs.fromJson(Map<String, Object?> json) =>
      _$VehicleSpecsFromJson(json);
}

@freezed
abstract class Vehicle with _$Vehicle {
  const factory Vehicle({
    required int id,
    required String make,
    required String model,
    int? year,
    String? trim,
    required FuelType fuelType,
    String? plate,
    @Default(0) int colorTag,
    @Default(false) bool isDefault,
    @Default(VehicleSpecs()) VehicleSpecs specs,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, Object?> json) =>
      _$VehicleFromJson(json);
}
