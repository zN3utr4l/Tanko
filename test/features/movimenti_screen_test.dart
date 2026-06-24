import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/data/repositories/category_repository_impl.dart';
import 'package:carburo/src/data/repositories/fill_up_repository_impl.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/models/vehicle.dart';
import 'package:carburo/src/features/movimenti/movimenti_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('movement rows can be deleted from the list', (tester) async {
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
        date: DateTime(2026, 1, 1),
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
        child: const MaterialApp(home: MovimentiScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rifornimento'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elimina'));
    await tester.pumpAndSettle();

    expect(await FillUpRepositoryImpl(db).forVehicle(vehicleId), isEmpty);
    expect(find.text('Nessun movimento.'), findsOneWidget);
  });
}
