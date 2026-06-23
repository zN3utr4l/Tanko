// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detected_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetectedStation {

 String get name; double get latitude; double get longitude; double get distanceMeters; StationSource get source;
/// Create a copy of DetectedStation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetectedStationCopyWith<DetectedStation> get copyWith => _$DetectedStationCopyWithImpl<DetectedStation>(this as DetectedStation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetectedStation&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,name,latitude,longitude,distanceMeters,source);

@override
String toString() {
  return 'DetectedStation(name: $name, latitude: $latitude, longitude: $longitude, distanceMeters: $distanceMeters, source: $source)';
}


}

/// @nodoc
abstract mixin class $DetectedStationCopyWith<$Res>  {
  factory $DetectedStationCopyWith(DetectedStation value, $Res Function(DetectedStation) _then) = _$DetectedStationCopyWithImpl;
@useResult
$Res call({
 String name, double latitude, double longitude, double distanceMeters, StationSource source
});




}
/// @nodoc
class _$DetectedStationCopyWithImpl<$Res>
    implements $DetectedStationCopyWith<$Res> {
  _$DetectedStationCopyWithImpl(this._self, this._then);

  final DetectedStation _self;
  final $Res Function(DetectedStation) _then;

/// Create a copy of DetectedStation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? latitude = null,Object? longitude = null,Object? distanceMeters = null,Object? source = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as StationSource,
  ));
}

}


/// Adds pattern-matching-related methods to [DetectedStation].
extension DetectedStationPatterns on DetectedStation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetectedStation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetectedStation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetectedStation value)  $default,){
final _that = this;
switch (_that) {
case _DetectedStation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetectedStation value)?  $default,){
final _that = this;
switch (_that) {
case _DetectedStation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double latitude,  double longitude,  double distanceMeters,  StationSource source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetectedStation() when $default != null:
return $default(_that.name,_that.latitude,_that.longitude,_that.distanceMeters,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double latitude,  double longitude,  double distanceMeters,  StationSource source)  $default,) {final _that = this;
switch (_that) {
case _DetectedStation():
return $default(_that.name,_that.latitude,_that.longitude,_that.distanceMeters,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double latitude,  double longitude,  double distanceMeters,  StationSource source)?  $default,) {final _that = this;
switch (_that) {
case _DetectedStation() when $default != null:
return $default(_that.name,_that.latitude,_that.longitude,_that.distanceMeters,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _DetectedStation implements DetectedStation {
  const _DetectedStation({required this.name, required this.latitude, required this.longitude, required this.distanceMeters, required this.source});
  

@override final  String name;
@override final  double latitude;
@override final  double longitude;
@override final  double distanceMeters;
@override final  StationSource source;

/// Create a copy of DetectedStation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetectedStationCopyWith<_DetectedStation> get copyWith => __$DetectedStationCopyWithImpl<_DetectedStation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetectedStation&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,name,latitude,longitude,distanceMeters,source);

@override
String toString() {
  return 'DetectedStation(name: $name, latitude: $latitude, longitude: $longitude, distanceMeters: $distanceMeters, source: $source)';
}


}

/// @nodoc
abstract mixin class _$DetectedStationCopyWith<$Res> implements $DetectedStationCopyWith<$Res> {
  factory _$DetectedStationCopyWith(_DetectedStation value, $Res Function(_DetectedStation) _then) = __$DetectedStationCopyWithImpl;
@override @useResult
$Res call({
 String name, double latitude, double longitude, double distanceMeters, StationSource source
});




}
/// @nodoc
class __$DetectedStationCopyWithImpl<$Res>
    implements _$DetectedStationCopyWith<$Res> {
  __$DetectedStationCopyWithImpl(this._self, this._then);

  final _DetectedStation _self;
  final $Res Function(_DetectedStation) _then;

/// Create a copy of DetectedStation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? latitude = null,Object? longitude = null,Object? distanceMeters = null,Object? source = null,}) {
  return _then(_DetectedStation(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as StationSource,
  ));
}


}

// dart format on
