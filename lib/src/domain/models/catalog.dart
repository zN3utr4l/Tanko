import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'catalog.freezed.dart';

/// A vehicle make from the online catalog (e.g. Renault).
@freezed
abstract class CatalogMake with _$CatalogMake {
  const factory CatalogMake({required String id, required String name}) =
      _CatalogMake;
}

/// A specific trim/version of a model, with the specs we can pre-fill.
@freezed
abstract class CatalogTrim with _$CatalogTrim {
  const factory CatalogTrim({
    required String modelId,
    required String make,
    required String model,
    int? year,
    String? trim,
    FuelType? fuelType,
    double? consumptionL100,
    double? tankCapacityL,
    int? powerPs,
  }) = _CatalogTrim;

  const CatalogTrim._();

  /// Human-friendly label for a dropdown entry.
  String get label {
    final parts = <String>[
      if (year != null) '$year',
      if (trim != null && trim!.isNotEmpty) trim!,
    ];
    return parts.isEmpty ? model : parts.join(' · ');
  }
}
