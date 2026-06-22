import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanko/src/data/repositories/fill_up_repository_impl.dart';
import 'package:tanko/src/data/repositories/vehicle_repository_impl.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/models/fill_up.dart';
import 'package:tanko/src/domain/models/vehicle.dart';
import 'package:tanko/src/features/dashboard/dashboard_screen.dart';
import 'package:tanko/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('dashboard shows total spend for the default vehicle', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vid = await VehicleRepositoryImpl(db).upsert(
      Vehicle(
        id: 0,
        make: 'R',
        model: 'C',
        fuelType: FuelType.petrol,
        isDefault: true,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    for (final m in [1, 2]) {
      await FillUpRepositoryImpl(db).upsert(
        FillUp(
          id: 0,
          vehicleId: vid,
          date: DateTime(2026, m, 1),
          amount: 50,
          liters: 40,
          odometer: 1000.0 * m,
          categoryId: 1,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('100'), findsWidgets);
  });
}
