// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comparison.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConsumptionComparison {

 double? get realConsumption; double? get mfrConsumption; double? get consumptionDeltaPct; double? get realRangeKm; double? get mfrRangeKm; double? get rangeDeltaPct;
/// Create a copy of ConsumptionComparison
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsumptionComparisonCopyWith<ConsumptionComparison> get copyWith => _$ConsumptionComparisonCopyWithImpl<ConsumptionComparison>(this as ConsumptionComparison, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsumptionComparison&&(identical(other.realConsumption, realConsumption) || other.realConsumption == realConsumption)&&(identical(other.mfrConsumption, mfrConsumption) || other.mfrConsumption == mfrConsumption)&&(identical(other.consumptionDeltaPct, consumptionDeltaPct) || other.consumptionDeltaPct == consumptionDeltaPct)&&(identical(other.realRangeKm, realRangeKm) || other.realRangeKm == realRangeKm)&&(identical(other.mfrRangeKm, mfrRangeKm) || other.mfrRangeKm == mfrRangeKm)&&(identical(other.rangeDeltaPct, rangeDeltaPct) || other.rangeDeltaPct == rangeDeltaPct));
}


@override
int get hashCode => Object.hash(runtimeType,realConsumption,mfrConsumption,consumptionDeltaPct,realRangeKm,mfrRangeKm,rangeDeltaPct);

@override
String toString() {
  return 'ConsumptionComparison(realConsumption: $realConsumption, mfrConsumption: $mfrConsumption, consumptionDeltaPct: $consumptionDeltaPct, realRangeKm: $realRangeKm, mfrRangeKm: $mfrRangeKm, rangeDeltaPct: $rangeDeltaPct)';
}


}

