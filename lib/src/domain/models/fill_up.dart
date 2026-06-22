import 'package:freezed_annotation/freezed_annotation.dart';

part 'fill_up.freezed.dart';
part 'fill_up.g.dart';

@freezed
abstract class FillUp with _$FillUp {
  const factory FillUp({
    required int id,
    required int vehicleId,
    required DateTime date,
    required double amount,
    double? liters,
    required double odometer,
    @Default(true) bool isFull,
    double? rangeKm,
    String? station,
    required int categoryId,
    String? note,
    double? latitude,
    double? longitude,
    String? receiptPhotoPath,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FillUp;

  factory FillUp.fromJson(Map<String, Object?> json) => _$FillUpFromJson(json);
}
