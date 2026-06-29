import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:carburo/src/data/database/database.dart';
import '../helpers/test_db.dart';

void _createCategoriesTableV2(Database raw) {
  // categories at v2: kind/icon_code/ord were added on top of the v1 shape.
  raw.execute(
    'CREATE TABLE categories (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
    'name TEXT NOT NULL, color INTEGER NOT NULL, '
    'is_default INTEGER NOT NULL DEFAULT 0, '
    "kind TEXT NOT NULL DEFAULT 'fuel', "
    'icon_code INTEGER, ord INTEGER NOT NULL DEFAULT 0);',
  );
}

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
      expect(fuel.map((c) => c.name), containsAll(['Mie', 'Non mie']));
      expect(expense, hasLength(14));
      expect(
        expense.map((c) => c.name),
        containsAll([
          'Assicurazione',
          'Tagliando',
          'Cambio gomme',
          'Inversione gomme',
          'Manutenzione straordinaria',
          'Autolavaggio',
        ]),
      );
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
      // Seeded as 'Mine' at v1; renamed to 'Mie' by the v3->v4 migration.
      final mine = cats.firstWhere((c) => c.name == 'Mie');
      expect(mine.kind, 'fuel'); // backfilled
      expect(
        cats.where((c) => c.kind == 'expense'),
        hasLength(14),
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
      _createCategoriesTableV2(raw); // a real v2 DB has this; v3->v4 touches it
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

  test(
    'onUpgrade 3->4 renames English default fuel categories to Italian, '
    'preserving user-renamed categories',
    () async {
      final dir = Directory.systemTemp.createTempSync('carburo_mig4');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File('${dir.path}/v3.sqlite');

      // v3 categories table is the same shape as v2 (no further DDL at v3).
      final raw = sqlite3.open(file.path);
      _createCategoriesTableV2(raw);
      raw.execute(
        "INSERT INTO categories (name, color, is_default, kind) "
        "VALUES ('Mine', 1, 1, 'fuel');",
      );
      raw.execute(
        "INSERT INTO categories (name, color, is_default, kind) "
        "VALUES ('Not mine', 2, 0, 'fuel');",
      );
      // A category the user renamed must NOT be touched by the migration.
      raw.execute(
        "INSERT INTO categories (name, color, is_default, kind) "
        "VALUES ('Lavoro', 3, 0, 'fuel');",
      );
      raw.execute('PRAGMA user_version = 3;');
      raw.close();

      final db = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(db.close);

      final names = (await db.select(db.categories).get())
          .map((c) => c.name)
          .toList();
      expect(names, containsAll(['Mie', 'Non mie', 'Lavoro']));
      expect(names, isNot(contains('Mine')));
      expect(names, isNot(contains('Not mine')));
    },
  );

  test('onUpgrade 4->5 adds missing canonical expense categories once', () async {
    final dir = Directory.systemTemp.createTempSync('carburo_mig5');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/v4.sqlite');

    final raw = sqlite3.open(file.path);
    _createCategoriesTableV2(raw);
    raw.execute(
      "INSERT INTO categories (name, color, is_default, kind, icon_code, ord) "
      "VALUES ('Autolavaggio', 1, 0, 'expense', 1, 0);",
    );
    raw.execute(
      "INSERT INTO categories (name, color, is_default, kind, icon_code, ord) "
      "VALUES ('Tagliando', 2, 0, 'expense', 2, 1);",
    );
    raw.execute('PRAGMA user_version = 4;');
    raw.close();

    final db = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(db.close);

    final expenses = (await db.select(
      db.categories,
    ).get()).where((c) => c.kind == 'expense').toList();
    final names = expenses.map((c) => c.name).toList();
    expect(names.where((name) => name == 'Tagliando'), hasLength(1));
    expect(names, containsAll(['Cambio gomme', 'Inversione gomme']));
  });
}
