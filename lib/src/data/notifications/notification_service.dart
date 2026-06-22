import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Best-effort on-device notifications for reminders. Every call is guarded so
/// a missing permission or platform quirk degrades gracefully (the in-app
/// Scadenze screen always works regardless).
class NotificationService {
  NotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'tanko_reminders',
      'Scadenze',
      channelDescription: 'Promemoria scadenze veicolo',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );
      await _plugin.initialize(settings: settings);
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  /// Schedules a future-dated notification (inexact, no exact-alarm permission).
  /// No-op for past dates (those are surfaced immediately via [showNow]).
  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    if (!_ready) return;
    try {
      final scheduled = tz.TZDateTime.from(when, tz.local);
      if (!scheduled.isAfter(tz.TZDateTime.now(tz.local))) return;
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduled,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (_) {
      /* best-effort */
    }
  }

  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_ready) return;
    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _details,
      );
    } catch (_) {
      /* best-effort */
    }
  }

  Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id: id);
    } catch (_) {
      /* best-effort */
    }
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (_) {
      /* best-effort */
    }
  }
}
