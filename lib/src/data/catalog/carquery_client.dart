import 'package:dio/dio.dart';
import '../../domain/models/catalog.dart';
import '../../domain/repositories/catalog_repository.dart';
import 'carquery_parser.dart';

/// CarQuery-backed catalog. Free, no API key. Network failures propagate so
/// the UI can fall back to manual entry.
class CarQueryClient implements CatalogRepository {
  CarQueryClient(this._dio, {this.parser = const CarQueryParser()});

  final Dio _dio;
  final CarQueryParser parser;

  static const _base = 'https://www.carqueryapi.com/api/0.3/';

  Future<String> _get(Map<String, dynamic> params) async {
    final res = await _dio.get<String>(
      _base,
      queryParameters: params,
      options: Options(responseType: ResponseType.plain),
    );
    return res.data ?? '';
  }

  @override
  Future<List<CatalogMake>> makes() async =>
      parser.parseMakes(await _get({'cmd': 'getMakes'}));

  @override
  Future<List<String>> models(String makeId) async =>
      parser.parseModels(await _get({'cmd': 'getModels', 'make': makeId}));

  @override
  Future<List<CatalogTrim>> trims(String makeId, String model) async =>
      parser.parseTrims(
        await _get({'cmd': 'getTrims', 'make': makeId, 'model': model}),
      );
}
