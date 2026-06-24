import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/enums.dart';
import '../../domain/services/vehicle_lookup_service.dart';

class OpenApiVehicleLookup {
  OpenApiVehicleLookup({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _baseUri = baseUri ?? Uri.parse('https://api.openapi.com/');

  final http.Client _client;
  final Uri _baseUri;

  Future<VehicleLookupData> lookupItalianPlate({
    required String plate,
    required String apiKey,
  }) async {
    final normalized = const VehicleLookupService().normalizePlate(plate);
    if (normalized.isEmpty || apiKey.trim().isEmpty) {
      return VehicleLookupData(plate: normalized.isEmpty ? null : normalized);
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${apiKey.trim()}',
    };
    final car = await _getJson(_baseUri.resolve('IT-car/$normalized'), headers);
    final insurance = await _getJson(
      _baseUri.resolve('IT-insurance/$normalized'),
      headers,
    );

    return VehicleLookupData(
      plate: normalized,
      make: _string(car, const ['CarMake', 'make', 'brand', 'marca']),
      model: _string(car, const ['CarModel', 'model', 'modello']),
      trim: _string(car, const ['Version', 'version', 'trim', 'allestimento']),
      year: _int(car, const [
        'RegistrationYear',
        'registrationYear',
        'year',
        'anno',
      ]),
      fuelType: _fuel(
        _string(car, const ['FuelType', 'fuelType', 'fuel', 'alimentazione']),
      ),
      euroClass: _euro(_string(car, const ['EuroClass', 'classeEuro'])),
      powerPs: _int(car, const ['PowerCV', 'powerCv', 'powerHp', 'cv']),
      insuranceCompany: _string(insurance, const [
        'company',
        'Company',
        'insuranceCompany',
        'compagnia',
      ]),
      insuranceExpiry: _date(
        _string(insurance, const [
          'expiry',
          'Expiry',
          'expirationDate',
          'scadenza',
        ]),
      ),
    );
  }

  Future<Map<String, Object?>> _getJson(
    Uri uri,
    Map<String, String> headers,
  ) async {
    try {
      final response = await _client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 12));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const {};
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, Object?>) {
        final nested = decoded['data'];
        if (nested is Map<String, Object?>) return nested;
        return decoded;
      }
    } catch (_) {
      /* best-effort */
    }
    return const {};
  }
}

String? _string(Map<String, Object?> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty && text != '-' && text != '—') return text;
  }
  return null;
}

int? _int(Map<String, Object?> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) {
      final match = RegExp(r'\d+').firstMatch(value);
      if (match != null) return int.tryParse(match.group(0)!);
    }
  }
  return null;
}

FuelType? _fuel(String? value) {
  if (value == null) return null;
  final v = value.toLowerCase();
  if (v.contains('benzina') || v.contains('petrol')) return FuelType.petrol;
  if (v.contains('diesel') || v.contains('gasolio')) return FuelType.diesel;
  if (v.contains('gpl') || v.contains('lpg')) return FuelType.lpg;
  if (v.contains('metano') || v.contains('cng')) return FuelType.cng;
  if (v.contains('ibrid') || v.contains('hybrid')) return FuelType.hybrid;
  if (v.contains('elettr') || v.contains('electric')) {
    return FuelType.electric;
  }
  return null;
}

EuroClass? _euro(String? value) {
  if (value == null) return null;
  final match = RegExp(
    r'euro\s*([0-6])',
    caseSensitive: false,
  ).firstMatch(value);
  if (match == null) return null;
  return EuroClass.values[int.parse(match.group(1)!)];
}

DateTime? _date(String? value) {
  if (value == null) return null;
  final italian = RegExp(
    r'(\d{1,2})[/-](\d{1,2})[/-](\d{4})',
  ).firstMatch(value);
  if (italian != null) {
    return DateTime(
      int.parse(italian.group(3)!),
      int.parse(italian.group(2)!),
      int.parse(italian.group(1)!),
    );
  }
  return DateTime.tryParse(value);
}
