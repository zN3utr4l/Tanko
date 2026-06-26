import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:carburo/src/data/database/database.dart';
import 'package:carburo/src/domain/models/geo_point.dart';
import 'package:carburo/src/domain/services/location_service.dart';
import 'package:carburo/src/features/fillups/fill_up_form_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

class _FixedLocation implements LocationService {
  _FixedLocation(this._point);
  final GeoPoint? _point;
  @override
  Future<GeoPoint?> current() async => _point;
}

Future<void> _seed(AppDatabase db) async {
  await db
      .into(db.vehicles)
      .insert(
        VehiclesCompanion.insert(
          make: 'Fiat',
          model: 'Panda',
          fuelType: 'petrol',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );
  // A past fill-up with coords + station -> the history match target.
  // categoryId 1 = the seeded default fuel category 'Mie'.
  await db
      .into(db.fillUps)
      .insert(
        FillUpsCompanion.insert(
          vehicleId: 1,
          date: DateTime(2026, 1, 1),
          amount: 50,
          odometer: 1000,
          categoryId: 1,
          latitude: const Value(45.07),
          longitude: const Value(7.68),
          station: const Value('Eni Corso Francia'),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );
}

void main() {
  testWidgets('Si at a known station pre-fills the station field', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await _seed(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          locationServiceProvider.overrideWithValue(
            _FixedLocation(const GeoPoint(45.07, 7.68)),
          ),
        ],
        child: const MaterialApp(home: FillUpFormScreen(vehicleId: 1)),
      ),
    );
    await tester.pumpAndSettle();

    // Dialog appears for a real-time (default = now) entry.
    expect(find.text('Sei al distributore adesso?'), findsOneWidget);
    await tester.tap(find.text('Sì'));
    await tester.pumpAndSettle();

    expect(find.text('Eni Corso Francia'), findsWidgets);
  });

  testWidgets('no dialog for a back-dated entry', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await _seed(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          locationServiceProvider.overrideWithValue(
            _FixedLocation(const GeoPoint(45.07, 7.68)),
          ),
        ],
        child: MaterialApp(
          home: FillUpFormScreen(
            vehicleId: 1,
            initialDate: DateTime(2026).subtract(const Duration(days: 3)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sei al distributore adesso?'), findsNothing);
  });
}
