import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanko/src/data/database/database.dart';
import 'package:tanko/src/data/repositories/expense_repository_impl.dart';
import 'package:tanko/src/data/repositories/reminder_repository_impl.dart';
import 'package:tanko/src/data/repositories/vehicle_repository_impl.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/models/reminder.dart';
import 'package:tanko/src/domain/models/vehicle.dart';
import 'package:tanko/src/features/expenses/expense_form_screen.dart';
import 'package:tanko/src/features/reminders/scadenze_screen.dart';
import 'package:tanko/src/providers.dart';
import '../helpers/test_db.dart';

Future<int> _defaultVehicle(AppDatabase db) => VehicleRepositoryImpl(db).upsert(
  Vehicle(
    id: 0,
    make: 'Renault',
    model: 'Clio',
    fuelType: FuelType.hybrid,
    isDefault: true,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  ),
);

void main() {
  testWidgets('expense form saves an expense with the default category', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vid = await _defaultVehicle(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(home: ExpenseFormScreen(vehicleId: vid)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('amount')), '350');
    await tester.scrollUntilVisible(
      find.text('Salva'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Salva'));
    await tester.pumpAndSettle();

    final saved = await ExpenseRepositoryImpl(db).forVehicle(vid);
    expect(saved.single.amount, 350);
  });

  testWidgets('scadenze lists an overdue reminder', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vid = await _defaultVehicle(db);
    await ReminderRepositoryImpl(db).upsert(
      Reminder(
        id: 0,
        vehicleId: vid,
        type: ReminderType.revisione,
        title: 'Revisione',
        triggerMode: TriggerMode.date,
        dueDate: DateTime(2020, 1, 1),
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ScadenzeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Revisione'), findsOneWidget);
    expect(find.textContaining('Scaduto'), findsWidgets);
  });
}
