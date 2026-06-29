import 'package:shared_preferences/shared_preferences.dart';

class LookupSettings {
  const LookupSettings({
    this.vehicleOnlineLookupEnabled = false,
    this.stationOnlineLookupEnabled = true,
    this.updateChecksEnabled = true,
    this.reminderNotificationsEnabled = false,
    this.openApiKey = '',
  });

  final bool vehicleOnlineLookupEnabled;
  final bool stationOnlineLookupEnabled;
  final bool updateChecksEnabled;
  final bool reminderNotificationsEnabled;
  final String openApiKey;

  LookupSettings copyWith({
    bool? vehicleOnlineLookupEnabled,
    bool? stationOnlineLookupEnabled,
    bool? updateChecksEnabled,
    bool? reminderNotificationsEnabled,
    String? openApiKey,
  }) {
    return LookupSettings(
      vehicleOnlineLookupEnabled:
          vehicleOnlineLookupEnabled ?? this.vehicleOnlineLookupEnabled,
      stationOnlineLookupEnabled:
          stationOnlineLookupEnabled ?? this.stationOnlineLookupEnabled,
      updateChecksEnabled: updateChecksEnabled ?? this.updateChecksEnabled,
      reminderNotificationsEnabled:
          reminderNotificationsEnabled ?? this.reminderNotificationsEnabled,
      openApiKey: openApiKey ?? this.openApiKey,
    );
  }
}

class LookupSettingsStore {
  const LookupSettingsStore();

  static const _vehicleLookup = 'lookup.vehicle_online_enabled';
  static const _stationLookup = 'lookup.station_online_enabled';
  static const _updates = 'lookup.update_checks_enabled';
  static const _reminderNotifications = 'lookup.reminder_notifications_enabled';
  static const _openApiKey = 'lookup.openapi_key';

  Future<LookupSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return LookupSettings(
      vehicleOnlineLookupEnabled: prefs.getBool(_vehicleLookup) ?? false,
      stationOnlineLookupEnabled: prefs.getBool(_stationLookup) ?? true,
      updateChecksEnabled: prefs.getBool(_updates) ?? true,
      reminderNotificationsEnabled:
          prefs.getBool(_reminderNotifications) ?? false,
      openApiKey: prefs.getString(_openApiKey) ?? '',
    );
  }

  Future<void> save(LookupSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vehicleLookup, settings.vehicleOnlineLookupEnabled);
    await prefs.setBool(_stationLookup, settings.stationOnlineLookupEnabled);
    await prefs.setBool(_updates, settings.updateChecksEnabled);
    await prefs.setBool(
      _reminderNotifications,
      settings.reminderNotificationsEnabled,
    );
    await prefs.setString(_openApiKey, settings.openApiKey.trim());
  }
}
