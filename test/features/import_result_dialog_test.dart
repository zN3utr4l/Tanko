import 'package:carburo/src/domain/models/import_result.dart';
import 'package:carburo/src/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'import result dialog OK dismisses the dialog, not the screen, under a '
    'nested (per-tab) navigator',
    (tester) async {
      // Mirrors the app shell: a nested Navigator (the tab branch) onto which
      // Settings is pushed. showDialog defaults to the root navigator, so OK
      // must pop the dialog's own route, never the branch navigator.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Navigator(
              onGenerateRoute: (_) => MaterialPageRoute(
                builder: (branchContext) => Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(branchContext).push(
                      MaterialPageRoute(
                        builder: (settingsContext) => Scaffold(
                          body: Center(
                            child: ElevatedButton(
                              onPressed: () => showImportResultDialog(
                                settingsContext,
                                const ImportResult(skipped: 1),
                              ),
                              child: const Text('import'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: const Text('to-settings'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('to-settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('import'));
      await tester.pumpAndSettle();
      expect(find.text('Import completato'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Import completato'), findsNothing); // dialog dismissed
      expect(find.text('import'), findsOneWidget); // settings screen still up
    },
  );

  testWidgets('lists the per-row skip reasons so the user can fix the source', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showImportResultDialog(
                  context,
                  const ImportResult(
                    skipped: 2,
                    duplicates: 1,
                    warnings: [
                      'Riga 5: data 20205 non valida, saltata.',
                      'Riga 8: rifornimento duplicato, saltato.',
                    ],
                  ),
                ),
                child: const Text('import'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('import'));
    await tester.pumpAndSettle();

    expect(find.text('Dettaglio (2):'), findsOneWidget);
    expect(
      find.text('• Riga 5: data 20205 non valida, saltata.'),
      findsOneWidget,
    );
    expect(
      find.text('• Riga 8: rifornimento duplicato, saltato.'),
      findsOneWidget,
    );
  });
}
