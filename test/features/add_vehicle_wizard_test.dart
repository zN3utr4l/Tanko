import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/domain/models/catalog.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/repositories/catalog_repository.dart';
import 'package:carburo/src/features/vehicles/add_vehicle_wizard_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

class _FakeCatalog implements CatalogRepository {
  @override
  Future<List<String>> makes() async => const ['Fiat', 'Renault'];

  @override
  Future<List<CatalogModel>> models(String make) async =>
      make.toLowerCase() == 'fiat'
      ? const [
          CatalogModel(
            make: 'Fiat',
            name: 'Panda',
            fuelType: FuelType.petrol,
            consumptionL100: 5.7,
            tankCapacityL: 37,
            powerPs: 70,
          ),
        ]
      : const [];
}

void main() {
  testWidgets('saves a typed-in vehicle (not in catalog) as manual', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          catalogRepositoryProvider.overrideWithValue(_FakeCatalog()),
        ],
        child: const MaterialApp(home: AddVehicleWizardScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Marca'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Marca'),
      'Tesla',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Modello'),
      'Model 3',
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Salva'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Salva'));
    await tester.pumpAndSettle();

    final vehicles = await VehicleRepositoryImpl(db).all();
    expect(vehicles, hasLength(1));
    expect(vehicles.single.make, 'Tesla');
    expect(vehicles.single.model, 'Model 3');
    expect(vehicles.single.specs.source, SpecSource.manual);
  });
}
