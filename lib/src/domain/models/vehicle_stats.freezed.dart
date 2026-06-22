// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VehicleStats {

 double get totalSpend; double? get avgPricePerLiter; double? get avgConsumption; double get totalKm; DateTime? get lastFillDate; Map<int, double> get spendByCategory; int get fillUpCount;
/// Create a copy of VehicleStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleStatsCopyWith<VehicleStats> get copyWith => _$VehicleStatsCopyWithImpl<VehicleStats>(this as VehicleStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleStats&&(identical(other.totalSpend, totalSpend) || other.totalSpend == totalSpend)&&(identical(other.avgPricePerLiter, avgPricePerLiter) || other.avgPricePerLiter == avgPricePerLiter)&&(identical(other.avgConsumption, avgConsumption) || other.avgConsumption == avgConsumption)&&(identical(other.totalKm, totalKm) || other.totalKm == totalKm)&&(identical(other.lastFillDate, lastFillDate) || other.lastFillDate == lastFillDate)&&const DeepCollectionEquality().equals(other.spendByCategory, spendByCategory)&&(identical(other.fillUpCount, fillUpCount) || other.fillUpCount == fillUpCount));
}


@override
int get hashCode => Object.hash(runtimeType,totalSpend,avgPricePerLiter,avgConsumption,totalKm,lastFillDate,const DeepCollectionEquality().hash(spendByCategory),fillUpCount);

@override
String toString() {
  return 'VehicleStats(totalSpend: $totalSpend, avgPricePerLiter: $avgPricePerLiter, avgConsumption: $avgConsumption, totalKm: $totalKm, lastFillDate: $lastFillDate, spendByCategory: $spendByCategory, fillUpCount: $fillUpCount)';
}


}

/// @nodoc
abstract mixin class $VehicleStatsCopyWith<$Res>  {
  factory $VehicleStatsCopyWith(VehicleStats value, $Res Function(VehicleStats) _then) = _$VehicleStatsCopyWithImpl;
@useResult
$Res call({
 double totalSpend, double? avgPricePerLiter, double? avgConsumption, double totalKm, DateTime? lastFillDate, Map<int, double> spendByCategory, int fillUpCount
});




}
/// @nodoc
class _$VehicleStatsCopyWithImpl<$Res>
    implements $VehicleStatsCopyWith<$Res> {
  _$VehicleStatsCopyWithImpl(this._self, this._then);

  final VehicleStats _self;
  final $Res Function(VehicleStats) _then;

/// Create a copy of VehicleStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSpend = null,Object? avgPricePerLiter = freezed,Object? avgConsumption = freezed,Object? totalKm = null,Object? lastFillDate = freezed,Object? spendByCategory = null,Object? fillUpCount = null,}) {
  return _then(_self.copyWith(
totalSpend: null == totalSpend ? _self.totalSpend : totalSpend // ignore: cast_nullable_to_non_nullable
as double,avgPricePerLiter: freezed == avgPricePerLiter ? _self.avgPricePerLiter : avgPricePerLiter // ignore: cast_nullable_to_non_nullable
as double?,avgConsumption: freezed == avgConsumption ? _self.avgConsumption : avgConsumption // ignore: cast_nullable_to_non_nullable
as double?,totalKm: null == totalKm ? _self.totalKm : totalKm // ignore: cast_nullable_to_non_nullable
as double,lastFillDate: freezed == lastFillDate ? _self.lastFillDate : lastFillDate // ignore: cast_nullable_to_non_nullable
as DateTime?,spendByCategory: null == spendByCategory ? _self.spendByCategory : spendByCategory // ignore: cast_nullable_to_non_nullable
as Map<int, double>,fillUpCount: null == fillUpCount ? _self.fillUpCount : fillUpCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleStats].
extension VehicleStatsPatterns on VehicleStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleStats value)  $default,){
final _that = this;
switch (_that) {
case _VehicleStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleStats value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalSpend,  double? avgPricePerLiter,  double? avgConsumption,  double totalKm,  DateTime? lastFillDate,  Map<int, double> spendByCategory,  int fillUpCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleStats() when $default != null:
return $default(_that.totalSpend,_that.avgPricePerLiter,_that.avgConsumption,_that.totalKm,_that.lastFillDate,_that.spendByCategory,_that.fillUpCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalSpend,  double? avgPricePerLiter,  double? avgConsumption,  double totalKm,  DateTime? lastFillDate,  Map<int, double> spendByCategory,  int fillUpCount)  $default,) {final _that = this;
switch (_that) {
case _VehicleStats():
return $default(_that.totalSpend,_that.avgPricePerLiter,_that.avgConsumption,_that.totalKm,_that.lastFillDate,_that.spendByCategory,_that.fillUpCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalSpend,  double? avgPricePerLiter,  double? avgConsumption,  double totalKm,  DateTime? lastFillDate,  Map<int, double> spendByCategory,  int fillUpCount)?  $default,) {final _that = this;
switch (_that) {
case _VehicleStats() when $default != null:
return $default(_that.totalSpend,_that.avgPricePerLiter,_that.avgConsumption,_that.totalKm,_that.lastFillDate,_that.spendByCategory,_that.fillUpCount);case _:
  return null;

}
}

}

/// @nodoc


class _VehicleStats implements VehicleStats {
  const _VehicleStats({this.totalSpend = 0, this.avgPricePerLiter, this.avgConsumption, this.totalKm = 0, this.lastFillDate, final  Map<int, double> spendByCategory = const <int, double>{}, this.fillUpCount = 0}): _spendByCategory = spendByCategory;
  

@override@JsonKey() final  double totalSpend;
@override final  double? avgPricePerLiter;
@override final  double? avgConsumption;
@override@JsonKey() final  double totalKm;
@override final  DateTime? lastFillDate;
 final  Map<int, double> _spendByCategory;
@override@JsonKey() Map<int, double> get spendByCategory {
  if (_spendByCategory is EqualUnmodifiableMapView) return _spendByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_spendByCategory);
}

@override@JsonKey() final  int fillUpCount;

/// Create a copy of VehicleStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleStatsCopyWith<_VehicleStats> get copyWith => __$VehicleStatsCopyWithImpl<_VehicleStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleStats&&(identical(other.totalSpend, totalSpend) || other.totalSpend == totalSpend)&&(identical(other.avgPricePerLiter, avgPricePerLiter) || other.avgPricePerLiter == avgPricePerLiter)&&(identical(other.avgConsumption, avgConsumption) || other.avgConsumption == avgConsumption)&&(identical(other.totalKm, totalKm) || other.totalKm == totalKm)&&(identical(other.lastFillDate, lastFillDate) || other.lastFillDate == lastFillDate)&&const DeepCollectionEquality().equals(other._spendByCategory, _spendByCategory)&&(identical(other.fillUpCount, fillUpCount) || other.fillUpCount == fillUpCount));
}


