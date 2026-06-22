import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../providers.dart';
import '../expenses/expense_providers.dart';
import '../fillups/fillup_providers.dart';
import 'calendar_event.dart';

part 'calendar_providers.g.dart';

DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

@riverpod
Future<Map<DateTime, List<CalendarEvent>>> calendarEvents(
  Ref ref,
  int vehicleId,
) async {
  final fills = await ref.watch(fillUpsProvider(vehicleId).future);
  final expenses = await ref.watch(
    expensesForVehicleProvider(vehicleId).future,
  );
  final reminders = await ref
      .watch(reminderRepositoryProvider)
      .forVehicle(vehicleId);
  final cats = await ref.watch(allCategoriesProvider.future);
  final catName = {for (final c in cats) c.id: c.name};
  final today = DateTime.now();

  final map = <DateTime, List<CalendarEvent>>{};
  void put(DateTime d, CalendarEvent e) =>
      (map[_dayKey(d)] ??= <CalendarEvent>[]).add(e);

  for (final f in fills) {
    put(
      f.date,
      CalendarEvent(
        date: f.date,
        type: CalendarEventType.fuel,
        title: 'Rifornimento',
        amount: f.amount,
        refId: f.id,
      ),
    );
  }
  for (final e in expenses) {
    put(
      e.date,
      CalendarEvent(
        date: e.date,
        type: CalendarEventType.expense,
        title: catName[e.categoryId] ?? 'Spesa',
        amount: e.amount,
        refId: e.id,
      ),
    );
  }
  for (final r in reminders.where((r) => r.active && r.dueDate != null)) {
    put(
      r.dueDate!,
      CalendarEvent(
        date: r.dueDate!,
        type: CalendarEventType.reminder,
        title: r.title,
        overdue: !today.isBefore(r.dueDate!),
        refId: r.id,
      ),
    );
  }
  return map;
}
