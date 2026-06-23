import 'package:carburo/src/domain/services/bollo_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calc = BolloCalculator();

  test('Euro 6 under 100 kW uses the single base rate', () {
    final r = calc.compute(powerKw: 70, euroClass: EuroClass.euro6);
    expect(r.ordinary, closeTo(70 * 2.58, 1e-9)); // 180.6
    expect(r.superbollo, 0);
    expect(r.total, closeTo(180.6, 1e-9));
  });

  test('over 100 kW splits at 100 kW (base + higher excess rate)', () {
    final r = calc.compute(powerKw: 120, euroClass: EuroClass.euro6);
    expect(r.ordinary, closeTo(100 * 2.58 + 20 * 3.87, 1e-9)); // 335.4
  });

  test('older Euro classes cost more per kW', () {
    expect(
      calc.compute(powerKw: 70, euroClass: EuroClass.euro3).ordinary,
      closeTo(70 * 2.70, 1e-9), // 189
    );
    expect(
      calc.compute(powerKw: 100, euroClass: EuroClass.euro0).ordinary,
      closeTo(100 * 3.00, 1e-9), // 300
    );
  });

  test('superbollo: €20/kW above 185 kW for a new car', () {
    final r = calc.compute(powerKw: 200, euroClass: EuroClass.euro6);
    expect(r.ordinary, closeTo(100 * 2.58 + 100 * 3.87, 1e-9)); // 645
    expect(r.superbollo, closeTo((200 - 185) * 20, 1e-9)); // 300
    expect(r.total, closeTo(945, 1e-9));
  });

  test('exactly 185 kW has no superbollo', () {
    expect(
      calc.compute(powerKw: 185, euroClass: EuroClass.euro6).superbollo,
      0,
    );
  });

  test('superbollo decreases with vehicle age', () {
    double sb(int? age) => calc
        .compute(powerKw: 200, euroClass: EuroClass.euro6, vehicleAgeYears: age)
        .superbollo;
    expect(sb(null), closeTo(15 * 20, 1e-9)); // unknown -> full
    expect(sb(3), closeTo(15 * 20, 1e-9)); // <6 yrs: €20
    expect(sb(7), closeTo(15 * 12, 1e-9)); // 6–10: €12
    expect(sb(12), closeTo(15 * 6, 1e-9)); // 11–15: €6
    expect(sb(18), closeTo(15 * 3, 1e-9)); // 16–20: €3
    expect(sb(25), 0); // >20: exempt
  });

  test('cvToKw converts horsepower to kW', () {
    expect(cvToKw(190), 140); // 190 * 0.7355 = 139.745 -> 140
    expect(cvToKw(0), 0);
  });
}
