import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_stacked.freezed.dart';

/// Per-month split of fuel vs non-fuel expense, for the stacked bar chart.
@freezed
abstract class MonthlyStacked with _$MonthlyStacked {
  const factory MonthlyStacked({
    required int year,
    required int month,
    @Default(0) double fuel,
    @Default(0) double expense,
  }) = _MonthlyStacked;

  const MonthlyStacked._();

  String get label => '$month/${year % 100}';
  double get total => fuel + expense;
}
