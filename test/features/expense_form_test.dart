import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carburo/src/features/expenses/expense_form_screen.dart';
import 'package:carburo/src/providers.dart';
import '../helpers/test_db.dart';

void main() {
  testWidgets('expense form uses separated input sections', (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: ExpenseFormScreen(vehicleId: 1, initialDate: DateTime(2020)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('expense-main-section')), findsOneWidget);
    expect(find.byKey(const Key('expense-details-section')), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('expense-attachments-section')),
      findsOneWidget,
    );
  });
}
