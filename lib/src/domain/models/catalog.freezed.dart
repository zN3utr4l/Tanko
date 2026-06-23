// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogModel {

 String get make; String get name; FuelType? get fuelType; double? get consumptionL100; double? get tankCapacityL; int? get powerPs;
/// Create a copy of CatalogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogModelCopyWith<CatalogModel> get copyWith => _$CatalogModelCopyWithImpl<CatalogModel>(this as CatalogModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogModel&&(identical(other.make, make) || other.make == make)&&(identical(other.name, name) || other.name == name)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.consumptionL100, consumptionL100) || other.consumptionL100 == consumptionL100)&&(identical(other.tankCapacityL, tankCapacityL) || other.tankCapacityL == tankCapacityL)&&(identical(other.powerPs, powerPs) || other.powerPs == powerPs));
}


@override
int get hashCode => Object.hash(runtimeType,make,name,fuelType,consumptionL100,tankCapacityL,powerPs);

@override
String toString() {
  return 'CatalogModel(make: $make, name: $name, fuelType: $fuelType, consumptionL100: $consumptionL100, tankCapacityL: $tankCapacityL, powerPs: $powerPs)';
}


}

/// @nodoc
abstract mixin class $CatalogModelCopyWith<$Res>  {
  factory $CatalogModelCopyWith(CatalogModel value, $Res Function(CatalogModel) _then) = _$CatalogModelCopyWithImpl;
@useResult
$Res call({
 String make, String name, FuelType? fuelType, double? consumptionL100, double? tankCapacityL, int? powerPs
});




}
/// @nodoc
class _$CatalogModelCopyWithImpl<$Res>
    implements $CatalogModelCopyWith<$Res> {
  _$CatalogModelCopyWithImpl(this._self, this._then);

  final CatalogModel _self;
  final $Res Function(CatalogModel) _then;

/// Create a copy of CatalogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? make = null,Object? name = null,Object? fuelType = freezed,Object? consumptionL100 = freezed,Object? tankCapacityL = freezed,Object? powerPs = freezed,}) {
  return _then(_self.copyWith(
make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fuelType: freezed == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType?,consumptionL100: freezed == consumptionL100 ? _self.consumptionL100 : consumptionL100 // ignore: cast_nullable_to_non_nullable
as double?,tankCapacityL: freezed == tankCapacityL ? _self.tankCapacityL : tankCapacityL // ignore: cast_nullable_to_non_nullable
as double?,powerPs: freezed == powerPs ? _self.powerPs : powerPs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogModel].
extension CatalogModelPatterns on CatalogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogModel value)  $default,){
final _that = this;
switch (_that) {
case _CatalogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogModel value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String make,  String name,  FuelType? fuelType,  double? consumptionL100,  double? tankCapacityL,  int? powerPs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogModel() when $default != null:
return $default(_that.make,_that.name,_that.fuelType,_that.consumptionL100,_that.tankCapacityL,_that.powerPs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String make,  String name,  FuelType? fuelType,  double? consumptionL100,  double? tankCapacityL,  int? powerPs)  $default,) {final _that = this;
switch (_that) {
case _CatalogModel():
return $default(_that.make,_that.name,_that.fuelType,_that.consumptionL100,_that.tankCapacityL,_that.powerPs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String make,  String name,  FuelType? fuelType,  double? consumptionL100,  double? tankCapacityL,  int? powerPs)?  $default,) {final _that = this;
switch (_that) {
case _CatalogModel() when $default != null:
return $default(_that.make,_that.name,_that.fuelType,_that.consumptionL100,_that.tankCapacityL,_that.powerPs);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogModel implements CatalogModel {
  const _CatalogModel({required this.make, required this.name, this.fuelType, this.consumptionL100, this.tankCapacityL, this.powerPs});
  

@override final  String make;
@override final  String name;
@override final  FuelType? fuelType;
@override final  double? consumptionL100;
@override final  double? tankCapacityL;
@override final  int? powerPs;

/// Create a copy of CatalogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogModelCopyWith<_CatalogModel> get copyWith => __$CatalogModelCopyWithImpl<_CatalogModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogModel&&(identical(other.make, make) || other.make == make)&&(identical(other.name, name) || other.name == name)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.consumptionL100, consumptionL100) || other.consumptionL100 == consumptionL100)&&(identical(other.tankCapacityL, tankCapacityL) || other.tankCapacityL == tankCapacityL)&&(identical(other.powerPs, powerPs) || other.powerPs == powerPs));
}


@override
int get hashCode => Object.hash(runtimeType,make,name,fuelType,consumptionL100,tankCapacityL,powerPs);

@override
String toString() {
  return 'CatalogModel(make: $make, name: $name, fuelType: $fuelType, consumptionL100: $consumptionL100, tankCapacityL: $tankCapacityL, powerPs: $powerPs)';
}


}

/// @nodoc
abstract mixin class _$CatalogModelCopyWith<$Res> implements $CatalogModelCopyWith<$Res> {
  factory _$CatalogModelCopyWith(_CatalogModel value, $Res Function(_CatalogModel) _then) = __$CatalogModelCopyWithImpl;
@override @useResult
$Res call({
 String make, String name, FuelType? fuelType, double? consumptionL100, double? tankCapacityL, int? powerPs
});




}
/// @nodoc
class __$CatalogModelCopyWithImpl<$Res>
    implements _$CatalogModelCopyWith<$Res> {
  __$CatalogModelCopyWithImpl(this._self, this._then);

  final _CatalogModel _self;
  final $Res Function(_CatalogModel) _then;

/// Create a copy of CatalogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? make = null,Object? name = null,Object? fuelType = freezed,Object? consumptionL100 = freezed,Object? tankCapacityL = freezed,Object? powerPs = freezed,}) {
  return _then(_CatalogModel(
make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fuelType: freezed == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType?,consumptionL100: freezed == consumptionL100 ? _self.consumptionL100 : consumptionL100 // ignore: cast_nullable_to_non_nullable
as double?,tankCapacityL: freezed == tankCapacityL ? _self.tankCapacityL : tankCapacityL // ignore: cast_nullable_to_non_nullable
as double?,powerPs: freezed == powerPs ? _self.powerPs : powerPs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
