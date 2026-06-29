import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/data/database/database.dart';
import 'package:carburo/src/data/repositories/category_repository_impl.dart';
import 'package:carburo/src/data/repositories/expense_repository_impl.dart';
import 'package:carburo/src/data/repositories/reminder_repository_impl.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/reminder.dart';
import 'package:carburo/src/domain/models/vehicle.dart';
import 'package:carburo/src/features/expenses/expense_form_screen.dart';
import 'package:carburo/src/features/reminders/scadenze_screen.dart';
import 'package:carburo/src/providers.dart';
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

  testWidgets('bollo completion pre-fills amount from stored vehicle data', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vid = await VehicleRepositoryImpl(db).upsert(
      Vehicle(
        id: 0,
        make: 'Alfa Romeo',
        model: 'Giulia',
        year: 2015,
        fuelType: FuelType.petrol,
        euroClass: EuroClass.euro6,
        isDefault: true,
        specs: const VehicleSpecs(powerPs: 300),
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    final bolloCategory = (await CategoryRepositoryImpl(
      db,
    ).all()).firstWhere((c) => c.name == 'Bollo');
    await ReminderRepositoryImpl(db).upsert(
      Reminder(
        id: 0,
        vehicleId: vid,
        type: ReminderType.bollo,
        title: 'Bollo',
        triggerMode: TriggerMode.date,
        dueDate: DateTime(2020, 1, 1),
        recurEvery: 1,
        recurUnit: RecurUnit.year,
        linkedExpenseCategoryId: bolloCategory.id,
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

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completa'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Importo (€)'), findsOneWidget);
    expect(find.text('942,27'), findsOneWidget);
  });

  testWidgets('completion with linked expense requires a valid amount', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vid = await _defaultVehicle(db);
    final category = (await CategoryRepositoryImpl(
      db,
    ).all()).firstWhere((c) => c.name == 'Tagliando');
    await ReminderRepositoryImpl(db).upsert(
      Reminder(
        id: 0,
        vehicleId: vid,
        type: ReminderType.tagliando,
        title: 'Tagliando',
        triggerMode: TriggerMode.date,
        dueDate: DateTime(2020, 1, 1),
        linkedExpenseCategoryId: category.id,
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

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Conferma'));
    await tester.pumpAndSettle();

    expect(find.text('Inserisci un importo valido'), findsOneWidget);
    expect(await ExpenseRepositoryImpl(db).forVehicle(vid), isEmpty);
    expect((await ReminderRepositoryImpl(db).forVehicle(vid)).single.active, isTrue);
  });
}