/// @nodoc
abstract mixin class $ConsumptionComparisonCopyWith<$Res>  {
  factory $ConsumptionComparisonCopyWith(ConsumptionComparison value, $Res Function(ConsumptionComparison) _then) = _$ConsumptionComparisonCopyWithImpl;
@useResult
$Res call({
 double? realConsumption, double? mfrConsumption, double? consumptionDeltaPct, double? realRangeKm, double? mfrRangeKm, double? rangeDeltaPct
});




}
/// @nodoc
class _$ConsumptionComparisonCopyWithImpl<$Res>
    implements $ConsumptionComparisonCopyWith<$Res> {
  _$ConsumptionComparisonCopyWithImpl(this._self, this._then);

  final ConsumptionComparison _self;
  final $Res Function(ConsumptionComparison) _then;

/// Create a copy of ConsumptionComparison
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? realConsumption = freezed,Object? mfrConsumption = freezed,Object? consumptionDeltaPct = freezed,Object? realRangeKm = freezed,Object? mfrRangeKm = freezed,Object? rangeDeltaPct = freezed,}) {
  return _then(_self.copyWith(
realConsumption: freezed == realConsumption ? _self.realConsumption : realConsumption // ignore: cast_nullable_to_non_nullable
as double?,mfrConsumption: freezed == mfrConsumption ? _self.mfrConsumption : mfrConsumption // ignore: cast_nullable_to_non_nullable
as double?,consumptionDeltaPct: freezed == consumptionDeltaPct ? _self.consumptionDeltaPct : consumptionDeltaPct // ignore: cast_nullable_to_non_nullable
as double?,realRangeKm: freezed == realRangeKm ? _self.realRangeKm : realRangeKm // ignore: cast_nullable_to_non_nullable
as double?,mfrRangeKm: freezed == mfrRangeKm ? _self.mfrRangeKm : mfrRangeKm // ignore: cast_nullable_to_non_nullable
as double?,rangeDeltaPct: freezed == rangeDeltaPct ? _self.rangeDeltaPct : rangeDeltaPct // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsumptionComparison].
extension ConsumptionComparisonPatterns on ConsumptionComparison {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsumptionComparison value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsumptionComparison() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsumptionComparison value)  $default,){
final _that = this;
switch (_that) {
case _ConsumptionComparison():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsumptionComparison value)?  $default,){
final _that = this;
switch (_that) {
case _ConsumptionComparison() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? realConsumption,  double? mfrConsumption,  double? consumptionDeltaPct,  double? realRangeKm,  double? mfrRangeKm,  double? rangeDeltaPct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsumptionComparison() when $default != null:
return $default(_that.realConsumption,_that.mfrConsumption,_that.consumptionDeltaPct,_that.realRangeKm,_that.mfrRangeKm,_that.rangeDeltaPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? realConsumption,  double? mfrConsumption,  double? consumptionDeltaPct,  double? realRangeKm,  double? mfrRangeKm,  double? rangeDeltaPct)  $default,) {final _that = this;
switch (_that) {
case _ConsumptionComparison():
return $default(_that.realConsumption,_that.mfrConsumption,_that.consumptionDeltaPct,_that.realRangeKm,_that.mfrRangeKm,_that.rangeDeltaPct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? realConsumption,  double? mfrConsumption,  double? consumptionDeltaPct,  double? realRangeKm,  double? mfrRangeKm,  double? rangeDeltaPct)?  $default,) {final _that = this;
switch (_that) {
case _ConsumptionComparison() when $default != null:
return $default(_that.realConsumption,_that.mfrConsumption,_that.consumptionDeltaPct,_that.realRangeKm,_that.mfrRangeKm,_that.rangeDeltaPct);case _:
  return null;

}
}

}

/// @nodoc


class _ConsumptionComparison extends ConsumptionComparison {
  const _ConsumptionComparison({this.realConsumption, this.mfrConsumption, this.consumptionDeltaPct, this.realRangeKm, this.mfrRangeKm, this.rangeDeltaPct}): super._();
  

@override final  double? realConsumption;
@override final  double? mfrConsumption;
@override final  double? consumptionDeltaPct;
@override final  double? realRangeKm;
@override final  double? mfrRangeKm;
@override final  double? rangeDeltaPct;

/// Create a copy of ConsumptionComparison
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsumptionComparisonCopyWith<_ConsumptionComparison> get copyWith => __$ConsumptionComparisonCopyWithImpl<_ConsumptionComparison>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsumptionComparison&&(identical(other.realConsumption, realConsumption) || other.realConsumption == realConsumption)&&(identical(other.mfrConsumption, mfrConsumption) || other.mfrConsumption == mfrConsumption)&&(identical(other.consumptionDeltaPct, consumptionDeltaPct) || other.consumptionDeltaPct == consumptionDeltaPct)&&(identical(other.realRangeKm, realRangeKm) || other.realRangeKm == realRangeKm)&&(identical(other.mfrRangeKm, mfrRangeKm) || other.mfrRangeKm == mfrRangeKm)&&(identical(other.rangeDeltaPct, rangeDeltaPct) || other.rangeDeltaPct == rangeDeltaPct));
}


@override
int get hashCode => Object.hash(runtimeType,realConsumption,mfrConsumption,consumptionDeltaPct,realRangeKm,mfrRangeKm,rangeDeltaPct);

@override
String toString() {
  return 'ConsumptionComparison(realConsumption: $realConsumption, mfrConsumption: $mfrConsumption, consumptionDeltaPct: $consumptionDeltaPct, realRangeKm: $realRangeKm, mfrRangeKm: $mfrRangeKm, rangeDeltaPct: $rangeDeltaPct)';
}


}

/// @nodoc
abstract mixin class _$ConsumptionComparisonCopyWith<$Res> implements $ConsumptionComparisonCopyWith<$Res> {
  factory _$ConsumptionComparisonCopyWith(_ConsumptionComparison value, $Res Function(_ConsumptionComparison) _then) = __$ConsumptionComparisonCopyWithImpl;
@override @useResult
$Res call({
 double? realConsumption, double? mfrConsumption, double? consumptionDeltaPct, double? realRangeKm, double? mfrRangeKm, double? rangeDeltaPct
});




}
/// @nodoc
class __$ConsumptionComparisonCopyWithImpl<$Res>
    implements _$ConsumptionComparisonCopyWith<$Res> {
  __$ConsumptionComparisonCopyWithImpl(this._self, this._then);

  final _ConsumptionComparison _self;
  final $Res Function(_ConsumptionComparison) _then;

/// Create a copy of ConsumptionComparison
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? realConsumption = freezed,Object? mfrConsumption = freezed,Object? consumptionDeltaPct = freezed,Object? realRangeKm = freezed,Object? mfrRangeKm = freezed,Object? rangeDeltaPct = freezed,}) {
  return _then(_ConsumptionComparison(
realConsumption: freezed == realConsumption ? _self.realConsumption : realConsumption // ignore: cast_nullable_to_non_nullable
as double?,mfrConsumption: freezed == mfrConsumption ? _self.mfrConsumption : mfrConsumption // ignore: cast_nullable_to_non_nullable
as double?,consumptionDeltaPct: freezed == consumptionDeltaPct ? _self.consumptionDeltaPct : consumptionDeltaPct // ignore: cast_nullable_to_non_nullable
as double?,realRangeKm: freezed == realRangeKm ? _self.realRangeKm : realRangeKm // ignore: cast_nullable_to_non_nullable
as double?,mfrRangeKm: freezed == mfrRangeKm ? _self.mfrRangeKm : mfrRangeKm // ignore: cast_nullable_to_non_nullable
as double?,rangeDeltaPct: freezed == rangeDeltaPct ? _self.rangeDeltaPct : rangeDeltaPct // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
