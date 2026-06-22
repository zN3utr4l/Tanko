import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanko/src/data/repositories/vehicle_repository_impl.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/models/vehicle.dart';
import 'package:tanko/src/features/vehicles/vehicles_screen.dart';
import 'package:tanko/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('VehiclesScreen lists a saved vehicle', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await VehicleRepositoryImpl(db).upsert(
      Vehicle(
        id: 0,
        make: 'Renault',
        model: 'Clio',
        fuelType: FuelType.hybrid,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: VehiclesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Renault Clio'), findsOneWidget);
  });
}
