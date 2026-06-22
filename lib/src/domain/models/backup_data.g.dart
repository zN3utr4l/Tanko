// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupData _$BackupDataFromJson(Map<String, dynamic> json) => _BackupData(
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 2,
  vehicles:
      (json['vehicles'] as List<dynamic>?)
          ?.map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Vehicle>[],
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Category>[],
  fillUps:
      (json['fillUps'] as List<dynamic>?)
          ?.map((e) => FillUp.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FillUp>[],
  expenses:
      (json['expenses'] as List<dynamic>?)
          ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Expense>[],
  reminders:
      (json['reminders'] as List<dynamic>?)
          ?.map((e) => Reminder.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Reminder>[],
);

Map<String, dynamic> _$BackupDataToJson(_BackupData instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'vehicles': instance.vehicles.map((e) => e.toJson()).toList(),
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'fillUps': instance.fillUps.map((e) => e.toJson()).toList(),
      'expenses': instance.expenses.map((e) => e.toJson()).toList(),
      'reminders': instance.reminders.map((e) => e.toJson()).toList(),
    };
