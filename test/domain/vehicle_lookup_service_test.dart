import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/services/vehicle_lookup_service.dart';

void main() {
  const service = VehicleLookupService();

  test('normalizes Italian plates for storage and lookup', () {
    expect(service.normalizePlate(' ab 123 cd '), 'AB123CD');
    expect(service.normalizePlate('aa-000-bb'), 'AA000BB');
  });

  test('parses pasted vehicle text into editable lookup data', () {
    final data = service.parsePastedText('''
Targa: ab123cd
Marca: Fiat
Modello: Panda
Allestimento: City Cross
Anno immatricolazione: 2020
Alimentazione: benzina
Classe ambientale: Euro 6
Potenza: 70 CV
Assicurazione: Generali
Scadenza assicurazione: 31/12/2026
''');

    expect(data.plate, 'AB123CD');
    expect(data.make, 'Fiat');
    expect(data.model, 'Panda');
    expect(data.trim, 'City Cross');
    expect(data.year, 2020);
    expect(data.fuelType, FuelType.petrol);
    expect(data.euroClass, EuroClass.euro6);
    expect(data.powerPs, 70);
    expect(data.insuranceCompany, 'Generali');
    expect(data.insuranceExpiry, DateTime(2026, 12, 31));
  });

  test('parses copied header table into editable lookup data', () {
    final data = service.parsePastedText('''
Targa\tMarca\tModello\tAllestimento\tAnno immatricolazione\tAlimentazione\tClasse ambientale\tPotenza
ab123cd\tFiat\tPanda\tCity Cross\t2020\tBenzina\tEuro 6\t51 kW
''');

    expect(data.plate, 'AB123CD');
    expect(data.make, 'Fiat');
    expect(data.model, 'Panda');
    expect(data.trim, 'City Cross');
    expect(data.year, 2020);
    expect(data.fuelType, FuelType.petrol);
    expect(data.euroClass, EuroClass.euro6);
    expect(data.powerPs, 69);
  });

  test('parses copied two-column lookup tables', () {
    final data = service.parsePastedText('''
Marca\tFiat
Modello\tPanda
Allestimento\tCity Cross
Compagnia assicurativa\tGenerali
Scadenza RCA\t31/12/2026
''');

    expect(data.make, 'Fiat');
    expect(data.model, 'Panda');
    expect(data.trim, 'City Cross');
    expect(data.insuranceCompany, 'Generali');
    expect(data.insuranceExpiry, DateTime(2026, 12, 31));
  });

  test('reports recognized fields for paste feedback', () {
    final data = service.parsePastedText('''
Marca: Fiat
Modello: Panda
Allestimento: City Cross
Classe ambientale: Euro 6
''');

    expect(
      data.recognizedFieldLabels,
      containsAll(['Marca', 'Modello', 'Allestimento', 'Classe Euro']),
    );
  });

  test(
    'builds official verification URLs without pretending they are APIs',
    () {
      expect(
        service.insuranceVerificationUri('AB123CD').host,
        'www.ilportaledellautomobilista.it',
      );
      expect(
        service.environmentalClassVerificationUri('AB123CD').path,
        contains('verifica-classe-ambientale-veicolo'),
      );
    },
  );

  test('ignores impossible pasted insurance dates', () {
    final data = service.parsePastedText('Scadenza assicurazione: 31/02/2026');

    expect(data.insuranceExpiry, isNull);
  });
}
