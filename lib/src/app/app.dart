import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final settings = await ref.read(lookupSettingsProvider.future);
      if (!settings.reminderNotificationsEnabled) return;
      await ref
          .read(reminderNotificationSchedulerProvider)
          .rescheduleAll(initialize: true);
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
      locale: const Locale('it', 'IT'),
      supportedLocales: const [Locale('it', 'IT')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }
}
