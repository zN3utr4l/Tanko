import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/providers.dart';
import 'helpers/test_db.dart';

void main() {
  test('repositories resolve and category seed is reachable', () async {
    final db = makeTestDb();
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    final cats = await container.read(categoryRepositoryProvider).all();
    // Seeded fuel categories + the expense categories.
    expect(
      cats.where((c) => c.name == 'Mie' || c.name == 'Non mie'),
      hasLength(2),
    );
    expect(cats.length, greaterThan(2));
  });
}
