import 'package:shared_preferences/shared_preferences.dart';

class UpdatePrefs {
  const UpdatePrefs();

  static const _lastCheckKey = 'last_update_check';

  Future<DateTime?> lastCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final milliseconds = prefs.getInt(_lastCheckKey);
    if (milliseconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  Future<void> markChecked(DateTime when) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastCheckKey, when.millisecondsSinceEpoch);
  }
}
