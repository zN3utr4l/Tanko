// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reminder _$ReminderFromJson(Map<String, dynamic> json) => _Reminder(
  id: (json['id'] as num).toInt(),
  vehicleId: (json['vehicleId'] as num).toInt(),
  type: $enumDecode(_$ReminderTypeEnumMap, json['type']),
  title: json['title'] as String,
  triggerMode: $enumDecode(_$TriggerModeEnumMap, json['triggerMode']),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  dueOdometer: (json['dueOdometer'] as num?)?.toDouble(),
  recurEvery: (json['recurEvery'] as num?)?.toInt(),
  recurUnit: $enumDecodeNullable(_$RecurUnitEnumMap, json['recurUnit']),
  recurKmEvery: (json['recurKmEvery'] as num?)?.toInt(),
  leadDays: (json['leadDays'] as num?)?.toInt(),
  leadKm: (json['leadKm'] as num?)?.toInt(),
  notify: json['notify'] as bool? ?? true,
  lastCompletedDate: json['lastCompletedDate'] == null
      ? null
      : DateTime.parse(json['lastCompletedDate'] as String),
  lastCompletedOdometer: (json['lastCompletedOdometer'] as num?)?.toDouble(),
  linkedExpenseCategoryId: (json['linkedExpenseCategoryId'] as num?)?.toInt(),
  active: json['active'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ReminderToJson(_Reminder instance) => <String, dynamic>{
  'id': instance.id,
  'vehicleId': instance.vehicleId,
  'type': _$ReminderTypeEnumMap[instance.type]!,
  'title': instance.title,
  'triggerMode': _$TriggerModeEnumMap[instance.triggerMode]!,
  'dueDate': instance.dueDate?.toIso8601String(),
  'dueOdometer': instance.dueOdometer,
  'recurEvery': instance.recurEvery,
  'recurUnit': _$RecurUnitEnumMap[instance.recurUnit],
  'recurKmEvery': instance.recurKmEvery,
  'leadDays': instance.leadDays,
  'leadKm': instance.leadKm,
  'notify': instance.notify,
  'lastCompletedDate': instance.lastCompletedDate?.toIso8601String(),
  'lastCompletedOdometer': instance.lastCompletedOdometer,
  'linkedExpenseCategoryId': instance.linkedExpenseCategoryId,
  'active': instance.active,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$ReminderTypeEnumMap = {
  ReminderType.bollo: 'bollo',
  ReminderType.assicurazione: 'assicurazione',
  ReminderType.revisione: 'revisione',
  ReminderType.tagliando: 'tagliando',
  ReminderType.gomme: 'gomme',
  ReminderType.patente: 'patente',
  ReminderType.custom: 'custom',
};

const _$TriggerModeEnumMap = {
  TriggerMode.date: 'date',
  TriggerMode.distance: 'distance',
  TriggerMode.both: 'both',
};

const _$RecurUnitEnumMap = {
  RecurUnit.day: 'day',
  RecurUnit.month: 'month',
  RecurUnit.year: 'year',
  RecurUnit.km: 'km',
  RecurUnit.fixedDate: 'fixedDate',
};
