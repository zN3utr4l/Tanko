import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:carburo/src/data/database/database.dart';
import 'package:carburo/src/data/repositories/category_repository_impl.dart';
import 'package:carburo/src/data/repositories/fill_up_repository_impl.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/models/vehicle.dart';
import 'package:carburo/src/features/calendar/calendar_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

String _cap(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

Future<int> _seedDefaultVehicle(AppDatabase db) =>
    VehicleRepositoryImpl(db).upsert(
  Vehicle(
    id: 0,
    make: 'Fiat',
    model: 'Panda',
    fuelType: FuelType.petrol,
    isDefault: true,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  ),
);

void main() {
  // The calendar renders with locale 'it_IT'; date symbols must be loaded.
  setUpAll(() async {
    Intl.defaultLocale = 'it_IT';
    await initializeDateFormatting('it_IT');
  });

  testWidgets('tapping a fuel calendar event opens the edit form', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vehicleId = await VehicleRepositoryImpl(db).upsert(
      Vehicle(
        id: 0,
        make: 'Fiat',
        model: 'Panda',
        fuelType: FuelType.petrol,
        isDefault: true,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    final category = (await CategoryRepositoryImpl(
      db,
    ).all()).firstWhere((c) => c.kind == CategoryKind.fuel);
    await FillUpRepositoryImpl(db).upsert(
      FillUp(
        id: 0,
        vehicleId: vehicleId,
        date: DateTime.now(),
        amount: 50,
        liters: 25,
        odometer: 1000,
        categoryId: category.id,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CalendarScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rifornimento').last);
    await tester.pumpAndSettle();

    expect(find.text('Modifica'), findsOneWidget);
  });

  testWidgets('header tap opens the month picker and jumps to the chosen month', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await _seedDefaultVehicle(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CalendarScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final now = DateTime.now();
    final currentHeader = _cap(DateFormat.yMMMM('it_IT').format(now));
    await tester.tap(find.text(currentHeader));
    await tester.pumpAndSettle();
    expect(find.text('Vai al mese'), findsOneWidget);

    // Advance one year, then pick January.
    await tester.tap(find.byTooltip('Anno successivo'));
    await tester.pump();
    await tester.tap(find.text('Gen'));
    await tester.pumpAndSettle();

    // Dialog closed and the calendar moved to January of next year.
    expect(find.text('Vai al mese'), findsNothing);
    expect(find.text('Gennaio ${now.year + 1}'), findsOneWidget);
  });
}
