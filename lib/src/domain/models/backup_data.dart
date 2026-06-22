import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';
import 'fill_up.dart';
import 'vehicle.dart';

part 'backup_data.freezed.dart';
part 'backup_data.g.dart';

@freezed
abstract class BackupData with _$BackupData {
  const factory BackupData({
    @Default(1) int schemaVersion,
    @Default(<Vehicle>[]) List<Vehicle> vehicles,
    @Default(<Category>[]) List<Category> categories,
    @Default(<FillUp>[]) List<FillUp> fillUps,
  }) = _BackupData;

  factory BackupData.fromJson(Map<String, Object?> json) =>
      _$BackupDataFromJson(json);
}
