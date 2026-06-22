import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/catalog.dart';
import '../../providers.dart';

part 'catalog_providers.g.dart';

@riverpod
Future<List<CatalogMake>> catalogMakes(Ref ref) =>
    ref.watch(catalogRepositoryProvider).makes();

@riverpod
Future<List<String>> catalogModels(Ref ref, String makeId) =>
    ref.watch(catalogRepositoryProvider).models(makeId);

@riverpod
Future<List<CatalogTrim>> catalogTrims(Ref ref, String makeId, String model) =>
    ref.watch(catalogRepositoryProvider).trims(makeId, model);
