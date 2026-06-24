import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:carburo/src/data/database/database.dart';
import '../helpers/test_db.dart';

void _createVehiclesTableWithoutEuro(Database raw) {
  raw.execute(
    'CREATE TABLE vehicles (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
    'make TEXT NOT NULL, model TEXT NOT NULL, year INTEGER, trim TEXT, '
    'fuel_type TEXT NOT NULL, plate TEXT, '
    'color_tag INTEGER NOT NULL DEFAULT 0, is_default INTEGER NOT NULL DEFAULT 0, '
    'tank_capacity_l REAL, mfr_consumption REAL, mfr_range_km REAL, '
    "power_ps INTEGER, spec_source TEXT NOT NULL DEFAULT 'manual', "
    'catalog_ref TEXT, created_at TEXT NOT NULL, updated_at TEXT NOT NULL);',
  );
}

void main() {
  test(
    'fresh v2 onCreate seeds fuel + expense categories and new tables',
    () async {
      final db = makeTestDb();
      addTearDown(db.close);

      final cats = await db.select(db.categories).get();
      final fuel = cats.where((c) => c.kind == 'fuel').toList();
      final expense = cats.where((c) => c.kind == 'expense').toList();
      expect(fuel.map((c) => c.name), containsAll(['Mine', 'Not mine']));
      expect(expense, hasLength(10));
      expect(expense.map((c) => c.name), contains('Assicurazione'));
      expect(expense.every((c) => c.iconCode != null), isTrue);

      // New tables exist and are empty.
      expect(await db.select(db.reminders).get(), isEmpty);
      expect(await db.select(db.expenses).get(), isEmpty);
    },
  );

  test(
    'onUpgrade 1->2 backfills kind, adds tables, seeds expense categories',
    () async {
      final dir = Directory.systemTemp.createTempSync('carburo_mig');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File('${dir.path}/v1.sqlite');

      // Hand-build a minimal v1 schema (drift snake_cases column names).
      final raw = sqlite3.open(file.path);
      raw.execute(
        'CREATE TABLE categories (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
        'name TEXT NOT NULL, color INTEGER NOT NULL, '
        'is_default INTEGER NOT NULL DEFAULT 0);',
      );
      raw.execute(
        "INSERT INTO categories (name, color, is_default) VALUES ('Mine', 1, 1);",
      );
      _createVehiclesTableWithoutEuro(raw);
      raw.execute('PRAGMA user_version = 1;');
      raw.close();

      final db = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(db.close);

      final cats = await db.select(db.categories).get();
      final mine = cats.firstWhere((c) => c.name == 'Mine');
      expect(mine.kind, 'fuel'); // backfilled
      expect(
        cats.where((c) => c.kind == 'expense'),
        hasLength(10),
      ); // seeded on upgrade
      expect(await db.select(db.reminders).get(), isEmpty); // table created
      expect(await db.select(db.expenses).get(), isEmpty); // table created
    },
  );

  test(
    'onUpgrade 2->3 adds vehicles.euroClass and preserves existing rows',
    () async {
      final dir = Directory.systemTemp.createTempSync('carburo_mig3');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File('${dir.path}/v2.sqlite');

      // Minimal v2 vehicles table (no euroClass yet). Dates are TEXT because
      // store_date_time_values_as_text is on (see build.yaml).
      final raw = sqlite3.open(file.path);
      _createVehiclesTableWithoutEuro(raw);
      raw.execute(
        "INSERT INTO vehicles (make, model, fuel_type, power_ps, created_at, updated_at) "
        "VALUES ('Fiat', 'Panda', 'petrol', 70, "
        "'2026-01-01T00:00:00.000', '2026-01-01T00:00:00.000');",
      );
      raw.execute('PRAGMA user_version = 2;');
      raw.close();

      final db = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(db.close);

      final vehicles = await db.select(db.vehicles).get();
      expect(vehicles, hasLength(1)); // existing row survived
      expect(vehicles.single.make, 'Fiat');
      expect(vehicles.single.powerPs, 70);
      expect(vehicles.single.euroClass, isNull); // new nullable column
    },
  );
}
