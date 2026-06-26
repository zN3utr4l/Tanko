import 'package:drift/drift.dart';
import 'tables.dart';
import 'connection.dart';

part 'database.g.dart';

/// Seeded expense categories (Italian), kind='expense'. (name, color, iconCode).
const _expenseCategorySeed = <(String, int, int)>[
  ('Assicurazione', 0xFF1565C0, 0xe1a7), // shield
  ('Bollo', 0xFF6A1B9A, 0xe53b), // receipt_long
  ('Revisione', 0xFF00838F, 0xe8e8), // build
  ('Multe', 0xFFC62828, 0xe002), // warning
  ('Pedaggi', 0xFF2E7D32, 0xe57f), // toll-ish (local_atm fallback)
  ('Parcheggio', 0xFF455A64, 0xe54f), // local_parking
  ('Autolavaggio', 0xFF0277BD, 0xe798), // local_car_wash
  ('Accessori', 0xFFEF6C00, 0xe8cc), // shopping
  ('Riparazioni', 0xFF5D4037, 0xe869), // car_repair
  ('Altro', 0xFF757575, 0xe619), // more_horiz
];

@DriftDatabase(tables: [Categories, Vehicles, Reminders, Expenses, FillUps])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedFuelCategories();
      await _seedExpenseCategories();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(categories, categories.kind);
        await m.addColumn(categories, categories.iconCode);
        await m.addColumn(categories, categories.ord);
        // Existing rows are fuel categories. The column default already sets
        // 'fuel'; this is an explicit safety backfill.
        await customStatement("UPDATE categories SET kind = 'fuel'");
        await m.createTable(reminders);
        await m.createTable(expenses);
        await _seedExpenseCategories();
      }
      if (from < 3) {
        // Store the Euro emission class on the vehicle (for the bollo calc).
        await m.addColumn(vehicles, vehicles.euroClass);
      }
      if (from < 4) {
        // Localize the default fuel categories to Italian. Only rows still
        // bearing the exact English seed names are renamed, so any user
        // rename is preserved.
        await customStatement(
          "UPDATE categories SET name = 'Mie' "
          "WHERE name = 'Mine' AND kind = 'fuel'",
        );
        await customStatement(
          "UPDATE categories SET name = 'Non mie' "
          "WHERE name = 'Not mine' AND kind = 'fuel'",
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _seedFuelCategories() async {
    await into(categories).insert(
      CategoriesCompanion.insert(
        name: 'Mie',
        color: 0xFF4CAF50,
        isDefault: const Value(true),
      ),
    );
    await into(
      categories,
    ).insert(CategoriesCompanion.insert(name: 'Non mie', color: 0xFF9E9E9E));
  }

  Future<void> _seedExpenseCategories() async {
    for (var i = 0; i < _expenseCategorySeed.length; i++) {
      final (name, color, icon) = _expenseCategorySeed[i];
      await into(categories).insert(
        CategoriesCompanion.insert(
          name: name,
          color: color,
          kind: const Value('expense'),
          iconCode: Value(icon),
          ord: Value(i),
        ),
      );
    }
  }
}
