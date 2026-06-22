import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_total.freezed.dart';

@freezed
abstract class MonthlyTotal with _$MonthlyTotal {
  const factory MonthlyTotal({
    required int year,
    required int month,
    required double total,
  }) = _MonthlyTotal;

  const MonthlyTotal._();

  String get label => '$month/${year % 100}';
}
