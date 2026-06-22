// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: (json['id'] as num).toInt(),
  vehicleId: (json['vehicleId'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  odometer: (json['odometer'] as num?)?.toDouble(),
  categoryId: (json['categoryId'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String?,
  isRecurring: json['isRecurring'] as bool? ?? false,
  reminderId: (json['reminderId'] as num?)?.toInt(),
  receiptPhotoPath: json['receiptPhotoPath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'vehicleId': instance.vehicleId,
  'date': instance.date.toIso8601String(),
  'odometer': instance.odometer,
  'categoryId': instance.categoryId,
  'amount': instance.amount,
  'description': instance.description,
  'isRecurring': instance.isRecurring,
  'reminderId': instance.reminderId,
  'receiptPhotoPath': instance.receiptPhotoPath,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
