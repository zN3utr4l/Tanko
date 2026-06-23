import '../models/geo_point.dart';

/// Current device location, best-effort. Returns null on denial / GPS off /
/// timeout — callers must degrade gracefully.
abstract class LocationService {
  Future<GeoPoint?> current();
}
