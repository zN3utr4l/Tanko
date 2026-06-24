import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/data/notifications/reminder_notification_scheduler.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/reminder.dart';

Reminder _reminder({
  int id = 1,
  bool active = true,
  bool notify = true,
  TriggerMode triggerMode = TriggerMode.date,
  DateTime? dueDate,
  bool hasDueDate = true,
  int? leadDays,
}) => Reminder(
  id: id,
  vehicleId: 1,
  type: ReminderType.assicurazione,
  title: 'RCA',
  triggerMode: triggerMode,
  dueDate: hasDueDate ? (dueDate ?? DateTime(2026, 7, 10)) : null,
  leadDays: leadDays,
  notify: notify,
  active: active,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  const planner = ReminderNotificationPlanner();

  test('plans date reminders at due date minus lead days', () {
    final plan = planner.plan(_reminder(leadDays: 15));

    expect(plan, isNotNull);
    expect(plan!.id, 1);
    expect(plan.title, 'RCA');
    expect(plan.when, DateTime(2026, 6, 25));
  });

  test('skips disabled, inactive, distance-only, and dateless reminders', () {
    expect(planner.plan(_reminder(active: false)), isNull);
    expect(planner.plan(_reminder(notify: false)), isNull);
    expect(planner.plan(_reminder(triggerMode: TriggerMode.distance)), isNull);
    expect(planner.plan(_reminder(hasDueDate: false)), isNull);
  });
}
