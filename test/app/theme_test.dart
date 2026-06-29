import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/app/theme.dart';

void main() {
  test('light theme uses the Carburo garage palette', () {
    final theme = appTheme(Brightness.light);

    expect(theme.scaffoldBackgroundColor, const Color(0xFFF4F6F3));
    expect(theme.colorScheme.primary, const Color(0xFF006C67));
    expect(theme.colorScheme.tertiary, const Color(0xFFE2A100));
    expect(theme.appBarTheme.backgroundColor, const Color(0xFFF4F6F3));
    expect(theme.navigationBarTheme.backgroundColor, const Color(0xFFFFFFFF));
  });

  test('component themes keep the app polished and compact', () {
    final theme = appTheme(Brightness.light);

    expect(theme.cardTheme.color, const Color(0xFFFFFFFF));
    expect(theme.cardTheme.elevation, 0);
    expect(
      theme.filledButtonTheme.style?.minimumSize?.resolve({}),
      const Size(64, 48),
    );
    expect(theme.inputDecorationTheme.filled, isTrue);
  });
}
