// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fill_up.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FillUp {

 int get id; int get vehicleId; DateTime get date; double get amount; double? get liters; double get odometer; bool get isFull; double? get rangeKm; String? get station; int get categoryId; String? get note; double? get latitude; double? get longitude; String? get receiptPhotoPath; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of FillUp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FillUpCopyWith<FillUp> get copyWith => _$FillUpCopyWithImpl<FillUp>(this as FillUp, _$identity);

  /// Serializes this FillUp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FillUp&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.liters, liters) || other.liters == liters)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.isFull, isFull) || other.isFull == isFull)&&(identical(other.rangeKm, rangeKm) || other.rangeKm == rangeKm)&&(identical(other.station, station) || other.station == station)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.note, note) || other.note == note)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.receiptPhotoPath, receiptPhotoPath) || other.receiptPhotoPath == receiptPhotoPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,date,amount,liters,odometer,isFull,rangeKm,station,categoryId,note,latitude,longitude,receiptPhotoPath,createdAt,updatedAt);

@override
String toString() {
  return 'FillUp(id: $id, vehicleId: $vehicleId, date: $date, amount: $amount, liters: $liters, odometer: $odometer, isFull: $isFull, rangeKm: $rangeKm, station: $station, categoryId: $categoryId, note: $note, latitude: $latitude, longitude: $longitude, receiptPhotoPath: $receiptPhotoPath, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FillUpCopyWith<$Res>  {
  factory $FillUpCopyWith(FillUp value, $Res Function(FillUp) _then) = _$FillUpCopyWithImpl;
@useResult
$Res call({
 int id, int vehicleId, DateTime date, double amount, double? liters, double odometer, bool isFull, double? rangeKm, String? station, int categoryId, String? note, double? latitude, double? longitude, String? receiptPhotoPath, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$FillUpCopyWithImpl<$Res>
    implements $FillUpCopyWith<$Res> {
  _$FillUpCopyWithImpl(this._self, this._then);

  final FillUp _self;
  final $Res Function(FillUp) _then;

/// Create a copy of FillUp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? amount = null,Object? liters = freezed,Object? odometer = null,Object? isFull = null,Object? rangeKm = freezed,Object? station = freezed,Object? categoryId = null,Object? note = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? receiptPhotoPath = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,liters: freezed == liters ? _self.liters : liters // ignore: cast_nullable_to_non_nullable
as double?,odometer: null == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as double,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,rangeKm: freezed == rangeKm ? _self.rangeKm : rangeKm // ignore: cast_nullable_to_non_nullable
as double?,station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,receiptPhotoPath: freezed == receiptPhotoPath ? _self.receiptPhotoPath : receiptPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FillUp].
extension FillUpPatterns on FillUp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FillUp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FillUp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FillUp value)  $default,){
final _that = this;
switch (_that) {
case _FillUp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FillUp value)?  $default,){
final _that = this;
switch (_that) {
case _FillUp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int vehicleId,  DateTime date,  double amount,  double? liters,  double odometer,  bool isFull,  double? rangeKm,  String? station,  int categoryId,  String? note,  double? latitude,  double? longitude,  String? receiptPhotoPath,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FillUp() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.amount,_that.liters,_that.odometer,_that.isFull,_that.rangeKm,_that.station,_that.categoryId,_that.note,_that.latitude,_that.longitude,_that.receiptPhotoPath,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int vehicleId,  DateTime date,  double amount,  double? liters,  double odometer,  bool isFull,  double? rangeKm,  String? station,  int categoryId,  String? note,  double? latitude,  double? longitude,  String? receiptPhotoPath,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FillUp():
return $default(_that.id,_that.vehicleId,_that.date,_that.amount,_that.liters,_that.odometer,_that.isFull,_that.rangeKm,_that.station,_that.categoryId,_that.note,_that.latitude,_that.longitude,_that.receiptPhotoPath,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int vehicleId,  DateTime date,  double amount,  double? liters,  double odometer,  bool isFull,  double? rangeKm,  String? station,  int categoryId,  String? note,  double? latitude,  double? longitude,  String? receiptPhotoPath,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FillUp() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.amount,_that.liters,_that.odometer,_that.isFull,_that.rangeKm,_that.station,_that.categoryId,_that.note,_that.latitude,_that.longitude,_that.receiptPhotoPath,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FillUp implements FillUp {
  const _FillUp({required this.id, required this.vehicleId, required this.date, required this.amount, this.liters, required this.odometer, this.isFull = true, this.rangeKm, this.station, required this.categoryId, this.note, this.latitude, this.longitude, this.receiptPhotoPath, required this.createdAt, required this.updatedAt});
  factory _FillUp.fromJson(Map<String, dynamic> json) => _$FillUpFromJson(json);

@override final  int id;
@override final  int vehicleId;
@override final  DateTime date;
@override final  double amount;
@override final  double? liters;
@override final  double odometer;
@override@JsonKey() final  bool isFull;
@override final  double? rangeKm;
@override final  String? station;
@override final  int categoryId;
@override final  String? note;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? receiptPhotoPath;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of FillUp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FillUpCopyWith<_FillUp> get copyWith => __$FillUpCopyWithImpl<_FillUp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FillUpToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FillUp&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.liters, liters) || other.liters == liters)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.isFull, isFull) || other.isFull == isFull)&&(identical(other.rangeKm, rangeKm) || other.rangeKm == rangeKm)&&(identical(other.station, station) || other.station == station)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.note, note) || other.note == note)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.receiptPhotoPath, receiptPhotoPath) || other.receiptPhotoPath == receiptPhotoPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,date,amount,liters,odometer,isFull,rangeKm,station,categoryId,note,latitude,longitude,receiptPhotoPath,createdAt,updatedAt);

@override
String toString() {
  return 'FillUp(id: $id, vehicleId: $vehicleId, date: $date, amount: $amount, liters: $liters, odometer: $odometer, isFull: $isFull, rangeKm: $rangeKm, station: $station, categoryId: $categoryId, note: $note, latitude: $latitude, longitude: $longitude, receiptPhotoPath: $receiptPhotoPath, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FillUpCopyWith<$Res> implements $FillUpCopyWith<$Res> {
  factory _$FillUpCopyWith(_FillUp value, $Res Function(_FillUp) _then) = __$FillUpCopyWithImpl;
@override @useResult
$Res call({
 int id, int vehicleId, DateTime date, double amount, double? liters, double odometer, bool isFull, double? rangeKm, String? station, int categoryId, String? note, double? latitude, double? longitude, String? receiptPhotoPath, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$FillUpCopyWithImpl<$Res>
    implements _$FillUpCopyWith<$Res> {
  __$FillUpCopyWithImpl(this._self, this._then);

  final _FillUp _self;
  final $Res Function(_FillUp) _then;

/// Create a copy of FillUp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? amount = null,Object? liters = freezed,Object? odometer = null,Object? isFull = null,Object? rangeKm = freezed,Object? station = freezed,Object? categoryId = null,Object? note = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? receiptPhotoPath = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FillUp(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,liters: freezed == liters ? _self.liters : liters // ignore: cast_nullable_to_non_nullable
as double?,odometer: null == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as double,isFull: null == isFull ? _self.isFull : isFull // ignore: cast_nullable_to_non_nullable
as bool,rangeKm: freezed == rangeKm ? _self.rangeKm : rangeKm // ignore: cast_nullable_to_non_nullable
as double?,station: freezed == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,receiptPhotoPath: freezed == receiptPhotoPath ? _self.receiptPhotoPath : receiptPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
