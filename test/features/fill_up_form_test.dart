import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/features/fillups/fill_up_form_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('shows live price/L when amount and liters are entered', (
    tester,
  ) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: FillUpFormScreen(vehicleId: 1, initialDate: DateTime(2020)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('amount')), '40');
    await tester.enterText(find.byKey(const Key('liters')), '32');
    await tester.pump();

    expect(find.textContaining('1,25'), findsWidgets); // 40 / 32 = 1.25 €/L
  });

  testWidgets('blocks save when amount is empty', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: FillUpFormScreen(vehicleId: 1, initialDate: DateTime(2020)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salva'));
    await tester.pump();
    expect(find.text('Obbligatorio'), findsWidgets);
  });
}
