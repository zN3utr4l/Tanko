import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'detected_station.freezed.dart';

@freezed
abstract class DetectedStation with _$DetectedStation {
  const factory DetectedStation({
    required String name,
    required double latitude,
    required double longitude,
    required double distanceMeters,
    required StationSource source,
  }) = _DetectedStation;
}
