import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/data/repositories/vehicle_repository_impl.dart';
import 'package:carburo/src/data/settings/lookup_settings.dart';
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
            trims: [
              CatalogTrim(name: 'Lounge'),
              CatalogTrim(name: '4x4', fuelType: FuelType.petrol, powerPs: 85),
            ],
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

  testWidgets('saves a catalog vehicle with selected allestimento specs', (
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

    await tester.enterText(find.widgetWithText(TextFormField, 'Marca'), 'Fi');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fiat').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Modello'),
      'Pan',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Panda · petrol · 70 CV'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Allestimento'),
      '4',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('4x4 · petrol · 85 CV'));
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
    expect(vehicles.single.make, 'Fiat');
    expect(vehicles.single.model, 'Panda');
    expect(vehicles.single.trim, '4x4');
    expect(vehicles.single.specs.powerPs, 85);
    expect(vehicles.single.specs.source, SpecSource.catalog);
  });

  testWidgets('manual edits after catalog selection save specs as manual', (
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

    await tester.enterText(find.widgetWithText(TextFormField, 'Marca'), 'Fi');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fiat').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Modello'),
      'Pan',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Panda · petrol · 70 CV'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.widgetWithText(TextFormField, 'Potenza (CV)'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Potenza (CV)'),
      '90',
    );
    await tester.scrollUntilVisible(
      find.text('Salva'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Salva'));
    await tester.pumpAndSettle();

    final vehicles = await VehicleRepositoryImpl(db).all();
    expect(vehicles.single.specs.powerPs, 90);
    expect(vehicles.single.specs.source, SpecSource.manual);
  });

  testWidgets('official online lookup buttons follow lookup settings', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          catalogRepositoryProvider.overrideWithValue(_FakeCatalog()),
          lookupSettingsProvider.overrideWith(
            (_) async =>
                const LookupSettings(vehicleOnlineLookupEnabled: false),
          ),
        ],
        child: const MaterialApp(home: AddVehicleWizardScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final rcaButton = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Verifica RCA'),
        matching: find.byType(OutlinedButton),
      ),
    );
    final euroButton = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Classe Euro'),
        matching: find.byType(OutlinedButton),
      ),
    );
    expect(rcaButton.onPressed, isNull);
    expect(euroButton.onPressed, isNull);
    expect(
      find.text('Attiva il lookup veicoli online dalle impostazioni.'),
      findsOneWidget,
    );
  });

  testWidgets('applies pasted online lookup text to vehicle fields', (
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

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Targa'),
      'ab123cd',
    );
    await tester.tap(find.text('Incolla dati verifica'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Dati copiati dalla verifica'),
      '''
Marca: Fiat
Modello: Panda
Allestimento: City Cross
Anno: 2020
Alimentazione: benzina
Classe ambientale: Euro 6
Potenza: 70 CV
''',
    );
    await tester.tap(find.text('Applica'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Marca'), findsOneWidget);
    expect(find.text('Fiat'), findsWidgets);
    expect(find.text('Panda'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Salva'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Salva'));
    await tester.pumpAndSettle();

    final vehicles = await VehicleRepositoryImpl(db).all();
    expect(vehicles.single.plate, 'AB123CD');
    expect(vehicles.single.make, 'Fiat');
    expect(vehicles.single.model, 'Panda');
    expect(vehicles.single.trim, 'City Cross');
    expect(vehicles.single.year, 2020);
    expect(vehicles.single.euroClass, EuroClass.euro6);
    expect(vehicles.single.specs.powerPs, 70);
    expect(vehicles.single.specs.source, SpecSource.online);
  });
}
