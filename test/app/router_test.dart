import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:carburo/src/app/app.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  // App runs with locale 'it_IT'; mirror main()'s date-symbol initialization.
  setUpAll(() async {
    Intl.defaultLocale = 'it_IT';
    await initializeDateFormatting('it_IT');
  });

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
