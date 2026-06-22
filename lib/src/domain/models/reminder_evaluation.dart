import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'reminder.dart';

part 'reminder_evaluation.freezed.dart';

/// A reminder paired with its runtime-derived status (never persisted).
@freezed
abstract class ReminderEvaluation with _$ReminderEvaluation {
  const factory ReminderEvaluation({
    required Reminder reminder,
    required ReminderStatus status,
    int? daysRemaining,
    double? kmRemaining,
  }) = _ReminderEvaluation;
}
