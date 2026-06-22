import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/altro/altro_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/reminders/scadenze_screen.dart';
import '../features/stats/stats_screen.dart';

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

class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
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
