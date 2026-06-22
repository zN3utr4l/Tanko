import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tanko/src/app/app.dart';
import 'package:tanko/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('App boots to dashboard with nav bar', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Calendario'), findsWidgets);
    expect(find.text('Scadenze'), findsWidgets);
  });
}
