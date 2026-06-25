import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/altro/altro_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/reminders/scadenze_screen.dart';
import '../features/stats/stats_screen.dart';
import '../features/updates/update_banner.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _HomeShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (_, _) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calendar',
              builder: (_, _) => const CalendarScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/scadenze',
              builder: (_, _) => const ScadenzeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/stats', builder: (_, _) => const StatsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/altro', builder: (_, _) => const AltroScreen()),
          ],
        ),
      ],
    ),
  ],
);

class _HomeShell extends ConsumerWidget {
  const _HomeShell({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // The system status bar (clock, notifications, wifi) draws over the app in
      // Android's edge-to-edge mode. This shell has no AppBar to reserve that
      // inset, so wrap the body in a SafeArea: it applies the top inset once and
      // strips it from descendants, so the banner and each tab's AppBar sit below
      // the status bar without double-padding. Bottom is left to NavigationBar.
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const UpdateBanner(),
            Expanded(child: shell),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: shell.goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Scadenze',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiche',
          ),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Altro'),
        ],
      ),
    );
  }
}
