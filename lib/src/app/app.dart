import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/enums.dart';
import '../features/updates/update_providers.dart';
import '../providers.dart';
import 'router.dart';
import 'theme.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
    _checkForUpdate();
  }

  /// Best-effort: prepare notifications and (re)schedule date-based reminders.
  /// Distance-based reminders are surfaced in-app on the Scadenze screen.
  Future<void> _initNotifications() async {
    try {
      final svc = ref.read(notificationServiceProvider);
      await svc.init();
      await svc.cancelAll();
      final reminders = await ref.read(reminderRepositoryProvider).all();
      for (final r in reminders.where(
        (r) =>
            r.active &&
            r.notify &&
            r.dueDate != null &&
            r.triggerMode != TriggerMode.distance,
      )) {
        await svc.scheduleAt(
          id: r.id,
          title: r.title,
          body: 'Scadenza in arrivo',
          when: r.dueDate!.subtract(Duration(days: r.leadDays ?? 0)),
        );
      }
    } catch (_) {
      /* best-effort */
    }
  }

  Future<void> _checkForUpdate() async {
    try {
      final settings = await ref.read(lookupSettingsProvider.future);
      if (!settings.updateChecksEnabled) return;
      await startupUpdateCheck(ref);
    } catch (_) {
      /* best-effort */
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Carburo',
      theme: appTheme(Brightness.light),
      darkTheme: appTheme(Brightness.dark),
      routerConfig: appRouter,
    );
  }
}