@override
int get hashCode => Object.hash(runtimeType,totalSpend,avgPricePerLiter,avgConsumption,totalKm,lastFillDate,const DeepCollectionEquality().hash(_spendByCategory),fillUpCount);

@override
String toString() {
  return 'VehicleStats(totalSpend: $totalSpend, avgPricePerLiter: $avgPricePerLiter, avgConsumption: $avgConsumption, totalKm: $totalKm, lastFillDate: $lastFillDate, spendByCategory: $spendByCategory, fillUpCount: $fillUpCount)';
}


}

/// @nodoc
abstract mixin class _$VehicleStatsCopyWith<$Res> implements $VehicleStatsCopyWith<$Res> {
  factory _$VehicleStatsCopyWith(_VehicleStats value, $Res Function(_VehicleStats) _then) = __$VehicleStatsCopyWithImpl;
@override @useResult
$Res call({
 double totalSpend, double? avgPricePerLiter, double? avgConsumption, double totalKm, DateTime? lastFillDate, Map<int, double> spendByCategory, int fillUpCount
});




}
/// @nodoc
class __$VehicleStatsCopyWithImpl<$Res>
    implements _$VehicleStatsCopyWith<$Res> {
  __$VehicleStatsCopyWithImpl(this._self, this._then);

  final _VehicleStats _self;
  final $Res Function(_VehicleStats) _then;

/// Create a copy of VehicleStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSpend = null,Object? avgPricePerLiter = freezed,Object? avgConsumption = freezed,Object? totalKm = null,Object? lastFillDate = freezed,Object? spendByCategory = null,Object? fillUpCount = null,}) {
  return _then(_VehicleStats(
totalSpend: null == totalSpend ? _self.totalSpend : totalSpend // ignore: cast_nullable_to_non_nullable
as double,avgPricePerLiter: freezed == avgPricePerLiter ? _self.avgPricePerLiter : avgPricePerLiter // ignore: cast_nullable_to_non_nullable
as double?,avgConsumption: freezed == avgConsumption ? _self.avgConsumption : avgConsumption // ignore: cast_nullable_to_non_nullable
as double?,totalKm: null == totalKm ? _self.totalKm : totalKm // ignore: cast_nullable_to_non_nullable
as double,lastFillDate: freezed == lastFillDate ? _self.lastFillDate : lastFillDate // ignore: cast_nullable_to_non_nullable
as DateTime?,spendByCategory: null == spendByCategory ? _self._spendByCategory : spendByCategory // ignore: cast_nullable_to_non_nullable
as Map<int, double>,fillUpCount: null == fillUpCount ? _self.fillUpCount : fillUpCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
