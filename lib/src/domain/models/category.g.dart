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
  kind:
      $enumDecodeNullable(_$CategoryKindEnumMap, json['kind']) ??
      CategoryKind.fuel,
  iconCode: (json['iconCode'] as num?)?.toInt(),
  ord: (json['ord'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
  'isDefault': instance.isDefault,
  'kind': _$CategoryKindEnumMap[instance.kind]!,
  'iconCode': instance.iconCode,
  'ord': instance.ord,
};

const _$CategoryKindEnumMap = {
  CategoryKind.fuel: 'fuel',
  CategoryKind.expense: 'expense',
};
