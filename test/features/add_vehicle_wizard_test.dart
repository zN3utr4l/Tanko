import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanko/src/data/repositories/vehicle_repository_impl.dart';
import 'package:tanko/src/domain/models/catalog.dart';
import 'package:tanko/src/domain/models/enums.dart';
import 'package:tanko/src/domain/repositories/catalog_repository.dart';
import 'package:tanko/src/features/vehicles/add_vehicle_wizard_screen.dart';
import 'package:tanko/src/providers.dart';
import '../helpers/test_db.dart';

class _FakeCatalog implements CatalogRepository {
  @override
  Future<List<CatalogMake>> makes() async => const [
    CatalogMake(id: 'renault', name: 'Renault'),
  ];

  @override
  Future<List<String>> models(String makeId) async => const ['Clio'];

  @override
  Future<List<CatalogTrim>> trims(String makeId, String model) async => const [
    CatalogTrim(
      modelId: '1',
      make: 'renault',
      model: 'Clio',
      year: 2023,
      trim: 'E-Tech 145',
      fuelType: FuelType.hybrid,
      consumptionL100: 4.2,
      tankCapacityL: 39,
      powerPs: 145,
    ),
  ];
}

void main() {
  testWidgets(
    'renders catalog make dropdown and saves a manually-typed vehicle',
    (tester) async {
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

      expect(find.text('Marca (catalogo)'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Marca'),
        'Fiat',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Modello'),
        'Panda',
      );
      await tester.scrollUntilVisible(
        find.text('Salva'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Salva'));
      await tester.pumpAndSettle();

      final vehicles = await VehicleRepositoryImpl(db).all();
      expect(vehicles, hasLength(1));
      expect(vehicles.single.make, 'Fiat');
      expect(vehicles.single.specs.source, SpecSource.manual);
    },
  );
}
