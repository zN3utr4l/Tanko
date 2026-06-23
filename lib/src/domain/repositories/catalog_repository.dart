import '../models/catalog.dart';

/// Offline vehicle catalog: make names and their known models (with
/// pre-fillable specs). Backed by a bundled asset, so it never fails on a
/// network — the wizard always lets the user type anything not in the catalog.
abstract class CatalogRepository {
  /// All make names, alphabetically.
  Future<List<String>> makes();

  /// Known models for [make] (case-insensitive). Empty if the make is unknown.
  Future<List<CatalogModel>> models(String make);
}
