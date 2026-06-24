import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/enums.dart';
import '../../domain/services/geo.dart';

class MimitFuelPrice {
  const MimitFuelPrice({
    required this.fuelName,
    required this.price,
    required this.isSelf,
    required this.updatedAt,
  });

  final String fuelName;
  final double price;
  final bool isSelf;
  final DateTime? updatedAt;
}

class MimitFuelStationPriceCandidate {
  const MimitFuelStationPriceCandidate({
    required this.id,
    required this.name,
    required this.brand,
    required this.address,
    required this.city,
    required this.province,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.prices,
    required this.extractedAt,
  });

  final String id;
  final String name;
  final String brand;
  final String address;
  final String city;
  final String province;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final List<MimitFuelPrice> prices;
  final DateTime? extractedAt;

  MimitFuelPrice? bestPriceFor(FuelType fuelType) {
    final names = switch (fuelType) {
      FuelType.petrol || FuelType.hybrid => const ['benzina'],
      FuelType.diesel => const ['gasolio', 'diesel'],
      FuelType.lpg => const ['gpl'],
      FuelType.cng => const ['metano'],
      FuelType.electric => const <String>[],
    };
    if (names.isEmpty) return null;
    final matches = prices.where((p) {
      final name = p.fuelName.toLowerCase();
      return names.any(name.contains);
    }).toList();
    if (matches.isEmpty) return null;
    matches.sort((a, b) {
      if (a.isSelf != b.isSelf) return a.isSelf ? -1 : 1;
      return a.price.compareTo(b.price);
    });
    return matches.first;
  }
}

class MimitFuelPriceLookup {
  MimitFuelPriceLookup({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  static final registryUri = Uri.parse(
    'https://www.mimit.gov.it/images/exportCSV/anagrafica_impianti_attivi.csv',
  );
  static final pricesUri = Uri.parse(
    'https://www.mimit.gov.it/images/exportCSV/prezzo_alle_8.csv',
  );

  Future<List<MimitFuelStationPriceCandidate>> nearby({
    required double latitude,
    required double longitude,
    double radiusMeters = 2500,
  }) async {
    try {
      final responses = await Future.wait([
        _client.get(registryUri).timeout(const Duration(seconds: 12)),
        _client.get(pricesUri).timeout(const Duration(seconds: 12)),
      ]);
      if (responses.any((r) => r.statusCode != 200)) return const [];
      return parseMimitFuelPriceData(
        anagraficaCsv: utf8.decode(responses[0].bodyBytes),
        pricesCsv: utf8.decode(responses[1].bodyBytes),
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      );
    } catch (_) {
      return const [];
    }
  }

  Future<bool> ping() async {
    try {
      final response = await _client
          .get(pricesUri)
          .timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) return false;
      return utf8.decode(response.bodyBytes).contains('|');
    } catch (_) {
      return false;
    }
  }
}

List<MimitFuelStationPriceCandidate> parseMimitFuelPriceData({
  required String anagraficaCsv,
  required String pricesCsv,
  required double latitude,
  required double longitude,
  double radiusMeters = 2500,
}) {
  final extractedAt =
      _extractionDate(anagraficaCsv) ?? _extractionDate(pricesCsv);
  final stations = _parseRegistry(anagraficaCsv);
  final prices = _parsePrices(pricesCsv);
  final out = <MimitFuelStationPriceCandidate>[];
  for (final station in stations.values) {
    final distance = haversineMeters(
      latitude,
      longitude,
      station.latitude,
      station.longitude,
    );
    if (distance > radiusMeters) continue;
    final stationPrices = prices[station.id] ?? const <MimitFuelPrice>[];
    if (stationPrices.isEmpty) continue;
    out.add(
      MimitFuelStationPriceCandidate(
        id: station.id,
        name: station.name,
        brand: station.brand,
        address: station.address,
        city: station.city,
        province: station.province,
        latitude: station.latitude,
        longitude: station.longitude,
        distanceMeters: distance,
        prices: stationPrices,
        extractedAt: extractedAt,
      ),
    );
  }
  out.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
  return out;
}

class _MimitStation {
  const _MimitStation({
    required this.id,
    required this.name,
    required this.brand,
    required this.address,
    required this.city,
    required this.province,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String brand;
  final String address;
  final String city;
  final String province;
  final double latitude;
  final double longitude;
}

Map<String, _MimitStation> _parseRegistry(String csv) {
  final rows = _pipeRows(csv).skip(2);
  final out = <String, _MimitStation>{};
  for (final row in rows) {
    if (row.length < 10) continue;
    final lat = _parseDouble(row[8]);
    final lng = _parseDouble(row[9]);
    if (lat == null || lng == null) continue;
    out[row[0]] = _MimitStation(
      id: row[0],
      brand: row[2].trim(),
      name: row[4].trim().isEmpty ? row[2].trim() : row[4].trim(),
      address: row[5].trim(),
      city: row[6].trim(),
      province: row[7].trim(),
      latitude: lat,
      longitude: lng,
    );
  }
  return out;
}

Map<String, List<MimitFuelPrice>> _parsePrices(String csv) {
  final out = <String, List<MimitFuelPrice>>{};
  for (final row in _pipeRows(csv).skip(2)) {
    if (row.length < 5) continue;
    final price = _parseDouble(row[2]);
    if (price == null) continue;
    (out[row[0]] ??= <MimitFuelPrice>[]).add(
      MimitFuelPrice(
        fuelName: row[1].trim(),
        price: price,
        isSelf: row[3].trim() == '1',
        updatedAt: _parseItalianDateTime(row[4]),
      ),
    );
  }
  return out;
}

Iterable<List<String>> _pipeRows(String csv) sync* {
  for (final line in csv.split(RegExp(r'\r?\n'))) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;
    yield trimmed.split('|').map((c) => c.trim()).toList();
  }
}

DateTime? _extractionDate(String csv) {
  final first = csv.split(RegExp(r'\r?\n')).firstOrNull?.trim();
  if (first == null) return null;
  final match = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(first);
  if (match == null) return null;
  return DateTime(
    int.parse(match.group(1)!),
    int.parse(match.group(2)!),
    int.parse(match.group(3)!),
  );
}

DateTime? _parseItalianDateTime(String value) {
  final match = RegExp(
    r'(\d{1,2})/(\d{1,2})/(\d{4})\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?',
  ).firstMatch(value.trim());
  if (match == null) return null;
  return DateTime(
    int.parse(match.group(3)!),
    int.parse(match.group(2)!),
    int.parse(match.group(1)!),
    int.parse(match.group(4)!),
    int.parse(match.group(5)!),
    int.parse(match.group(6) ?? '0'),
  );
}

double? _parseDouble(String value) =>
    double.tryParse(value.trim().replaceAll(',', '.'));
