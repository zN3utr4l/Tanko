import 'package:flutter/material.dart';

const _garagePaper = Color(0xFFF4F6F3);
const _surface = Color(0xFFFFFFFF);
const _ink = Color(0xFF14201E);
const _instrumentTeal = Color(0xFF006C67);
const _fuelTeal = Color(0xFF00A896);
const _serviceAmber = Color(0xFFE2A100);
const _graphite = Color(0xFF22302D);

ThemeData appTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: _instrumentTeal,
        brightness: brightness,
      ).copyWith(
        primary: _instrumentTeal,
        onPrimary: Colors.white,
        secondary: _fuelTeal,
        tertiary: _serviceAmber,
        onTertiary: const Color(0xFF251A00),
        surface: isDark ? _graphite : _surface,
        onSurface: isDark ? const Color(0xFFEAF1EE) : _ink,
        outline: isDark ? const Color(0xFF64736F) : const Color(0xFFC9D4D0),
      );
  final scaffold = isDark ? const Color(0xFF111816) : _garagePaper;
  final card = isDark ? const Color(0xFF1A2522) : _surface;
  final border = isDark ? const Color(0xFF31403C) : const Color(0xFFDCE5E1);

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: scaffold,
    appBarTheme: AppBarTheme(
      backgroundColor: scaffold,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: border),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: card,
      indicatorColor: _instrumentTeal.withValues(alpha: 0.14),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? _instrumentTeal
              : scheme.onSurfaceVariant,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        backgroundColor: _instrumentTeal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _serviceAmber,
      foregroundColor: Color(0xFF251A00),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF14201E) : const Color(0xFFF9FBF8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: _instrumentTeal, width: 1.6),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _instrumentTeal.withValues(alpha: 0.10),
      selectedColor: _instrumentTeal.withValues(alpha: 0.18),
      labelStyle: TextStyle(color: scheme.onSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: border),
    ),
    dividerTheme: DividerThemeData(color: border, thickness: 1),
  );
}
