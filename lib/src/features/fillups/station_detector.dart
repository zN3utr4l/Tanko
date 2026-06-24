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
    required this.location,
    required this.fillUps,
    required this.matcher,
    required this.lookup,
    required this.ocr,
    required this.receiptParser,
  });

  final LocationService location;
  final FillUpRepository fillUps;
  final StationMatcher matcher;
  final StationLookupService lookup;
  final OcrService ocr;
  final ReceiptParser receiptParser;

  Future<StationDetection> detect() async {
    final pos = await location.current();
    if (pos == null) return const StationDetection();
    final history = await fillUps.all();
    final match = matcher.match(
      latitude: pos.latitude,
      longitude: pos.longitude,
      history: history,
    );
    return StationDetection(position: pos, match: match);
  }

  Future<List<DetectedStation>> lookupOnline(GeoPoint at) =>
      lookup.nearby(at.latitude, at.longitude);

  Future<ReceiptData> readReceipt(String imagePath) async {
    final lines = await ocr.readLines(imagePath);
    return receiptParser.parse(lines);
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
