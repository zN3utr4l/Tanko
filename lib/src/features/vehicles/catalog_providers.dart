import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/catalog.dart';
import '../../providers.dart';

part 'catalog_providers.g.dart';

@riverpod
Future<List<String>> catalogMakes(Ref ref) =>
    ref.watch(catalogRepositoryProvider).makes();

@riverpod
Future<List<CatalogModel>> catalogModels(Ref ref, String make) =>
    ref.watch(catalogRepositoryProvider).models(make);
