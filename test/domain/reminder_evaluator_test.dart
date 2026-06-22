import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/models/reminder.dart';
import 'package:tanko/src/domain/services/reminder_evaluator.dart';

Reminder rem({
  TriggerMode triggerMode = TriggerMode.date,
  DateTime? dueDate,
  double? dueOdometer,
  int? recurEvery,
  RecurUnit? recurUnit,
  int? recurKmEvery,
  int? leadDays,
  int? leadKm,
  bool active = true,
}) => Reminder(
  id: 1,
  vehicleId: 1,
  type: ReminderType.custom,
  title: 'X',
  triggerMode: triggerMode,
  dueDate: dueDate,
  dueOdometer: dueOdometer,
  recurEvery: recurEvery,
  recurUnit: recurUnit,
  recurKmEvery: recurKmEvery,
  leadDays: leadDays,
  leadKm: leadKm,
  active: active,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  const ev = ReminderEvaluator();
  final today = DateTime(2026, 6, 1);

  group('date-based status', () {
    test('far future -> ok', () {
      final e = ev.evaluate(
        rem(dueDate: DateTime(2026, 12, 1), leadDays: 30),
        today: today,
        currentOdometer: 0,
      );
      expect(e.status, ReminderStatus.ok);
      expect(e.daysRemaining, DateTime(2026, 12, 1).difference(today).inDays);
    });

    test('within lead window -> upcoming', () {
      final e = ev.evaluate(
        rem(dueDate: DateTime(2026, 6, 20), leadDays: 30),
        today: today,
        currentOdometer: 0,
      );
      expect(e.status, ReminderStatus.upcoming);
    });

    test('past due -> overdue', () {
      final e = ev.evaluate(
        rem(dueDate: DateTime(2026, 5, 1), leadDays: 30),
        today: today,
        currentOdometer: 0,
      );
      expect(e.status, ReminderStatus.overdue);
      expect(e.daysRemaining, isNegative);
    });
  });

  group('distance-based status', () {
    final r = rem(
      triggerMode: TriggerMode.distance,
      dueOdometer: 40000,
      leadKm: 1000,
    );
    test('far -> ok', () {
      expect(
        ev.evaluate(r, today: today, currentOdometer: 30000).status,
        ReminderStatus.ok,
      );
    });
    test('within leadKm -> upcoming', () {
      final e = ev.evaluate(r, today: today, currentOdometer: 39500);
      expect(e.status, ReminderStatus.upcoming);
      expect(e.kmRemaining, 500);
    });
    test('past odometer -> overdue', () {
      expect(
        ev.evaluate(r, today: today, currentOdometer: 40500).status,
        ReminderStatus.overdue,
      );
    });
  });

  test('BOTH: overdue if either axis passed', () {
    final r = rem(
      triggerMode: TriggerMode.both,
      dueDate: DateTime(2027, 1, 1),
      dueOdometer: 40000,
      leadDays: 30,
      leadKm: 1000,
    );
    // date far, but km passed -> overdue
    expect(
      ev.evaluate(r, today: today, currentOdometer: 41000).status,
      ReminderStatus.overdue,
    );
  });

  test('inactive -> completed', () {
    final e = ev.evaluate(
      rem(dueDate: DateTime(2026, 5, 1), active: false),
      today: today,
      currentOdometer: 0,
    );
    expect(e.status, ReminderStatus.completed);
  });

  group('nextOccurrence', () {
    test('YEAR recurrence anchors to completion date', () {
      final next = ev.nextOccurrence(
        rem(
          dueDate: DateTime(2026, 1, 1),
          recurEvery: 1,
          recurUnit: RecurUnit.year,
        ),
        completedDate: DateTime(2026, 2, 15),
        completedOdometer: 0,
      );
      expect(next!.dueDate, DateTime(2027, 2, 15));
      expect(next.lastCompletedDate, DateTime(2026, 2, 15));
    });

    test('KM recurrence anchors to completion odometer', () {
      final next = ev.nextOccurrence(
        rem(
          triggerMode: TriggerMode.distance,
          dueOdometer: 20000,
          recurEvery: 20000,
          recurUnit: RecurUnit.km,
        ),
        completedDate: today,
        completedOdometer: 21000,
      );
      expect(next!.dueOdometer, 41000);
    });

    test('BOTH advances both axes', () {
      final next = ev.nextOccurrence(
        rem(
          triggerMode: TriggerMode.both,
          dueDate: DateTime(2026, 1, 1),
          dueOdometer: 20000,
          recurEvery: 2,
          recurUnit: RecurUnit.year,
          recurKmEvery: 20000,
        ),
        completedDate: DateTime(2026, 3, 1),
        completedOdometer: 22000,
      );
      expect(next!.dueDate, DateTime(2028, 3, 1));
      expect(next.dueOdometer, 42000);
    });

    test('FIXED_DATE recurs on the next calendar occurrence', () {
      final next = ev.nextOccurrence(
        rem(dueDate: DateTime(2026, 4, 15), recurUnit: RecurUnit.fixedDate),
        completedDate: DateTime(2026, 4, 16),
        completedOdometer: 0,
      );
      expect(next!.dueDate, DateTime(2027, 4, 15));
    });

    test('one-shot returns null', () {
      final next = ev.nextOccurrence(
        rem(dueDate: DateTime(2026, 1, 1)),
        completedDate: today,
        completedOdometer: 0,
      );
      expect(next, isNull);
    });

    test('monthly recurrence clamps the day (Jan 31 + 1 month -> Feb 28)', () {
      final next = ev.nextOccurrence(
        rem(
          dueDate: DateTime(2026, 1, 31),
          recurEvery: 1,
          recurUnit: RecurUnit.month,
        ),
        completedDate: DateTime(2026, 1, 31),
        completedOdometer: 0,
      );
      expect(next!.dueDate, DateTime(2026, 2, 28));
    });

    test('yearly recurrence clamps Feb 29 in a non-leap year', () {
      final next = ev.nextOccurrence(
        rem(
          dueDate: DateTime(2024, 2, 29),
          recurEvery: 1,
          recurUnit: RecurUnit.year,
        ),
        completedDate: DateTime(2024, 2, 29),
        completedOdometer: 0,
      );
      expect(next!.dueDate, DateTime(2025, 2, 28));
    });

    test('BOTH with only a date rule drops the stale odometer threshold', () {
      final next = ev.nextOccurrence(
        rem(
          triggerMode: TriggerMode.both,
          dueDate: DateTime(2026, 1, 1),
          dueOdometer: 20000,
          recurEvery: 1,
          recurUnit: RecurUnit.year,
        ),
        completedDate: DateTime(2026, 2, 1),
        completedOdometer: 25000,
      );
      expect(next!.dueDate, DateTime(2027, 2, 1));
      expect(next.dueOdometer, isNull); // not born already-overdue by km
    });
  });
}
