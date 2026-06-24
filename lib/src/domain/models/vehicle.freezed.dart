// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VehicleSpecs {

 double? get tankCapacityL; double? get mfrConsumption; double? get mfrRangeKm; int? get powerPs; SpecSource get source; String? get catalogRef;
/// Create a copy of VehicleSpecs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleSpecsCopyWith<VehicleSpecs> get copyWith => _$VehicleSpecsCopyWithImpl<VehicleSpecs>(this as VehicleSpecs, _$identity);

  /// Serializes this VehicleSpecs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleSpecs&&(identical(other.tankCapacityL, tankCapacityL) || other.tankCapacityL == tankCapacityL)&&(identical(other.mfrConsumption, mfrConsumption) || other.mfrConsumption == mfrConsumption)&&(identical(other.mfrRangeKm, mfrRangeKm) || other.mfrRangeKm == mfrRangeKm)&&(identical(other.powerPs, powerPs) || other.powerPs == powerPs)&&(identical(other.source, source) || other.source == source)&&(identical(other.catalogRef, catalogRef) || other.catalogRef == catalogRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tankCapacityL,mfrConsumption,mfrRangeKm,powerPs,source,catalogRef);

@override
String toString() {
  return 'VehicleSpecs(tankCapacityL: $tankCapacityL, mfrConsumption: $mfrConsumption, mfrRangeKm: $mfrRangeKm, powerPs: $powerPs, source: $source, catalogRef: $catalogRef)';
}


}

