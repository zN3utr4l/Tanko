import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required int id,
    required int vehicleId,
    required ReminderType type,
    required String title,
    required TriggerMode triggerMode,
    DateTime? dueDate,
    double? dueOdometer,
    int? recurEvery,
    RecurUnit? recurUnit,
    int? recurKmEvery,
    int? leadDays,
    int? leadKm,
    @Default(true) bool notify,
    DateTime? lastCompletedDate,
    double? lastCompletedOdometer,
    int? linkedExpenseCategoryId,
    @Default(true) bool active,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, Object?> json) =>
      _$ReminderFromJson(json);
}
