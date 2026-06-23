import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/detected_station.dart';
import '../../domain/models/geo_point.dart';
import '../../domain/models/receipt_data.dart';
import '../../domain/repositories/fill_up_repository.dart';
import '../../domain/services/location_service.dart';
import '../../domain/services/ocr_service.dart';
import '../../domain/services/receipt_parser.dart';
import '../../domain/services/station_lookup_service.dart';
import '../../domain/services/station_matcher.dart';
import '../../providers.dart';

part 'station_detector.g.dart';

/// Result of one GPS detection attempt.
class StationDetection {
  const StationDetection({this.position, this.match});
  final GeoPoint? position;
  final DetectedStation? match;
}

/// Should the form offer auto-detection? Only for real-time entries — within
/// 5 minutes of now. Back-dated fill-ups never trigger GPS.
bool shouldOfferDetection(DateTime entryDate, DateTime now) =>
    entryDate.difference(now).abs() <= const Duration(minutes: 5);

/// Orchestrates GPS history-matching, optional online lookup, and receipt OCR.
class StationDetector {
  StationDetector({
    required LocationService location,
    required FillUpRepository fillUps,
    required StationMatcher matcher,
    required StationLookupService lookup,
    required OcrService ocr,
    required ReceiptParser receiptParser,
  })  : _location = location,
        _fillUps = fillUps,
        _matcher = matcher,
        _lookup = lookup,
        _ocr = ocr,
        _receiptParser = receiptParser;

  final LocationService _location;
  final FillUpRepository _fillUps;
  final StationMatcher _matcher;
  final StationLookupService _lookup;
  final OcrService _ocr;
  final ReceiptParser _receiptParser;

  Future<StationDetection> detect() async {
    final pos = await _location.current();
    if (pos == null) return const StationDetection();
    final history = await _fillUps.all();
    final match = _matcher.match(
      latitude: pos.latitude,
      longitude: pos.longitude,
      history: history,
    );
    return StationDetection(position: pos, match: match);
  }

  Future<List<DetectedStation>> lookupOnline(GeoPoint at) =>
      _lookup.nearby(at.latitude, at.longitude);

  Future<ReceiptData> readReceipt(String imagePath) async {
    final lines = await _ocr.readLines(imagePath);
    return _receiptParser.parse(lines);
  }
}

@riverpod
StationDetector stationDetector(Ref ref) => StationDetector(
      location: ref.watch(locationServiceProvider),
      fillUps: ref.watch(fillUpRepositoryProvider),
      matcher: const StationMatcher(),
      lookup: ref.watch(stationLookupServiceProvider),
      ocr: ref.watch(ocrServiceProvider),
      receiptParser: const ReceiptParser(),
    );
