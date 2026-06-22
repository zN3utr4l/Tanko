import 'package:flutter/material.dart';

ThemeData appTheme(Brightness brightness) => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: brightness,
  ),
  useMaterial3: true,
);
