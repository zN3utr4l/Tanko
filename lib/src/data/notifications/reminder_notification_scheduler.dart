import '../../domain/models/enums.dart';
import '../../domain/models/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import 'notification_service.dart';

class ScheduledReminderNotification {
  const ScheduledReminderNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.when,
  });

  final int id;
  final String title;
  final String body;
  final DateTime when;
}

class ReminderNotificationPlanner {
  const ReminderNotificationPlanner();

  ScheduledReminderNotification? plan(Reminder reminder) {
    if (!reminder.active || !reminder.notify) return null;
    if (reminder.dueDate == null) return null;
    if (reminder.triggerMode == TriggerMode.distance) return null;
    return ScheduledReminderNotification(
      id: reminder.id,
      title: reminder.title,
      body: 'Scadenza in arrivo',
      when: reminder.dueDate!.subtract(Duration(days: reminder.leadDays ?? 0)),
    );
  }
}

class ReminderNotificationScheduler {
  ReminderNotificationScheduler({
    required this.reminders,
    required this.notifications,
    this.planner = const ReminderNotificationPlanner(),
  });

  final ReminderRepository reminders;
  final NotificationService notifications;
  final ReminderNotificationPlanner planner;

  Future<void> rescheduleAll({bool initialize = false}) async {
    if (initialize) await notifications.init();
    await notifications.cancelAll();
    for (final reminder in await reminders.all()) {
      await sync(reminder);
    }
  }

  Future<void> sync(Reminder reminder) async {
    await notifications.cancel(reminder.id);
    final plan = planner.plan(reminder);
    if (plan == null) return;
    await notifications.scheduleAt(
      id: plan.id,
      title: plan.title,
      body: plan.body,
      when: plan.when,
    );
  }

  Future<void> cancel(int reminderId) => notifications.cancel(reminderId);
}
