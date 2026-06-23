import '../models/detected_station.dart';

/// Online lookup of fuel stations near a point (used only on explicit request).
/// Returns an empty list on network failure. Never throws.
abstract class StationLookupService {
  Future<List<DetectedStation>> nearby(
    double latitude,
    double longitude, {
    double radiusMeters,
  });
}
