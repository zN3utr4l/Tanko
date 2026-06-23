import '../models/detected_station.dart';
import '../models/enums.dart';
import '../models/fill_up.dart';
import 'geo.dart';

/// Finds the nearest past fill-up (with coordinates and a station name) within
/// [radiusMeters] of the given point. Pure; "learn from history" matcher.
class StationMatcher {
  const StationMatcher();

  DetectedStation? match({
    required double latitude,
    required double longitude,
    required List<FillUp> history,
    double radiusMeters = 80,
  }) {
    DetectedStation? best;
    var bestDist = double.infinity;
    for (final f in history) {
      final lat = f.latitude;
      final lng = f.longitude;
      final name = f.station;
      if (lat == null || lng == null || name == null || name.trim().isEmpty) {
        continue;
      }
      final d = haversineMeters(latitude, longitude, lat, lng);
      if (d <= radiusMeters && d < bestDist) {
        bestDist = d;
        best = DetectedStation(
          name: name.trim(),
          latitude: lat,
          longitude: lng,
          distanceMeters: d,
          source: StationSource.history,
        );
      }
    }
    return best;
  }
}
