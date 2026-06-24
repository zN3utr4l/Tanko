import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/formatters.dart';
import '../../providers.dart';
import '../dashboard/dashboard_providers.dart';
import '../expenses/expense_form_screen.dart';
import '../fillups/fill_up_form_screen.dart';
import '../reminders/scadenze_screen.dart';
import '../vehicles/widgets/empty_vehicle_prompt.dart';
import 'calendar_event.dart';
import 'calendar_providers.dart';

DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

const _typeColor = {
  CalendarEventType.fuel: Colors.teal,
  CalendarEventType.expense: Colors.amber,
  CalendarEventType.reminder: Colors.indigo,
};
const _typeIcon = {
  CalendarEventType.fuel: Icons.local_gas_station,
  CalendarEventType.expense: Icons.payments,
  CalendarEventType.reminder: Icons.notifications,
};

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final vehicleAsync = ref.watch(dashboardVehicleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: vehicleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (vehicle) {
          if (vehicle == null) {
            return const EmptyVehiclePrompt();
          }
          final eventsAsync = ref.watch(calendarEventsProvider(vehicle.id));
          return eventsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Errore: $e')),
            data: (events) {
              List<CalendarEvent> forDay(DateTime d) =>
                  events[_dayKey(d)] ?? [];
              final dayEvents = forDay(_selectedDay);
              return Column(
                children: [
                  TableCalendar<CalendarEvent>(
                    firstDay: DateTime(2015),
                    lastDay: DateTime(2100),
                    focusedDay: _focusedDay,
                    currentDay: DateTime.now(),
                    selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
                    eventLoader: forDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Mese',
                    },
                    headerStyle: const HeaderStyle(formatButtonVisible: false),
                    onDaySelected: (selected, focused) => setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    }),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, evs) {
                        if (evs.isEmpty) return const SizedBox.shrink();
                        final types = <CalendarEventType>{
                          for (final e in evs) e.type,
                        };
                        return Padding(
                          padding: const EdgeInsets.only(top: 34),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (final t in types)
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        t == CalendarEventType.reminder &&
                                            evs.any(
                                              (e) => e.type == t && e.overdue,
                                            )
                                        ? Colors.red
                                        : _typeColor[t],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: dayEvents.isEmpty
                        ? _EmptyDay(onAdd: () => _addSheet(context, vehicle.id))
                        : ListView(
                            children: [
                              for (final e in dayEvents)
                                ListTile(
                                  leading: Icon(
                                    _typeIcon[e.type],
                                    color: e.overdue
                                        ? Colors.red
                                        : _typeColor[e.type],
                                  ),
                                  title: Text(e.title),
                                  trailing: e.amount == null
                                      ? null
                                      : Text(fmtEuro(e.amount!)),
                                  onTap: () =>
                                      _openEvent(context, ref, vehicle.id, e),
                                ),
                              const SizedBox(height: 8),
                              Center(
                                child: TextButton.icon(
                                  onPressed: () =>
                                      _addSheet(context, vehicle.id),
                                  icon: const Icon(Icons.add),
                                  label: const Text(
                                    'Aggiungi per questo giorno',
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _addSheet(BuildContext context, int vehicleId) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.local_gas_station, color: Colors.teal),
              title: const Text('Rifornimento'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FillUpFormScreen(
                      vehicleId: vehicleId,
                      initialDate: _selectedDay,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.payments, color: Colors.amber),
              title: const Text('Spesa'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ExpenseFormScreen(
                      vehicleId: vehicleId,
                      initialDate: _selectedDay,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEvent(
    BuildContext context,
    WidgetRef ref,
    int vehicleId,
    CalendarEvent event,
  ) async {
    final refId = event.refId;
    if (refId == null) return;
    if (event.type == CalendarEventType.fuel) {
      final fills = await ref
          .read(fillUpRepositoryProvider)
          .forVehicle(vehicleId);
      if (!context.mounted) return;
      final fill = fills.where((f) => f.id == refId).firstOrNull;
      if (fill == null) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FillUpFormScreen(vehicleId: vehicleId, initial: fill),
        ),
      );
      return;
    }
    if (event.type == CalendarEventType.expense) {
      final expenses = await ref
          .read(expenseRepositoryProvider)
          .forVehicle(vehicleId);
      if (!context.mounted) return;
      final expense = expenses.where((e) => e.id == refId).firstOrNull;
      if (expense == null) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              ExpenseFormScreen(vehicleId: vehicleId, initial: expense),
        ),
      );
      return;
    }
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ScadenzeScreen()));
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Nessun evento in questo giorno'),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Aggiungi per questo giorno'),
          ),
        ],
      ),
    );
  }
}