/// @nodoc
abstract mixin class $VehicleSpecsCopyWith<$Res>  {
  factory $VehicleSpecsCopyWith(VehicleSpecs value, $Res Function(VehicleSpecs) _then) = _$VehicleSpecsCopyWithImpl;
@useResult
$Res call({
 double? tankCapacityL, double? mfrConsumption, double? mfrRangeKm, int? powerPs, SpecSource source, String? catalogRef
});




}
/// @nodoc
class _$VehicleSpecsCopyWithImpl<$Res>
    implements $VehicleSpecsCopyWith<$Res> {
  _$VehicleSpecsCopyWithImpl(this._self, this._then);

  final VehicleSpecs _self;
  final $Res Function(VehicleSpecs) _then;

/// Create a copy of VehicleSpecs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tankCapacityL = freezed,Object? mfrConsumption = freezed,Object? mfrRangeKm = freezed,Object? powerPs = freezed,Object? source = null,Object? catalogRef = freezed,}) {
  return _then(_self.copyWith(
tankCapacityL: freezed == tankCapacityL ? _self.tankCapacityL : tankCapacityL // ignore: cast_nullable_to_non_nullable
as double?,mfrConsumption: freezed == mfrConsumption ? _self.mfrConsumption : mfrConsumption // ignore: cast_nullable_to_non_nullable
as double?,mfrRangeKm: freezed == mfrRangeKm ? _self.mfrRangeKm : mfrRangeKm // ignore: cast_nullable_to_non_nullable
as double?,powerPs: freezed == powerPs ? _self.powerPs : powerPs // ignore: cast_nullable_to_non_nullable
as int?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SpecSource,catalogRef: freezed == catalogRef ? _self.catalogRef : catalogRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleSpecs].
extension VehicleSpecsPatterns on VehicleSpecs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleSpecs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleSpecs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleSpecs value)  $default,){
final _that = this;
switch (_that) {
case _VehicleSpecs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleSpecs value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleSpecs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? tankCapacityL,  double? mfrConsumption,  double? mfrRangeKm,  int? powerPs,  SpecSource source,  String? catalogRef)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleSpecs() when $default != null:
return $default(_that.tankCapacityL,_that.mfrConsumption,_that.mfrRangeKm,_that.powerPs,_that.source,_that.catalogRef);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? tankCapacityL,  double? mfrConsumption,  double? mfrRangeKm,  int? powerPs,  SpecSource source,  String? catalogRef)  $default,) {final _that = this;
switch (_that) {
case _VehicleSpecs():
return $default(_that.tankCapacityL,_that.mfrConsumption,_that.mfrRangeKm,_that.powerPs,_that.source,_that.catalogRef);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? tankCapacityL,  double? mfrConsumption,  double? mfrRangeKm,  int? powerPs,  SpecSource source,  String? catalogRef)?  $default,) {final _that = this;
switch (_that) {
case _VehicleSpecs() when $default != null:
return $default(_that.tankCapacityL,_that.mfrConsumption,_that.mfrRangeKm,_that.powerPs,_that.source,_that.catalogRef);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleSpecs implements VehicleSpecs {
  const _VehicleSpecs({this.tankCapacityL, this.mfrConsumption, this.mfrRangeKm, this.powerPs, this.source = SpecSource.manual, this.catalogRef});
  factory _VehicleSpecs.fromJson(Map<String, dynamic> json) => _$VehicleSpecsFromJson(json);

@override final  double? tankCapacityL;
@override final  double? mfrConsumption;
@override final  double? mfrRangeKm;
@override final  int? powerPs;
@override@JsonKey() final  SpecSource source;
@override final  String? catalogRef;

/// Create a copy of VehicleSpecs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleSpecsCopyWith<_VehicleSpecs> get copyWith => __$VehicleSpecsCopyWithImpl<_VehicleSpecs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleSpecsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleSpecs&&(identical(other.tankCapacityL, tankCapacityL) || other.tankCapacityL == tankCapacityL)&&(identical(other.mfrConsumption, mfrConsumption) || other.mfrConsumption == mfrConsumption)&&(identical(other.mfrRangeKm, mfrRangeKm) || other.mfrRangeKm == mfrRangeKm)&&(identical(other.powerPs, powerPs) || other.powerPs == powerPs)&&(identical(other.source, source) || other.source == source)&&(identical(other.catalogRef, catalogRef) || other.catalogRef == catalogRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tankCapacityL,mfrConsumption,mfrRangeKm,powerPs,source,catalogRef);

@override
String toString() {
  return 'VehicleSpecs(tankCapacityL: $tankCapacityL, mfrConsumption: $mfrConsumption, mfrRangeKm: $mfrRangeKm, powerPs: $powerPs, source: $source, catalogRef: $catalogRef)';
}


}

/// @nodoc
abstract mixin class _$VehicleSpecsCopyWith<$Res> implements $VehicleSpecsCopyWith<$Res> {
  factory _$VehicleSpecsCopyWith(_VehicleSpecs value, $Res Function(_VehicleSpecs) _then) = __$VehicleSpecsCopyWithImpl;
@override @useResult
$Res call({
 double? tankCapacityL, double? mfrConsumption, double? mfrRangeKm, int? powerPs, SpecSource source, String? catalogRef
});




}
/// @nodoc
class __$VehicleSpecsCopyWithImpl<$Res>
    implements _$VehicleSpecsCopyWith<$Res> {
  __$VehicleSpecsCopyWithImpl(this._self, this._then);

  final _VehicleSpecs _self;
  final $Res Function(_VehicleSpecs) _then;

/// Create a copy of VehicleSpecs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tankCapacityL = freezed,Object? mfrConsumption = freezed,Object? mfrRangeKm = freezed,Object? powerPs = freezed,Object? source = null,Object? catalogRef = freezed,}) {
  return _then(_VehicleSpecs(
tankCapacityL: freezed == tankCapacityL ? _self.tankCapacityL : tankCapacityL // ignore: cast_nullable_to_non_nullable
as double?,mfrConsumption: freezed == mfrConsumption ? _self.mfrConsumption : mfrConsumption // ignore: cast_nullable_to_non_nullable
as double?,mfrRangeKm: freezed == mfrRangeKm ? _self.mfrRangeKm : mfrRangeKm // ignore: cast_nullable_to_non_nullable
as double?,powerPs: freezed == powerPs ? _self.powerPs : powerPs // ignore: cast_nullable_to_non_nullable
as int?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SpecSource,catalogRef: freezed == catalogRef ? _self.catalogRef : catalogRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Vehicle {

 int get id; String get make; String get model; int? get year; String? get trim; FuelType get fuelType; String? get plate; EuroClass? get euroClass; int get colorTag; bool get isDefault; VehicleSpecs get specs; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleCopyWith<Vehicle> get copyWith => _$VehicleCopyWithImpl<Vehicle>(this as Vehicle, _$identity);

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.trim, trim) || other.trim == trim)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.plate, plate) || other.plate == plate)&&(identical(other.euroClass, euroClass) || other.euroClass == euroClass)&&(identical(other.colorTag, colorTag) || other.colorTag == colorTag)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.specs, specs) || other.specs == specs)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,make,model,year,trim,fuelType,plate,euroClass,colorTag,isDefault,specs,createdAt,updatedAt);

@override
String toString() {
  return 'Vehicle(id: $id, make: $make, model: $model, year: $year, trim: $trim, fuelType: $fuelType, plate: $plate, euroClass: $euroClass, colorTag: $colorTag, isDefault: $isDefault, specs: $specs, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $VehicleCopyWith<$Res>  {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) _then) = _$VehicleCopyWithImpl;
@useResult
$Res call({
 int id, String make, String model, int? year, String? trim, FuelType fuelType, String? plate, EuroClass? euroClass, int colorTag, bool isDefault, VehicleSpecs specs, DateTime createdAt, DateTime updatedAt
});


$VehicleSpecsCopyWith<$Res> get specs;

}
/// @nodoc
class _$VehicleCopyWithImpl<$Res>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._self, this._then);

  final Vehicle _self;
  final $Res Function(Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? make = null,Object? model = null,Object? year = freezed,Object? trim = freezed,Object? fuelType = null,Object? plate = freezed,Object? euroClass = freezed,Object? colorTag = null,Object? isDefault = null,Object? specs = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,trim: freezed == trim ? _self.trim : trim // ignore: cast_nullable_to_non_nullable
as String?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,plate: freezed == plate ? _self.plate : plate // ignore: cast_nullable_to_non_nullable
as String?,euroClass: freezed == euroClass ? _self.euroClass : euroClass // ignore: cast_nullable_to_non_nullable
as EuroClass?,colorTag: null == colorTag ? _self.colorTag : colorTag // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,specs: null == specs ? _self.specs : specs // ignore: cast_nullable_to_non_nullable
as VehicleSpecs,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleSpecsCopyWith<$Res> get specs {
  
  return $VehicleSpecsCopyWith<$Res>(_self.specs, (value) {
    return _then(_self.copyWith(specs: value));
  });
}
}


