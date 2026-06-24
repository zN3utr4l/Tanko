import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/vehicle.dart';
import 'package:carburo/src/features/vehicles/vehicle_form_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('vehicle edit form saves plate, year, trim and specs', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    final repo = VehicleRepositoryImpl(db);
    final id = await repo.upsert(
      Vehicle(
        id: 0,
        make: 'Fiat',
        model: 'Panda',
        year: 2019,
        trim: 'Easy',
        fuelType: FuelType.petrol,
        plate: 'AA000AA',
        euroClass: EuroClass.euro6,
        specs: const VehicleSpecs(
          tankCapacityL: 37,
          mfrConsumption: 5.7,
          powerPs: 70,
          source: SpecSource.catalog,
        ),
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    final initial = await repo.getById(id);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(home: VehicleFormScreen(initial: initial)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Targa'),
      'bb111bb',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Allestimento'),
      'Lounge',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Consumo dichiarato (L/100km)'),
      '6,1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Potenza (CV)'),
      '75',
    );
    await tester.scrollUntilVisible(
      find.text('Salva'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Salva'));
    await tester.pumpAndSettle();

    final saved = await repo.getById(id);
    expect(saved.plate, 'BB111BB');
    expect(saved.trim, 'Lounge');
    expect(saved.specs.mfrConsumption, 6.1);
    expect(saved.specs.powerPs, 75);
    expect(saved.specs.source, SpecSource.manual);
  });
}
