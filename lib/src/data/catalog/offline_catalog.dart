import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../domain/models/catalog.dart';
import '../../domain/models/enums.dart';
import '../../domain/repositories/catalog_repository.dart';

/// [CatalogRepository] backed by a bundled JSON asset. Loaded once and cached;
/// it never touches the network, so the Add-Vehicle wizard always works offline.
class OfflineCatalog implements CatalogRepository {
  OfflineCatalog({Future<String> Function(String key)? loadAsset})
    : _loadAsset = loadAsset ?? rootBundle.loadString;

  final Future<String> Function(String key) _loadAsset;

  static const assetKey = 'assets/catalog/catalog.json';

  _Catalog? _cache;
  Future<_Catalog>? _loading;

  Future<_Catalog> _load() => _loading ??= _parse();

  Future<_Catalog> _parse() async {
    final raw = jsonDecode(await _loadAsset(assetKey)) as Map<String, dynamic>;
    final makeNames = <String>[];
    final byMake = <String, List<CatalogModel>>{};
    for (final m in (raw['makes'] as List).cast<Map<String, dynamic>>()) {
      final make = m['name'] as String;
      makeNames.add(make);
      byMake[make.toLowerCase()] = [
        for (final v in (m['models'] as List).cast<Map<String, dynamic>>())
          CatalogModel(
            make: make,
            name: v['name'] as String,
            fuelType: _fuel(v['fuel'] as String?),
            consumptionL100: (v['consumption'] as num?)?.toDouble(),
            tankCapacityL: (v['tankL'] as num?)?.toDouble(),
            powerPs: (v['powerPs'] as num?)?.toInt(),
            trims: [
              for (final t
                  in (v['trims'] as List?)?.cast<Map<String, dynamic>>() ??
                      const [])
                CatalogTrim(
                  name: t['name'] as String,
                  fuelType: _fuel(t['fuel'] as String?),
                  consumptionL100: (t['consumption'] as num?)?.toDouble(),
                  tankCapacityL: (t['tankL'] as num?)?.toDouble(),
                  powerPs: (t['powerPs'] as num?)?.toInt(),
                ),
            ],
          ),
      ];
    }
    makeNames.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final cat = _Catalog(makeNames, byMake);
    _cache = cat;
    return cat;
  }

  @override
  Future<List<String>> makes() async => (_cache ?? await _load()).makeNames;

  @override
  Future<List<CatalogModel>> models(String make) async =>
      (_cache ?? await _load()).byMake[make.trim().toLowerCase()] ?? const [];

  static FuelType? _fuel(String? raw) => switch (raw) {
    'petrol' => FuelType.petrol,
    'diesel' => FuelType.diesel,
    'hybrid' => FuelType.hybrid,
    'electric' => FuelType.electric,
    'lpg' => FuelType.lpg,
    'cng' => FuelType.cng,
    _ => null,
  };
}

class _Catalog {
  const _Catalog(this.makeNames, this.byMake);
  final List<String> makeNames;
  final Map<String, List<CatalogModel>> byMake;
}
