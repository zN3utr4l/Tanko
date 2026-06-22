// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cost_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CostSummary {

 double get fuelCost; double get expenseCost; double get totalKm; int get months;
/// Create a copy of CostSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CostSummaryCopyWith<CostSummary> get copyWith => _$CostSummaryCopyWithImpl<CostSummary>(this as CostSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CostSummary&&(identical(other.fuelCost, fuelCost) || other.fuelCost == fuelCost)&&(identical(other.expenseCost, expenseCost) || other.expenseCost == expenseCost)&&(identical(other.totalKm, totalKm) || other.totalKm == totalKm)&&(identical(other.months, months) || other.months == months));
}


@override
int get hashCode => Object.hash(runtimeType,fuelCost,expenseCost,totalKm,months);

@override
String toString() {
  return 'CostSummary(fuelCost: $fuelCost, expenseCost: $expenseCost, totalKm: $totalKm, months: $months)';
}


}

/// @nodoc
abstract mixin class $CostSummaryCopyWith<$Res>  {
  factory $CostSummaryCopyWith(CostSummary value, $Res Function(CostSummary) _then) = _$CostSummaryCopyWithImpl;
@useResult
$Res call({
 double fuelCost, double expenseCost, double totalKm, int months
});




}
/// @nodoc
class _$CostSummaryCopyWithImpl<$Res>
    implements $CostSummaryCopyWith<$Res> {
  _$CostSummaryCopyWithImpl(this._self, this._then);

  final CostSummary _self;
  final $Res Function(CostSummary) _then;

/// Create a copy of CostSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fuelCost = null,Object? expenseCost = null,Object? totalKm = null,Object? months = null,}) {
  return _then(_self.copyWith(
fuelCost: null == fuelCost ? _self.fuelCost : fuelCost // ignore: cast_nullable_to_non_nullable
as double,expenseCost: null == expenseCost ? _self.expenseCost : expenseCost // ignore: cast_nullable_to_non_nullable
as double,totalKm: null == totalKm ? _self.totalKm : totalKm // ignore: cast_nullable_to_non_nullable
as double,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CostSummary].
extension CostSummaryPatterns on CostSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CostSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CostSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CostSummary value)  $default,){
final _that = this;
switch (_that) {
case _CostSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CostSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CostSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double fuelCost,  double expenseCost,  double totalKm,  int months)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CostSummary() when $default != null:
return $default(_that.fuelCost,_that.expenseCost,_that.totalKm,_that.months);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double fuelCost,  double expenseCost,  double totalKm,  int months)  $default,) {final _that = this;
switch (_that) {
case _CostSummary():
return $default(_that.fuelCost,_that.expenseCost,_that.totalKm,_that.months);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double fuelCost,  double expenseCost,  double totalKm,  int months)?  $default,) {final _that = this;
switch (_that) {
case _CostSummary() when $default != null:
return $default(_that.fuelCost,_that.expenseCost,_that.totalKm,_that.months);case _:
  return null;

}
}

}

/// @nodoc


class _CostSummary extends CostSummary {
  const _CostSummary({this.fuelCost = 0, this.expenseCost = 0, this.totalKm = 0, this.months = 0}): super._();
  

@override@JsonKey() final  double fuelCost;
@override@JsonKey() final  double expenseCost;
@override@JsonKey() final  double totalKm;
@override@JsonKey() final  int months;

/// Create a copy of CostSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CostSummaryCopyWith<_CostSummary> get copyWith => __$CostSummaryCopyWithImpl<_CostSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CostSummary&&(identical(other.fuelCost, fuelCost) || other.fuelCost == fuelCost)&&(identical(other.expenseCost, expenseCost) || other.expenseCost == expenseCost)&&(identical(other.totalKm, totalKm) || other.totalKm == totalKm)&&(identical(other.months, months) || other.months == months));
}


@override
int get hashCode => Object.hash(runtimeType,fuelCost,expenseCost,totalKm,months);

@override
String toString() {
  return 'CostSummary(fuelCost: $fuelCost, expenseCost: $expenseCost, totalKm: $totalKm, months: $months)';
}


}

/// @nodoc
abstract mixin class _$CostSummaryCopyWith<$Res> implements $CostSummaryCopyWith<$Res> {
  factory _$CostSummaryCopyWith(_CostSummary value, $Res Function(_CostSummary) _then) = __$CostSummaryCopyWithImpl;
@override @useResult
$Res call({
 double fuelCost, double expenseCost, double totalKm, int months
});




}
/// @nodoc
class __$CostSummaryCopyWithImpl<$Res>
    implements _$CostSummaryCopyWith<$Res> {
  __$CostSummaryCopyWithImpl(this._self, this._then);

  final _CostSummary _self;
  final $Res Function(_CostSummary) _then;

/// Create a copy of CostSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fuelCost = null,Object? expenseCost = null,Object? totalKm = null,Object? months = null,}) {
  return _then(_CostSummary(
fuelCost: null == fuelCost ? _self.fuelCost : fuelCost // ignore: cast_nullable_to_non_nullable
as double,expenseCost: null == expenseCost ? _self.expenseCost : expenseCost // ignore: cast_nullable_to_non_nullable
as double,totalKm: null == totalKm ? _self.totalKm : totalKm // ignore: cast_nullable_to_non_nullable
as double,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
