// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptData {

 String? get station; double? get amount; double? get liters; double? get pricePerLiter; DateTime? get date;
/// Create a copy of ReceiptData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptDataCopyWith<ReceiptData> get copyWith => _$ReceiptDataCopyWithImpl<ReceiptData>(this as ReceiptData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptData&&(identical(other.station, station) || other.station == station)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.liters, liters) || other.liters == liters)&&(identical(other.pricePerLiter, pricePerLiter) || other.pricePerLiter == pricePerLiter)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,station,amount,liters,pricePerLiter,date);

@override
String toString() {
  return 'ReceiptData(station: $station, amount: $amount, liters: $liters, pricePerLiter: $pricePerLiter, date: $date)';
}


}

/// @nodoc
abstract mixin class $ReceiptDataCopyWith<$Res>  {
  factory $ReceiptDataCopyWith(ReceiptData value, $Res Function(ReceiptData) _then) = _$ReceiptDataCopyWithImpl;
@useResult
$Res call({
 String? station, double? amount, double? liters, double? pricePerLiter, DateTime? date
});




}
/// @nodoc
class _$ReceiptDataCopyWithImpl<$Res>
    implements $ReceiptDataCopyWith<$Res> {
  _$ReceiptDataCopyWithImpl(this._self, this._then);

  final ReceiptData _self;
  final $Res Function(ReceiptData) _then;

/// Create a copy of ReceiptData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? station = freezed,Object? amount = freezed,Object? liters = freezed,Object? pricePerLiter = freezed,Object? date = freezed,}) {
  return _then(_self.copyWith(
station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,liters: freezed == liters ? _self.liters : liters // ignore: cast_nullable_to_non_nullable
as double?,pricePerLiter: freezed == pricePerLiter ? _self.pricePerLiter : pricePerLiter // ignore: cast_nullable_to_non_nullable
as double?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptData].
extension ReceiptDataPatterns on ReceiptData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptData value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptData value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? station,  double? amount,  double? liters,  double? pricePerLiter,  DateTime? date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptData() when $default != null:
return $default(_that.station,_that.amount,_that.liters,_that.pricePerLiter,_that.date);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? station,  double? amount,  double? liters,  double? pricePerLiter,  DateTime? date)  $default,) {final _that = this;
switch (_that) {
case _ReceiptData():
return $default(_that.station,_that.amount,_that.liters,_that.pricePerLiter,_that.date);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? station,  double? amount,  double? liters,  double? pricePerLiter,  DateTime? date)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptData() when $default != null:
return $default(_that.station,_that.amount,_that.liters,_that.pricePerLiter,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptData implements ReceiptData {
  const _ReceiptData({this.station, this.amount, this.liters, this.pricePerLiter, this.date});
  

@override final  String? station;
@override final  double? amount;
@override final  double? liters;
@override final  double? pricePerLiter;
@override final  DateTime? date;

/// Create a copy of ReceiptData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptDataCopyWith<_ReceiptData> get copyWith => __$ReceiptDataCopyWithImpl<_ReceiptData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptData&&(identical(other.station, station) || other.station == station)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.liters, liters) || other.liters == liters)&&(identical(other.pricePerLiter, pricePerLiter) || other.pricePerLiter == pricePerLiter)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,station,amount,liters,pricePerLiter,date);

@override
String toString() {
  return 'ReceiptData(station: $station, amount: $amount, liters: $liters, pricePerLiter: $pricePerLiter, date: $date)';
}


}

/// @nodoc
abstract mixin class _$ReceiptDataCopyWith<$Res> implements $ReceiptDataCopyWith<$Res> {
  factory _$ReceiptDataCopyWith(_ReceiptData value, $Res Function(_ReceiptData) _then) = __$ReceiptDataCopyWithImpl;
@override @useResult
$Res call({
 String? station, double? amount, double? liters, double? pricePerLiter, DateTime? date
});




}
/// @nodoc
class __$ReceiptDataCopyWithImpl<$Res>
    implements _$ReceiptDataCopyWith<$Res> {
  __$ReceiptDataCopyWithImpl(this._self, this._then);

  final _ReceiptData _self;
  final $Res Function(_ReceiptData) _then;

/// Create a copy of ReceiptData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? station = freezed,Object? amount = freezed,Object? liters = freezed,Object? pricePerLiter = freezed,Object? date = freezed,}) {
  return _then(_ReceiptData(
station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,liters: freezed == liters ? _self.liters : liters // ignore: cast_nullable_to_non_nullable
as double?,pricePerLiter: freezed == pricePerLiter ? _self.pricePerLiter : pricePerLiter // ignore: cast_nullable_to_non_nullable
as double?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
