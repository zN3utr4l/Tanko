import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/catalog.dart';
import '../../domain/models/enums.dart';

class CarApiCatalogLookup {
  CarApiCatalogLookup({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _baseUri = baseUri ?? Uri.parse('https://carapi.app/api/trims');

  final http.Client _client;
  final Uri _baseUri;

  Future<List<CatalogTrim>> trims({
    required String make,
    required String model,
    int? year,
  }) async {
    if (make.trim().isEmpty || model.trim().isEmpty) return const [];
    final query = <String, String>{
      ..._baseUri.queryParameters,
      'make': make.trim(),
      'model': model.trim(),
      if (year != null) 'year': '$year',
    };
    final uri = _baseUri.replace(queryParameters: query);
    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 12));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const [];
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final rows = decoded is Map<String, Object?> ? decoded['data'] : decoded;
      if (rows is! List) return const [];

      final seen = <String>{};
      final out = <CatalogTrim>[];
      for (final row in rows.whereType<Map<String, Object?>>()) {
        final trim = _string(row, const ['trim', 'name', 'version']);
        if (trim == null || !seen.add(trim.toLowerCase())) continue;
        final engine = _map(row['engine']);
        final mileage = _map(row['mileage']);
        out.add(
          CatalogTrim(
            name: trim,
            fuelType: _fuel(
              _string(row, const ['fuel_type', 'fuelType', 'fuel']) ??
                  _string(engine, const ['fuel_type', 'fuelType', 'fuel']),
            ),
            powerPs:
                _int(row, const ['horsepower_hp', 'horsepowerHp', 'power']) ??
                _int(engine, const ['horsepower_hp', 'horsepowerHp', 'power']),
            tankCapacityL: _litersFromGallons(
              _double(row, const [
                    'fuel_tank_capacity_gal',
                    'fuel_tank_capacity',
                  ]) ??
                  _double(engine, const [
                    'fuel_tank_capacity_gal',
                    'fuel_tank_capacity',
                  ]) ??
                  _double(mileage, const [
                    'fuel_tank_capacity_gal',
                    'fuel_tank_capacity',
                  ]),
            ),
            consumptionL100: _l100FromMpg(
              _double(row, const ['combined_mpg']) ??
                  _double(mileage, const ['combined_mpg', 'combinedMpg']),
            ),
          ),
        );
      }
      return out;
    } catch (_) {
      return const [];
    }
  }
}

Map<String, Object?> _map(Object? value) =>
    value is Map<String, Object?> ? value : const {};

String? _string(Map<String, Object?> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return null;
}

int? _int(Map<String, Object?> json, List<String> keys) {
  final value = _double(json, keys);
  return value?.round();
}

double? _double(Map<String, Object?> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.replaceAll(',', '.'));
      if (parsed != null) return parsed;
    }
  }
  return null;
}

FuelType? _fuel(String? value) {
  if (value == null) return null;
  final v = value.toLowerCase();
  if (v.contains('gas') ||
      v.contains('petrol') ||
      v.contains('unleaded') ||
      v.contains('benzina')) {
    return FuelType.petrol;
  }
  if (v.contains('diesel') || v.contains('gasolio')) return FuelType.diesel;
  if (v.contains('lpg') || v.contains('gpl')) return FuelType.lpg;
  if (v.contains('cng') || v.contains('metano')) return FuelType.cng;
  if (v.contains('hybrid') || v.contains('ibrid')) return FuelType.hybrid;
  if (v.contains('electric') || v.contains('elettr')) {
    return FuelType.electric;
  }
  return null;
}

double? _litersFromGallons(double? value) =>
    value == null ? null : value * 3.785411784;

double? _l100FromMpg(double? value) =>
    value == null || value <= 0 ? null : 235.214583 / value;
