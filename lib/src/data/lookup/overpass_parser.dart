import '../../domain/models/detected_station.dart';
import '../../domain/models/enums.dart';
import '../../domain/services/geo.dart';

/// Maps an Overpass `[out:json]` response of `amenity=fuel` nodes into
/// [DetectedStation]s, sorted nearest-first. Nodes without a usable name are
/// dropped. Pure.
List<DetectedStation> parseOverpassFuelStations(
  Map<String, dynamic> json, {
  required double originLat,
  required double originLng,
}) {
  final elements = (json['elements'] as List?) ?? const [];
  final out = <DetectedStation>[];
  for (final e in elements) {
    if (e is! Map) continue;
    final lat = (e['lat'] as num?)?.toDouble();
    final lng = (e['lon'] as num?)?.toDouble();
    if (lat == null || lng == null) continue;
    final tags = (e['tags'] as Map?) ?? const {};
    final name = (tags['name'] ?? tags['brand'] ?? tags['operator'])
        ?.toString();
    if (name == null || name.trim().isEmpty) continue;
    out.add(
      DetectedStation(
        name: name.trim(),
        latitude: lat,
        longitude: lng,
        distanceMeters: haversineMeters(originLat, originLng, lat, lng),
        source: StationSource.online,
      ),
    );
  }
  out.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
  return out;
}
