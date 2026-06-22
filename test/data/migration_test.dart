import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:tanko/src/data/database/database.dart';
import '../helpers/test_db.dart';

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
      final dir = Directory.systemTemp.createTempSync('tanko_mig');
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
}
