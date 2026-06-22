import 'dart:convert';
import '../../domain/models/catalog.dart';
import '../../domain/models/enums.dart';

/// Pure parsing helpers for CarQuery API responses.
///
/// CarQuery sometimes wraps its JSON in a JSONP envelope like `?({...});`
/// and returns all numbers as strings, so parsing is tolerant.
class CarQueryParser {
  const CarQueryParser();

  /// Strips a JSONP wrapper, returning the inner JSON text.
  String stripJsonp(String body) {
    final start = body.indexOf('{');
    final end = body.lastIndexOf('}');
    if (start == -1 || end == -1 || end < start) return body;
    return body.substring(start, end + 1);
  }

  Map<String, dynamic> _decode(String body) =>
      jsonDecode(stripJsonp(body)) as Map<String, dynamic>;

  double? _toDouble(Object? v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll(',', '.'));
  }

  int? _toInt(Object? v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString().split('.').first);
  }

  FuelType? mapFuel(String? raw) {
    if (raw == null) return null;
    final f = raw.toLowerCase();
    if (f.contains('diesel')) return FuelType.diesel;
    if (f.contains('hybrid')) return FuelType.hybrid;
    if (f.contains('electric')) return FuelType.electric;
    if (f.contains('lpg')) return FuelType.lpg;
    if (f.contains('cng') || f.contains('natural gas')) return FuelType.cng;
    if (f.contains('gasoline') || f.contains('petrol')) return FuelType.petrol;
    return null;
  }

  List<CatalogMake> parseMakes(String body) {
    final list = (_decode(body)['Makes'] as List?) ?? const [];
    return [
      for (final m in list.cast<Map<String, dynamic>>())
        CatalogMake(
          id: (m['make_id'] ?? '').toString(),
          name: (m['make_display'] ?? m['make_id'] ?? '').toString(),
        ),
    ]..removeWhere((m) => m.id.isEmpty);
  }

  List<String> parseModels(String body) {
    final list = (_decode(body)['Models'] as List?) ?? const [];
    return [
      for (final m in list.cast<Map<String, dynamic>>())
        (m['model_name'] ?? '').toString(),
    ]..removeWhere((s) => s.isEmpty);
  }

  List<CatalogTrim> parseTrims(String body) {
    final list = (_decode(body)['Trims'] as List?) ?? const [];
    return [
      for (final t in list.cast<Map<String, dynamic>>())
        CatalogTrim(
          modelId: (t['model_id'] ?? '').toString(),
          make: (t['model_make_id'] ?? '').toString(),
          model: (t['model_name'] ?? '').toString(),
          year: _toInt(t['model_year']),
          trim: (t['model_trim'] ?? '').toString().isEmpty
              ? null
              : t['model_trim'].toString(),
          fuelType: mapFuel(t['model_engine_fuel']?.toString()),
          consumptionL100: _toDouble(t['model_lkm_mixed']),
          tankCapacityL: _toDouble(t['model_fuel_cap_l']),
          powerPs: _toInt(t['model_engine_power_ps']),
        ),
    ];
  }
}
