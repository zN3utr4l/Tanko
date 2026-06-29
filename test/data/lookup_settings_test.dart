import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carburo/src/data/settings/lookup_settings.dart';

void main() {
  test(
    'lookup settings default to local-first network opt-in behavior',
    () async {
      SharedPreferences.setMockInitialValues({});

      final settings = await const LookupSettingsStore().load();

      expect(settings.vehicleOnlineLookupEnabled, isFalse);
      expect(settings.stationOnlineLookupEnabled, isTrue);
      expect(settings.updateChecksEnabled, isTrue);
      expect(settings.reminderNotificationsEnabled, isFalse);
      expect(settings.openApiKey, isEmpty);
    },
  );

  test('lookup settings persist toggles and API key', () async {
    SharedPreferences.setMockInitialValues({});
    const store = LookupSettingsStore();

    await store.save(
      const LookupSettings(
        vehicleOnlineLookupEnabled: true,
        stationOnlineLookupEnabled: false,
        updateChecksEnabled: false,
        reminderNotificationsEnabled: true,
        openApiKey: 'secret',
      ),
    );

    final settings = await store.load();
    expect(settings.vehicleOnlineLookupEnabled, isTrue);
    expect(settings.stationOnlineLookupEnabled, isFalse);
    expect(settings.updateChecksEnabled, isFalse);
    expect(settings.reminderNotificationsEnabled, isTrue);
    expect(settings.openApiKey, 'secret');
  });
}
