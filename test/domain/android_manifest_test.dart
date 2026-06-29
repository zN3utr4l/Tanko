import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('release Android manifest declares internet permission', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();

    expect(
      manifest,
      contains('android.permission.INTERNET'),
      reason: 'Release builds need internet for updates and online lookup.',
    );
  });

  test('release Android manifest declares exact alarm permission for reminders', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();

    expect(
      manifest,
      contains('android.permission.SCHEDULE_EXACT_ALARM'),
      reason: 'Deadline reminders use exact allow-while-idle scheduling.',
    );
  });
}
