import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/data/repositories/fill_up_repository_impl.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/app/theme.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/models/vehicle.dart';
import 'package:carburo/src/features/dashboard/dashboard_screen.dart';
import 'package:carburo/src/providers.dart';
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
        child: MaterialApp(
          theme: appTheme(Brightness.light),
          home: const DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('100'), findsWidgets);
    expect(find.byKey(const Key('dashboard-hero')), findsOneWidget);
    expect(find.text('Garage'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Rifornimento'), findsNothing);
    expect(find.widgetWithText(OutlinedButton, 'Spesa'), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byKey(const Key('metric-total-cost')), findsOneWidget);
    expect(find.byKey(const Key('metric-cost-per-km')), findsOneWidget);
  });
}
