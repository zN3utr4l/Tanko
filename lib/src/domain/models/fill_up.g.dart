// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fill_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FillUp _$FillUpFromJson(Map<String, dynamic> json) => _FillUp(
  id: (json['id'] as num).toInt(),
  vehicleId: (json['vehicleId'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  amount: (json['amount'] as num).toDouble(),
  liters: (json['liters'] as num?)?.toDouble(),
  odometer: (json['odometer'] as num).toDouble(),
  isFull: json['isFull'] as bool? ?? true,
  rangeKm: (json['rangeKm'] as num?)?.toDouble(),
  station: json['station'] as String?,
  categoryId: (json['categoryId'] as num).toInt(),
  note: json['note'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  receiptPhotoPath: json['receiptPhotoPath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FillUpToJson(_FillUp instance) => <String, dynamic>{
  'id': instance.id,
  'vehicleId': instance.vehicleId,
  'date': instance.date.toIso8601String(),
  'amount': instance.amount,
  'liters': instance.liters,
  'odometer': instance.odometer,
  'isFull': instance.isFull,
  'rangeKm': instance.rangeKm,
  'station': instance.station,
  'categoryId': instance.categoryId,
  'note': instance.note,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'receiptPhotoPath': instance.receiptPhotoPath,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
