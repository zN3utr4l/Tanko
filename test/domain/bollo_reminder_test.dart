import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/services/bollo_reminder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds a new annual bollo reminder with the amount in the title', () {
    final now = DateTime(2026, 6, 23);
    final r = bolloReminderDraft(
      vehicleId: 7,
      amount: 335.4,
      linkedExpenseCategoryId: 3,
      now: now,
    );
    expect(r.id, 0); // new
    expect(r.vehicleId, 7);
    expect(r.type, ReminderType.bollo);
    expect(r.title, 'Bollo — € 335,40');
    expect(r.triggerMode, TriggerMode.date);
    expect(r.dueDate, DateTime(2026, 6, 23));
    expect(r.recurEvery, 1);
    expect(r.recurUnit, RecurUnit.year);
    expect(r.notify, isTrue);
    expect(r.active, isTrue);
    expect(r.linkedExpenseCategoryId, 3);
  });

  test('linked expense category is optional', () {
    final r = bolloReminderDraft(
      vehicleId: 1,
      amount: 100,
      now: DateTime(2026, 1, 1),
    );
    expect(r.linkedExpenseCategoryId, isNull);
    expect(r.title, 'Bollo — € 100,00');
  });
}
