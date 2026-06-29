import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/data/notifications/notification_service.dart';
import 'package:carburo/src/data/notifications/reminder_notification_scheduler.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/reminder.dart';
import 'package:carburo/src/domain/repositories/reminder_repository.dart';

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
    expect(plan!.id, reminderNotificationId(1));
    expect(plan.title, 'RCA');
    expect(plan.when, DateTime(2026, 6, 25));
  });

  test('skips disabled, inactive, distance-only, and dateless reminders', () {
    expect(planner.plan(_reminder(active: false)), isNull);
    expect(planner.plan(_reminder(notify: false)), isNull);
    expect(planner.plan(_reminder(triggerMode: TriggerMode.distance)), isNull);
    expect(planner.plan(_reminder(hasDueDate: false)), isNull);
  });

  test('enableAndRescheduleAll asks permissions from a user action path', () async {
    final notifications = _FakeNotificationService();
    final scheduler = ReminderNotificationScheduler(
      reminders: _FakeReminderRepository([
        _reminder(id: 7, dueDate: DateTime(2026, 8, 1)),
      ]),
      notifications: notifications,
    );

    final enabled = await scheduler.enableAndRescheduleAll();

    expect(enabled, isTrue);
    expect(notifications.initialized, isTrue);
    expect(notifications.requestedNotifications, isTrue);
    expect(notifications.requestedExactAlarms, isTrue);
    expect(notifications.cancelledAll, isTrue);
    expect(notifications.scheduled.single.id, reminderNotificationId(7));
  });

  test('enableAndRescheduleAll does not schedule when permission is denied', () async {
    final notifications = _FakeNotificationService(
      notificationPermission: false,
    );
    final scheduler = ReminderNotificationScheduler(
      reminders: _FakeReminderRepository([
        _reminder(id: 8, dueDate: DateTime(2026, 8, 1)),
      ]),
      notifications: notifications,
    );

    final enabled = await scheduler.enableAndRescheduleAll();

    expect(enabled, isFalse);
    expect(notifications.requestedExactAlarms, isFalse);
    expect(notifications.cancelledAll, isFalse);
    expect(notifications.scheduled, isEmpty);
  });

  test('sync cancels the deterministic notification id before rescheduling', () async {
    final notifications = _FakeNotificationService();
    final scheduler = ReminderNotificationScheduler(
      reminders: _FakeReminderRepository(const []),
      notifications: notifications,
    );

    await scheduler.sync(_reminder(id: 11, dueDate: DateTime(2026, 8, 1)));

    expect(notifications.cancelled, [reminderNotificationId(11)]);
    expect(notifications.scheduled.single.id, reminderNotificationId(11));
  });
}

class _FakeReminderRepository implements ReminderRepository {
  _FakeReminderRepository(this._reminders);

  final List<Reminder> _reminders;

  @override
  Future<List<Reminder>> all() async => _reminders;

  @override
  Future<void> complete(
    int reminderId, {
    required DateTime date,
    double? odometer,
    bool createExpense = false,
    double? expenseAmount,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Reminder>> forVehicle(int vehicleId) async =>
      _reminders.where((r) => r.vehicleId == vehicleId).toList();

  @override
  Future<int> upsert(Reminder reminder) {
    throw UnimplementedError();
  }
}

class _FakeNotificationService extends NotificationService {
  _FakeNotificationService({this.notificationPermission = true});

  final bool notificationPermission;
  bool initialized = false;
  bool requestedNotifications = false;
  bool requestedExactAlarms = false;
  bool cancelledAll = false;
  final cancelled = <int>[];
  final scheduled = <ScheduledReminderNotification>[];

  @override
  Future<void> init() async {
    initialized = true;
  }

  @override
  Future<bool> requestNotificationPermission() async {
    requestedNotifications = true;
    return notificationPermission;
  }

  @override
  Future<bool> requestExactAlarmsPermission() async {
    requestedExactAlarms = true;
    return true;
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }

  @override
  Future<void> cancelAll() async {
    cancelledAll = true;
  }

  @override
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    scheduled.add(
      ScheduledReminderNotification(
        id: id,
        title: title,
        body: body,
        when: when,
      ),
    );
  }
}
