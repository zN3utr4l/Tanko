import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_data.freezed.dart';

@freezed
abstract class ReceiptData with _$ReceiptData {
  const factory ReceiptData({
    String? station,
    double? amount,
    double? liters,
    double? pricePerLiter,
    DateTime? date,
  }) = _ReceiptData;
}
