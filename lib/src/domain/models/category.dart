import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required int color,
    @Default(false) bool isDefault,
    @Default(CategoryKind.fuel) CategoryKind kind,
    int? iconCode,
    @Default(0) int ord,
  }) = _Category;

  factory Category.fromJson(Map<String, Object?> json) =>
      _$CategoryFromJson(json);
}
