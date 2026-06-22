// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleSpecs _$VehicleSpecsFromJson(Map<String, dynamic> json) =>
    _VehicleSpecs(
      tankCapacityL: (json['tankCapacityL'] as num?)?.toDouble(),
      mfrConsumption: (json['mfrConsumption'] as num?)?.toDouble(),
      mfrRangeKm: (json['mfrRangeKm'] as num?)?.toDouble(),
      powerPs: (json['powerPs'] as num?)?.toInt(),
      source:
          $enumDecodeNullable(_$SpecSourceEnumMap, json['source']) ??
          SpecSource.manual,
      catalogRef: json['catalogRef'] as String?,
    );

Map<String, dynamic> _$VehicleSpecsToJson(_VehicleSpecs instance) =>
    <String, dynamic>{
      'tankCapacityL': instance.tankCapacityL,
      'mfrConsumption': instance.mfrConsumption,
      'mfrRangeKm': instance.mfrRangeKm,
      'powerPs': instance.powerPs,
      'source': _$SpecSourceEnumMap[instance.source]!,
      'catalogRef': instance.catalogRef,
    };

const _$SpecSourceEnumMap = {
  SpecSource.carquery: 'carquery',
  SpecSource.manual: 'manual',
};

_Vehicle _$VehicleFromJson(Map<String, dynamic> json) => _Vehicle(
  id: (json['id'] as num).toInt(),
  make: json['make'] as String,
  model: json['model'] as String,
  year: (json['year'] as num?)?.toInt(),
  trim: json['trim'] as String?,
  fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
  plate: json['plate'] as String?,
  colorTag: (json['colorTag'] as num?)?.toInt() ?? 0,
  isDefault: json['isDefault'] as bool? ?? false,
  specs: json['specs'] == null
      ? const VehicleSpecs()
      : VehicleSpecs.fromJson(json['specs'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$VehicleToJson(_Vehicle instance) => <String, dynamic>{
  'id': instance.id,
  'make': instance.make,
  'model': instance.model,
  'year': instance.year,
  'trim': instance.trim,
  'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
  'plate': instance.plate,
  'colorTag': instance.colorTag,
  'isDefault': instance.isDefault,
  'specs': instance.specs.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$FuelTypeEnumMap = {
  FuelType.petrol: 'petrol',
  FuelType.diesel: 'diesel',
  FuelType.lpg: 'lpg',
  FuelType.cng: 'cng',
  FuelType.hybrid: 'hybrid',
  FuelType.electric: 'electric',
};