/// Adds pattern-matching-related methods to [Vehicle].
extension VehiclePatterns on Vehicle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vehicle value)  $default,){
final _that = this;
switch (_that) {
case _Vehicle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vehicle value)?  $default,){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String make,  String model,  int? year,  String? trim,  FuelType fuelType,  String? plate,  EuroClass? euroClass,  int colorTag,  bool isDefault,  VehicleSpecs specs,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.make,_that.model,_that.year,_that.trim,_that.fuelType,_that.plate,_that.euroClass,_that.colorTag,_that.isDefault,_that.specs,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String make,  String model,  int? year,  String? trim,  FuelType fuelType,  String? plate,  EuroClass? euroClass,  int colorTag,  bool isDefault,  VehicleSpecs specs,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Vehicle():
return $default(_that.id,_that.make,_that.model,_that.year,_that.trim,_that.fuelType,_that.plate,_that.euroClass,_that.colorTag,_that.isDefault,_that.specs,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String make,  String model,  int? year,  String? trim,  FuelType fuelType,  String? plate,  EuroClass? euroClass,  int colorTag,  bool isDefault,  VehicleSpecs specs,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.make,_that.model,_that.year,_that.trim,_that.fuelType,_that.plate,_that.euroClass,_that.colorTag,_that.isDefault,_that.specs,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vehicle implements Vehicle {
  const _Vehicle({required this.id, required this.make, required this.model, this.year, this.trim, required this.fuelType, this.plate, this.euroClass, this.colorTag = 0, this.isDefault = false, this.specs = const VehicleSpecs(), required this.createdAt, required this.updatedAt});
  factory _Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

@override final  int id;
@override final  String make;
@override final  String model;
@override final  int? year;
@override final  String? trim;
@override final  FuelType fuelType;
@override final  String? plate;
@override final  EuroClass? euroClass;
@override@JsonKey() final  int colorTag;
@override@JsonKey() final  bool isDefault;
@override@JsonKey() final  VehicleSpecs specs;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleCopyWith<_Vehicle> get copyWith => __$VehicleCopyWithImpl<_Vehicle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.trim, trim) || other.trim == trim)&&(identical(other.fuelType, fuelType) || other.fuelType == fuelType)&&(identical(other.plate, plate) || other.plate == plate)&&(identical(other.euroClass, euroClass) || other.euroClass == euroClass)&&(identical(other.colorTag, colorTag) || other.colorTag == colorTag)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.specs, specs) || other.specs == specs)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,make,model,year,trim,fuelType,plate,euroClass,colorTag,isDefault,specs,createdAt,updatedAt);

@override
String toString() {
  return 'Vehicle(id: $id, make: $make, model: $model, year: $year, trim: $trim, fuelType: $fuelType, plate: $plate, euroClass: $euroClass, colorTag: $colorTag, isDefault: $isDefault, specs: $specs, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$VehicleCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$VehicleCopyWith(_Vehicle value, $Res Function(_Vehicle) _then) = __$VehicleCopyWithImpl;
@override @useResult
$Res call({
 int id, String make, String model, int? year, String? trim, FuelType fuelType, String? plate, EuroClass? euroClass, int colorTag, bool isDefault, VehicleSpecs specs, DateTime createdAt, DateTime updatedAt
});


@override $VehicleSpecsCopyWith<$Res> get specs;

}
/// @nodoc
class __$VehicleCopyWithImpl<$Res>
    implements _$VehicleCopyWith<$Res> {
  __$VehicleCopyWithImpl(this._self, this._then);

  final _Vehicle _self;
  final $Res Function(_Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? make = null,Object? model = null,Object? year = freezed,Object? trim = freezed,Object? fuelType = null,Object? plate = freezed,Object? euroClass = freezed,Object? colorTag = null,Object? isDefault = null,Object? specs = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Vehicle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,trim: freezed == trim ? _self.trim : trim // ignore: cast_nullable_to_non_nullable
as String?,fuelType: null == fuelType ? _self.fuelType : fuelType // ignore: cast_nullable_to_non_nullable
as FuelType,plate: freezed == plate ? _self.plate : plate // ignore: cast_nullable_to_non_nullable
as String?,euroClass: freezed == euroClass ? _self.euroClass : euroClass // ignore: cast_nullable_to_non_nullable
as EuroClass?,colorTag: null == colorTag ? _self.colorTag : colorTag // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,specs: null == specs ? _self.specs : specs // ignore: cast_nullable_to_non_nullable
as VehicleSpecs,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleSpecsCopyWith<$Res> get specs {
  
  return $VehicleSpecsCopyWith<$Res>(_self.specs, (value) {
    return _then(_self.copyWith(specs: value));
  });
}
}

// dart format on
