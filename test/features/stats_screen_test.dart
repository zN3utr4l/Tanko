import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/data/repositories/category_repository_impl.dart';
import 'package:carburo/src/data/repositories/fill_up_repository_impl.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/models/vehicle.dart';
import 'package:carburo/src/features/stats/stats_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets(
    'StatsScreen shows clear empty-states when liters/station/2nd fill missing',
    (tester) async {
      final db = makeTestDb();
      addTearDown(db.close);
      final fuelCat = (await CategoryRepositoryImpl(db).all())
          .firstWhere((c) => c.isDefault);
      final vid = await VehicleRepositoryImpl(db).upsert(
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
      // One fill, no liters and no station: every liters/station/2-fill-based
      // section should fall back to its explicit empty-state.
      await FillUpRepositoryImpl(db).upsert(
        FillUp(
          id: 0,
          vehicleId: vid,
          date: DateTime(2026, 1, 1),
          amount: 50,
          odometer: 1000,
          categoryId: fuelCat.id,
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

      // Comparison card is near the top and explains the liters requirement.
      expect(find.textContaining('Servono i litri'), findsOneWidget);

      // Lower sections are built lazily by the ListView; scroll them into view.
      await tester.scrollUntilVisible(
        find.textContaining('Servono almeno due rifornimenti'),
        250,
      );
      expect(
        find.textContaining('Servono almeno due rifornimenti'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.textContaining('Nessuna stazione registrata'),
        250,
      );
      expect(
        find.textContaining('Nessuna stazione registrata'),
        findsOneWidget,
      );
    },
  );
}
