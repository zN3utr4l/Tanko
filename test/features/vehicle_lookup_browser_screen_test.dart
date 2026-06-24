import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/features/vehicles/vehicle_lookup_browser_screen.dart';

void main() {
  test('lookup browser requests a mobile viewport', () {
    expect(vehicleLookupMobileUserAgent, contains('Mobile'));
    expect(vehicleLookupMobileUserAgent, isNot(contains('Windows')));
    expect(vehicleLookupMobileUserAgent, isNot(contains('Macintosh')));
    expect(vehicleLookupViewportScript, contains('width=device-width'));
    expect(vehicleLookupViewportScript, contains('initial-scale=1'));
  });
}
