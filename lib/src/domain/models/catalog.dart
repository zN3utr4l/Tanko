import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'catalog.freezed.dart';

/// A model entry from the bundled offline catalog, with the representative
/// specs we can pre-fill into a new vehicle. Every spec stays editable — these
/// are sensible defaults for the most common variant, not authoritative data.
@freezed
abstract class CatalogModel with _$CatalogModel {
  const factory CatalogModel({
    required String make,
    required String name,
    FuelType? fuelType,
    double? consumptionL100,
    double? tankCapacityL,
    int? powerPs,
  }) = _CatalogModel;
}
