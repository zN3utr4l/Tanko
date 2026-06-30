import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/data/repositories/category_repository_impl.dart';
import 'package:carburo/src/data/repositories/fill_up_repository_impl.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/models/vehicle.dart';
import 'package:carburo/src/features/fillups/fill_up_form_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('shows live price/L when amount and liters are entered', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: FillUpFormScreen(vehicleId: 1, initialDate: DateTime(2020)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('amount')), '40');
    await tester.enterText(find.byKey(const Key('liters')), '32');
    await tester.pump();

    expect(find.textContaining('1,25'), findsWidgets); // 40 / 32 = 1.25 €/L
  });

  testWidgets('blocks save when amount is empty', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: FillUpFormScreen(vehicleId: 1, initialDate: DateTime(2020)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salva'));
    await tester.pump();
    expect(find.text('Obbligatorio'), findsWidgets);
  });

  testWidgets('fill-up form separates main fields from details', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: FillUpFormScreen(vehicleId: 1, initialDate: DateTime(2020)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('fillup-main-section')), findsOneWidget);
    expect(find.byKey(const Key('fillup-details-section')), findsOneWidget);
    final amountBottom = tester
        .getBottomLeft(find.byKey(const Key('amount')))
        .dy;
    final litersTop = tester.getTopLeft(find.byKey(const Key('liters'))).dy;
    expect(litersTop - amountBottom, greaterThanOrEqualTo(12));
  });

  testWidgets('asks confirmation before saving a lower odometer', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final cats = CategoryRepositoryImpl(db);
    final vehicles = VehicleRepositoryImpl(db);
    final fills = FillUpRepositoryImpl(db);
    final fuelCat = (await cats.all()).firstWhere(
      (c) => c.kind == CategoryKind.fuel,
    );
    final vehicleId = await vehicles.upsert(
      Vehicle(
        id: 0,
        make: 'Fiat',
        model: 'Panda',
        fuelType: FuelType.petrol,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    await fills.upsert(
      FillUp(
        id: 0,
        vehicleId: vehicleId,
        date: DateTime(2026, 1, 1),
        amount: 40,
        liters: 30,
        odometer: 1000,
        categoryId: fuelCat.id,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: FillUpFormScreen(
            vehicleId: vehicleId,
            initialDate: DateTime(2026, 1, 2),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('amount')), '35');
    await tester.enterText(find.byKey(const Key('liters')), '28');
    await tester.enterText(find.byKey(const Key('odometer')), '900');
    await tester.tap(find.text('Salva'));
    await tester.pumpAndSettle();

    expect(find.text('Odometro inferiore'), findsOneWidget);
    expect(await fills.forVehicle(vehicleId), hasLength(1));

    await tester.tap(find.text('Salva comunque'));
    await tester.pumpAndSettle();

    expect(await fills.forVehicle(vehicleId), hasLength(2));
  });

  testWidgets('asks confirmation before saving a duplicate fill-up', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final cats = CategoryRepositoryImpl(db);
    final vehicles = VehicleRepositoryImpl(db);
    final fills = FillUpRepositoryImpl(db);
    final fuelCat = (await cats.all()).firstWhere(
      (c) => c.kind == CategoryKind.fuel,
    );
    final vehicleId = await vehicles.upsert(
      Vehicle(
        id: 0,
        make: 'Fiat',
        model: 'Panda',
        fuelType: FuelType.petrol,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    await fills.upsert(
      FillUp(
        id: 0,
        vehicleId: vehicleId,
        date: DateTime(2026, 1, 2),
        amount: 35,
        liters: 28,
        odometer: 900,
        categoryId: fuelCat.id,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: FillUpFormScreen(
            vehicleId: vehicleId,
            initialDate: DateTime(2026, 1, 2),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('amount')), '35');
    await tester.enterText(find.byKey(const Key('liters')), '28');
    await tester.enterText(find.byKey(const Key('odometer')), '900');
    await tester.tap(find.text('Salva'));
    await tester.pumpAndSettle();

    expect(find.text('Possibile duplicato'), findsOneWidget);
    expect(await fills.forVehicle(vehicleId), hasLength(1));
  });

  testWidgets('editing a fill-up preserves its existing category', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final cats = CategoryRepositoryImpl(db);
    final vehicles = VehicleRepositoryImpl(db);
    final fills = FillUpRepositoryImpl(db);
    final fuelCats = (await cats.all())
        .where((c) => c.kind == CategoryKind.fuel)
        .toList();
    final nonDefaultCat = fuelCats.firstWhere((c) => !c.isDefault);
    final vehicleId = await vehicles.upsert(
      Vehicle(
        id: 0,
        make: 'Fiat',
        model: 'Panda',
        fuelType: FuelType.petrol,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    final fillId = await fills.upsert(
      FillUp(
        id: 0,
        vehicleId: vehicleId,
        date: DateTime(2026, 1, 2),
        amount: 35,
        liters: 28,
        odometer: 900,
        categoryId: nonDefaultCat.id,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    final initial = (await fills.forVehicle(vehicleId)).single;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: FillUpFormScreen(vehicleId: vehicleId, initial: initial),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('amount')), '36');
    await tester.tap(find.text('Salva'));
    await tester.pumpAndSettle();

    final saved = (await fills.forVehicle(
      vehicleId,
    )).singleWhere((f) => f.id == fillId);
    expect(saved.amount, 36);
    expect(saved.categoryId, nonDefaultCat.id);
  });
}
