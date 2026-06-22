import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required int id,
    required int vehicleId,
    required DateTime date,
    double? odometer,
    required int categoryId,
    required double amount,
    String? description,
    @Default(false) bool isRecurring,
    int? reminderId,
    String? receiptPhotoPath,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, Object?> json) =>
      _$ExpenseFromJson(json);
}
