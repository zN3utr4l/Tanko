import '../models/detected_station.dart';

/// Outcome of a diagnostic [StationLookupService.probe]: how many stations were
/// returned and, if the lookup failed, a short human reason. [error] is null on
/// success — including the legitimate "0 stations in this area" case, which is
/// distinct from a timeout or network failure.
class StationProbeResult {
  const StationProbeResult({required this.count, this.error});

  final int count;
  final String? error;

  bool get ok => error == null;
}

/// Online lookup of fuel stations near a point (used only on explicit request).
/// Returns an empty list on network failure. Never throws.
abstract class StationLookupService {
  Future<List<DetectedStation>> nearby(
    double latitude,
    double longitude, {
    double radiusMeters,
  });

  /// Diagnostic-only probe that, unlike [nearby], distinguishes a genuine empty
  /// result from a timeout/network error. The default implementation wraps
  /// [nearby] (so it can never report an error); concrete implementations
  /// override it to surface the real failure reason.
  Future<StationProbeResult> probe(
    double latitude,
    double longitude, {
    double radiusMeters = 3000,
  }) async {
    final rows = await nearby(latitude, longitude, radiusMeters: radiusMeters);
    return StationProbeResult(count: rows.length);
  }
}
