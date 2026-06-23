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

    /// Known trims/versions for this model (allestimenti). Optional and never
    /// exhaustive — a curated shortlist of common variants. Picking one can
    /// refine the pre-filled specs; free text is always accepted in the wizard.
    @Default(<CatalogTrim>[]) List<CatalogTrim> trims,
  }) = _CatalogModel;
}

/// A trim/version (allestimento) of a [CatalogModel]. Spec fields are optional
/// overrides applied on top of the model's representative specs when picked.
@freezed
abstract class CatalogTrim with _$CatalogTrim {
  const factory CatalogTrim({
    required String name,
    FuelType? fuelType,
    double? consumptionL100,
    double? tankCapacityL,
    int? powerPs,
  }) = _CatalogTrim;
}
