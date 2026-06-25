import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/features/stats/widgets/chart_axis.dart';

void main() {
  test('labelIndices shows all when count <= maxLabels', () {
    expect(labelIndices(4, maxLabels: 6), {0, 1, 2, 3});
  });

  test('labelIndices thins evenly when count > maxLabels', () {
    final r = labelIndices(36, maxLabels: 6);
    expect(r.length, lessThanOrEqualTo(6));
    expect(r, contains(0));
    // evenly spaced: step = (36/6).ceil() = 6 -> 0,6,12,18,24,30
    expect(r, containsAll(<int>{0, 6, 12, 18, 24, 30}));
  });
}
