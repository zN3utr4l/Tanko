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
mixin _$CatalogMake {

 String get id; String get name;
/// Create a copy of CatalogMake
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogMakeCopyWith<CatalogMake> get copyWith => _$CatalogMakeCopyWithImpl<CatalogMake>(this as CatalogMake, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogMake&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'CatalogMake(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $CatalogMakeCopyWith<$Res>  {
  factory $CatalogMakeCopyWith(CatalogMake value, $Res Function(CatalogMake) _then) = _$CatalogMakeCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$CatalogMakeCopyWithImpl<$Res>
    implements $CatalogMakeCopyWith<$Res> {
  _$CatalogMakeCopyWithImpl(this._self, this._then);

  final CatalogMake _self;
  final $Res Function(CatalogMake) _then;

/// Create a copy of CatalogMake
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogMake].
extension CatalogMakePatterns on CatalogMake {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogMake value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogMake() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogMake value)  $default,){
final _that = this;
switch (_that) {
case _CatalogMake():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogMake value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogMake() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogMake() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _CatalogMake():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _CatalogMake() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogMake implements CatalogMake {
  const _CatalogMake({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of CatalogMake
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogMakeCopyWith<_CatalogMake> get copyWith => __$CatalogMakeCopyWithImpl<_CatalogMake>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogMake&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'CatalogMake(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$CatalogMakeCopyWith<$Res> implements $CatalogMakeCopyWith<$Res> {
  factory _$CatalogMakeCopyWith(_CatalogMake value, $Res Function(_CatalogMake) _then) = __$CatalogMakeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$CatalogMakeCopyWithImpl<$Res>
    implements _$CatalogMakeCopyWith<$Res> {
  __$CatalogMakeCopyWithImpl(this._self, this._then);

  final _CatalogMake _self;
  final $Res Function(_CatalogMake) _then;

/// Create a copy of CatalogMake
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_CatalogMake(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CatalogTrim {

 String get modelId; String get make; String get model; int? get year; String? get trim; FuelType? get fuelType; double? get consumptionL100; double? get tankCapacityL; int? get powerPs;
/// Create a copy of CatalogTrim
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogTrimCopyWith<CatalogTrim> get copyWith => _$CatalogTrimCopyWithImpl<CatalogTrim>(this as CatalogTrim, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogTrim&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.trim, trim) || other.trim == trim)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.consumptionL100, consumptionL100) || other.consumptionL100 == consumptionL100)&&(identical(other.tankCapacityL, tankCapacityL) || other.tankCapacityL == tankCapacityL)&&(identical(other.powerPs, powerPs) || other.powerPs == powerPs));
}


@override
int get hashCode => Object.hash(runtimeType,modelId,make,model,year,trim,fuelType,consumptionL100,tankCapacityL,powerPs);

@override
String toString() {
  return 'CatalogTrim(modelId: $modelId, make: $make, model: $model, year: $year, trim: $trim, fuelType: $fuelType, consumptionL100: $consumptionL100, tankCapacityL: $tankCapacityL, powerPs: $powerPs)';
}


}

/// @nodoc
abstract mixin class $CatalogTrimCopyWith<$Res>  {
  factory $CatalogTrimCopyWith(CatalogTrim value, $Res Function(CatalogTrim) _then) = _$CatalogTrimCopyWithImpl;
@useResult
$Res call({
 String modelId, String make, String model, int? year, String? trim, FuelType? fuelType, double? consumptionL100, double? tankCapacityL, int? powerPs
});




}
/// @nodoc
class _$CatalogTrimCopyWithImpl<$Res>
    implements $CatalogTrimCopyWith<$Res> {
  _$CatalogTrimCopyWithImpl(this._self, this._then);

  final CatalogTrim _self;
  final $Res Function(CatalogTrim) _then;

/// Create a copy of CatalogTrim
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? modelId = null,Object? make = null,Object? model = null,Object? year = freezed,Object? trim = freezed,Object? fuelType = freezed,Object? consumptionL100 = freezed,Object? tankCapacityL = freezed,Object? powerPs = freezed,}) {
  return _then(_self.copyWith(
modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,trim: freezed == trim ? _self.trim : trim // ignore: cast_nullable_to_non_nullable
as String?,fuelType: freezed == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType?,consumptionL100: freezed == consumptionL100 ? _self.consumptionL100 : consumptionL100 // ignore: cast_nullable_to_non_nullable
as double?,tankCapacityL: freezed == tankCapacityL ? _self.tankCapacityL : tankCapacityL // ignore: cast_nullable_to_non_nullable
as double?,powerPs: freezed == powerPs ? _self.powerPs : powerPs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogTrim].
extension CatalogTrimPatterns on CatalogTrim {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogTrim value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogTrim() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogTrim value)  $default,){
final _that = this;
switch (_that) {
case _CatalogTrim():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogTrim value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogTrim() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String modelId,  String make,  String model,  int? year,  String? trim,  FuelType? fuelType,  double? consumptionL100,  double? tankCapacityL,  int? powerPs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogTrim() when $default != null:
return $default(_that.modelId,_that.make,_that.model,_that.year,_that.trim,_that.fuelType,_that.consumptionL100,_that.tankCapacityL,_that.powerPs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String modelId,  String make,  String model,  int? year,  String? trim,  FuelType? fuelType,  double? consumptionL100,  double? tankCapacityL,  int? powerPs)  $default,) {final _that = this;
switch (_that) {
case _CatalogTrim():
return $default(_that.modelId,_that.make,_that.model,_that.year,_that.trim,_that.fuelType,_that.consumptionL100,_that.tankCapacityL,_that.powerPs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String modelId,  String make,  String model,  int? year,  String? trim,  FuelType? fuelType,  double? consumptionL100,  double? tankCapacityL,  int? powerPs)?  $default,) {final _that = this;
switch (_that) {
case _CatalogTrim() when $default != null:
return $default(_that.modelId,_that.make,_that.model,_that.year,_that.trim,_that.fuelType,_that.consumptionL100,_that.tankCapacityL,_that.powerPs);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogTrim extends CatalogTrim {
  const _CatalogTrim({required this.modelId, required this.make, required this.model, this.year, this.trim, this.fuelType, this.consumptionL100, this.tankCapacityL, this.powerPs}): super._();
  

@override final  String modelId;
@override final  String make;
@override final  String model;
@override final  int? year;
@override final  String? trim;
@override final  FuelType? fuelType;
@override final  double? consumptionL100;
@override final  double? tankCapacityL;
@override final  int? powerPs;

/// Create a copy of CatalogTrim
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogTrimCopyWith<_CatalogTrim> get copyWith => __$CatalogTrimCopyWithImpl<_CatalogTrim>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogTrim&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.trim, trim) || other.trim == trim)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.consumptionL100, consumptionL100) || other.consumptionL100 == consumptionL100)&&(identical(other.tankCapacityL, tankCapacityL) || other.tankCapacityL == tankCapacityL)&&(identical(other.powerPs, powerPs) || other.powerPs == powerPs));
}


@override
int get hashCode => Object.hash(runtimeType,modelId,make,model,year,trim,fuelType,consumptionL100,tankCapacityL,powerPs);

@override
String toString() {
  return 'CatalogTrim(modelId: $modelId, make: $make, model: $model, year: $year, trim: $trim, fuelType: $fuelType, consumptionL100: $consumptionL100, tankCapacityL: $tankCapacityL, powerPs: $powerPs)';
}


}

/// @nodoc
abstract mixin class _$CatalogTrimCopyWith<$Res> implements $CatalogTrimCopyWith<$Res> {
  factory _$CatalogTrimCopyWith(_CatalogTrim value, $Res Function(_CatalogTrim) _then) = __$CatalogTrimCopyWithImpl;
@override @useResult
$Res call({
 String modelId, String make, String model, int? year, String? trim, FuelType? fuelType, double? consumptionL100, double? tankCapacityL, int? powerPs
});




}
/// @nodoc
class __$CatalogTrimCopyWithImpl<$Res>
    implements _$CatalogTrimCopyWith<$Res> {
  __$CatalogTrimCopyWithImpl(this._self, this._then);

  final _CatalogTrim _self;
  final $Res Function(_CatalogTrim) _then;

/// Create a copy of CatalogTrim
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? modelId = null,Object? make = null,Object? model = null,Object? year = freezed,Object? trim = freezed,Object? fuelType = freezed,Object? consumptionL100 = freezed,Object? tankCapacityL = freezed,Object? powerPs = freezed,}) {
  return _then(_CatalogTrim(
modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,trim: freezed == trim ? _self.trim : trim // ignore: cast_nullable_to_non_nullable
as String?,fuelType: freezed == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType?,consumptionL100: freezed == consumptionL100 ? _self.consumptionL100 : consumptionL100 // ignore: cast_nullable_to_non_nullable
as double?,tankCapacityL: freezed == tankCapacityL ? _self.tankCapacityL : tankCapacityL // ignore: cast_nullable_to_non_nullable
as double?,powerPs: freezed == powerPs ? _self.powerPs : powerPs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
