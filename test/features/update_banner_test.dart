import 'package:carburo/src/domain/models/app_release.dart';
import 'package:carburo/src/features/updates/update_banner.dart';
import 'package:carburo/src/features/updates/update_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hidden when no update is available', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: UpdateBanner())),
      ),
    );

    expect(find.byType(MaterialBanner), findsNothing);
  });

  testWidgets('shows version and hides on "Più tardi"', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(availableUpdateProvider.notifier)
        .set(
          const AppRelease(
            version: '0.5.0',
            apkUrl: 'https://example.com/carburo.apk',
            sizeBytes: 0,
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: UpdateBanner())),
      ),
    );

    expect(find.byType(MaterialBanner), findsOneWidget);
    expect(find.textContaining('0.5.0'), findsOneWidget);

    await tester.tap(find.text('Più tardi'));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialBanner), findsNothing);
  });
}
