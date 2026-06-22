// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  color: (json['color'] as num).toInt(),
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
  'isDefault': instance.isDefault,
};
