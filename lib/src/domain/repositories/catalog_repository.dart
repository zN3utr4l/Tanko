import '../models/catalog.dart';

/// Online vehicle-spec catalog (CarQuery). Implementations may throw on
/// network errors; callers fall back to manual entry.
abstract class CatalogRepository {
  Future<List<CatalogMake>> makes();
  Future<List<String>> models(String makeId);
  Future<List<CatalogTrim>> trims(String makeId, String model);
}
