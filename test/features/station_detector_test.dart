import 'package:flutter_test/flutter_test.dart';
import 'package:carburo/src/domain/models/detected_station.dart';
import 'package:carburo/src/domain/models/enums.dart';
import 'package:carburo/src/domain/models/fill_up.dart';
import 'package:carburo/src/domain/models/geo_point.dart';
import 'package:carburo/src/domain/repositories/fill_up_repository.dart';
import 'package:carburo/src/domain/services/location_service.dart';
import 'package:carburo/src/domain/services/ocr_service.dart';
import 'package:carburo/src/domain/services/receipt_parser.dart';
import 'package:carburo/src/domain/services/station_lookup_service.dart';
import 'package:carburo/src/domain/services/station_matcher.dart';
import 'package:carburo/src/features/fillups/station_detector.dart';

class _FixedLocation implements LocationService {
  _FixedLocation(this._point);
  final GeoPoint? _point;
  @override
  Future<GeoPoint?> current() async => _point;
}

class _FakeRepo implements FillUpRepository {
  _FakeRepo(this._all);
  final List<FillUp> _all;
  @override
  Future<List<FillUp>> all() async => _all;
  @override
  Future<List<FillUp>> forVehicle(int vehicleId) async => _all;
  @override
  Future<int> upsert(FillUp fillUp) async => 0;
  @override
  Future<void> delete(int id) async {}
}

class _FakeOcr implements OcrService {
  _FakeOcr(this._lines);
  final List<String> _lines;
  @override
  Future<List<String>> readLines(String imagePath) async => _lines;
}

class _EmptyLookup implements StationLookupService {
  @override
  Future<List<DetectedStation>> nearby(
    double lat,
    double lng, {
    double radiusMeters = 150,
  }) async => const [];
}

FillUp _fill({double? lat, double? lng, String? station}) => FillUp(
  id: 1,
  vehicleId: 1,
  date: DateTime(2026),
  amount: 50,
  liters: 30,
  odometer: 1000,
  categoryId: 1,
  latitude: lat,
  longitude: lng,
  station: station,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

StationDetector _detector({
  GeoPoint? at,
  List<FillUp> history = const [],
  List<String> ocrLines = const [],
}) => StationDetector(
  location: _FixedLocation(at),
  fillUps: _FakeRepo(history),
  matcher: const StationMatcher(),
  lookup: _EmptyLookup(),
  ocr: _FakeOcr(ocrLines),
  receiptParser: const ReceiptParser(),
);

void main() {
  test('detect() matches a known station from history', () async {
    final d = _detector(
      at: const GeoPoint(45.07, 7.68),
      history: [_fill(lat: 45.07, lng: 7.68, station: 'Eni')],
    );
    final result = await d.detect();
    expect(result.position, isNotNull);
    expect(result.match?.name, 'Eni');
    expect(result.match?.source, StationSource.history);
  });

  test('detect() with no GPS returns empty result', () async {
    final result = await _detector(at: null).detect();
    expect(result.position, isNull);
    expect(result.match, isNull);
  });

  test(
    'detect() with GPS but no nearby history returns position, null match',
    () async {
      final result = await _detector(at: const GeoPoint(45.07, 7.68)).detect();
      expect(result.position, isNotNull);
      expect(result.match, isNull);
    },
  );

  test('readReceipt() pipes OCR lines through the parser', () async {
    final d = _detector(ocrLines: ['ENI', 'IMPORTO EURO 50,99']);
    final data = await d.readReceipt('/tmp/x.jpg');
    expect(data.station, 'Eni');
    expect(data.amount, closeTo(50.99, 1e-9));
  });

  group('shouldOfferDetection', () {
    final now = DateTime(2026, 6, 23, 14, 30);
    test('true when the entry date is now', () {
      expect(shouldOfferDetection(now, now), isTrue);
    });
    test('true within 5 minutes', () {
      expect(
        shouldOfferDetection(now.subtract(const Duration(minutes: 3)), now),
        isTrue,
      );
    });
    test('false for a back-dated entry', () {
      expect(
        shouldOfferDetection(now.subtract(const Duration(days: 3)), now),
        isFalse,
      );
    });
  });
}
