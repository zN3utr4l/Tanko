/// A WGS84 coordinate pair. Plain value type (no codegen).
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}
