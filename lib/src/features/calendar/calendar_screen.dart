import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
                    locale: 'it_IT',
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
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextFormatter: (date, locale) =>
                          _capitalize(DateFormat.yMMMM(locale).format(date)),
                    ),
                    onHeaderTapped: (_) => _openMonthPicker(context),
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

  /// Tapping the header opens a combined year/month picker to jump anywhere.
  /// On pick, focus and selection both move to the 1st of the chosen month so
  /// the day-events list below immediately reflects the new month.
  Future<void> _openMonthPicker(BuildContext context) async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (_) => _MonthPickerDialog(initialMonth: _focusedDay),
    );
    if (picked == null) return;
    setState(() {
      _focusedDay = picked;
      _selectedDay = picked;
    });
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

String _capitalize(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

/// "Vai al mese": a year stepper (‹ 2026 ›) over a 4×3 grid of months. Tapping
/// a month returns the 1st of that month; the year is clamped to a sensible
/// window (data never predates 2015; nothing useful past next year).
class _MonthPickerDialog extends StatefulWidget {
  const _MonthPickerDialog({required this.initialMonth});
  final DateTime initialMonth;

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  static const _minYear = 2015;
  late int _year = widget.initialMonth.year;
  int get _maxYear => DateTime.now().year + 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Vai al mese'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: 'Anno precedente',
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _year > _minYear
                      ? () => setState(() => _year--)
                      : null,
                ),
                Text('$_year', style: theme.textTheme.titleLarge),
                IconButton(
                  tooltip: 'Anno successivo',
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _year < _maxYear
                      ? () => setState(() => _year++)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.6,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var m = 1; m <= 12; m++)
                  _MonthChip(
                    label: _capitalize(
                      DateFormat.MMM('it_IT').format(DateTime(2000, m)),
                    ),
                    selected:
                        _year == widget.initialMonth.year &&
                        m == widget.initialMonth.month,
                    onTap: () => Navigator.of(context).pop(DateTime(_year, m)),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
      ],
    );
  }
}

class _MonthChip extends StatelessWidget {
  const _MonthChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? scheme.primaryContainer
          : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? scheme.onPrimaryContainer : null,
            ),
          ),
        ),
      ),
    );
  }
}
