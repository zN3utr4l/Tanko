import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'src/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The whole app (and its intl-based formatters) is Italian.
  Intl.defaultLocale = 'it_IT';
  await initializeDateFormatting('it_IT');
  runApp(const ProviderScope(child: App()));
}
