import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/services/geo.dart';

void main() {
  test('distance between identical points is zero', () {
    expect(haversineMeters(45.07, 7.68, 45.07, 7.68), closeTo(0, 1e-6));
  });

  test('0.001 deg of latitude is about 111 m', () {
    expect(haversineMeters(45.0, 7.0, 45.001, 7.0), closeTo(111.2, 1.0));
  });

  test('symmetric', () {
    final a = haversineMeters(45.0, 7.0, 45.02, 7.03);
    final b = haversineMeters(45.02, 7.03, 45.0, 7.0);
    expect(a, closeTo(b, 1e-6));
  });
}
