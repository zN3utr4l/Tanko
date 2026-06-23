import 'package:carburo/src/data/update/update_prefs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('lastCheck is null before any markChecked', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await const UpdatePrefs().lastCheck(), isNull);
  });

  test('markChecked then lastCheck round-trips the timestamp', () async {
    SharedPreferences.setMockInitialValues({});
    const prefs = UpdatePrefs();
    final when = DateTime(2026, 6, 23, 12);

    await prefs.markChecked(when);

    expect(await prefs.lastCheck(), when);
  });
}
