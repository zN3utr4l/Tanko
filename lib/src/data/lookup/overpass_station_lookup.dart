import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/detected_station.dart';
import '../../domain/services/station_lookup_service.dart';
import 'overpass_parser.dart';

/// Online fuel-station lookup via the OpenStreetMap Overpass API. No API key.
/// Called only on explicit user request. Returns an empty list on any failure.
class OverpassStationLookup implements StationLookupService {
  OverpassStationLookup({http.Client? client})
    : _client = client ?? http.Client();
  final http.Client _client;

  static const _endpoint = 'https://overpass-api.de/api/interpreter';

  @override
  Future<List<DetectedStation>> nearby(
    double latitude,
    double longitude, {
    double radiusMeters = 150,
  }) async {
    try {
      final query =
          '[out:json][timeout:10];node["amenity"="fuel"](around:$radiusMeters,$latitude,$longitude);out;';
      final resp = await _client
          .post(Uri.parse(_endpoint), body: {'data': query})
          .timeout(const Duration(seconds: 12));
      if (resp.statusCode != 200) return const [];
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return parseOverpassFuelStations(
        json,
        originLat: latitude,
        originLng: longitude,
      );
    } catch (_) {
      return const [];
    }
  }
}
