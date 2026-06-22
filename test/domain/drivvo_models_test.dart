import 'package:flutter_test/flutter_test.dart';
import 'package:tanko/src/domain/models/category.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/models/expense.dart';
import 'package:tanko/src/domain/models/reminder.dart';

void main() {
  test(
    'Category round-trips with new fields; legacy JSON defaults to fuel',
    () {
      const c = Category(
        id: 1,
        name: 'Assicurazione',
        color: 0xFF1565C0,
        kind: CategoryKind.expense,
        iconCode: 0xe1a7,
        ord: 3,
      );
      expect(Category.fromJson(c.toJson()), c);

      // Legacy v1 backup JSON has no 'kind' -> defaults to fuel.
      final legacy = Category.fromJson({
        'id': 1,
        'name': 'Mine',
        'color': 1,
        'isDefault': true,
      });
      expect(legacy.kind, CategoryKind.fuel);
      expect(legacy.ord, 0);
    },
  );

  test('Expense round-trips JSON', () {
    final e = Expense(
      id: 1,
      vehicleId: 2,
      date: DateTime(2026, 3, 1),
      odometer: 12000,
      categoryId: 5,
      amount: 350,
      description: 'RCA annuale',
      createdAt: DateTime(2026, 3, 1),
      updatedAt: DateTime(2026, 3, 1),
    );
    expect(Expense.fromJson(e.toJson()), e);
  });

  test('Reminder round-trips JSON with enums', () {
    final r = Reminder(
      id: 1,
      vehicleId: 2,
      type: ReminderType.tagliando,
      title: 'Tagliando',
      triggerMode: TriggerMode.both,
      dueDate: DateTime(2027, 1, 1),
      dueOdometer: 40000,
      recurEvery: 2,
      recurUnit: RecurUnit.year,
      recurKmEvery: 20000,
      leadDays: 30,
      leadKm: 1000,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
    expect(Reminder.fromJson(r.toJson()), r);
  });
}
