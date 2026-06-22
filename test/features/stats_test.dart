import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanko/src/data/repositories/fill_up_repository_impl.dart';
import 'package:tanko/src/data/repositories/vehicle_repository_impl.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/models/fill_up.dart';
import 'package:tanko/src/domain/models/vehicle.dart';
import 'package:tanko/src/features/stats/stats_screen.dart';
import 'package:tanko/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('stats screen shows comparison and a chart', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final vid = await VehicleRepositoryImpl(db).upsert(
      Vehicle(
        id: 0,
        make: 'Renault',
        model: 'Clio',
        fuelType: FuelType.hybrid,
        isDefault: true,
        specs: const VehicleSpecs(tankCapacityL: 40, mfrConsumption: 4),
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    await FillUpRepositoryImpl(db).upsert(
      FillUp(
        id: 0,
        vehicleId: vid,
        date: DateTime(2026, 1, 1),
        amount: 60,
        liters: 30,
        odometer: 1000,
        categoryId: 1,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    await FillUpRepositoryImpl(db).upsert(
      FillUp(
        id: 0,
        vehicleId: vid,
        date: DateTime(2026, 2, 1),
        amount: 80,
        liters: 40,
        odometer: 1500,
        categoryId: 1,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: StatsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Confronto reale vs dichiarato'), findsOneWidget);
    expect(find.textContaining('Consumo:'), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);
  });
}
