import 'package:freezed_annotation/freezed_annotation.dart';
import 'fill_up.dart';

part 'import_result.freezed.dart';

@freezed
abstract class ImportResult with _$ImportResult {
  const factory ImportResult({
    @Default(<FillUp>[]) List<FillUp> rows,
    @Default(0) int skipped,
    @Default(0) int duplicates,
    @Default(<String>[]) List<String> warnings,
  }) = _ImportResult;
}
