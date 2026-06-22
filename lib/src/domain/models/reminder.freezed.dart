// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reminder {

 int get id; int get vehicleId; ReminderType get type; String get title; TriggerMode get triggerMode; DateTime? get dueDate; double? get dueOdometer; int? get recurEvery; RecurUnit? get recurUnit; int? get recurKmEvery; int? get leadDays; int? get leadKm; bool get notify; DateTime? get lastCompletedDate; double? get lastCompletedOdometer; int? get linkedExpenseCategoryId; bool get active; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderCopyWith<Reminder> get copyWith => _$ReminderCopyWithImpl<Reminder>(this as Reminder, _$identity);

  /// Serializes this Reminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.triggerMode, triggerMode) || other.triggerMode == triggerMode)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.dueOdometer, dueOdometer) || other.dueOdometer == dueOdometer)&&(identical(other.recurEvery, recurEvery) || other.recurEvery == recurEvery)&&(identical(other.recurUnit, recurUnit) || other.recurUnit == recurUnit)&&(identical(other.recurKmEvery, recurKmEvery) || other.recurKmEvery == recurKmEvery)&&(identical(other.leadDays, leadDays) || other.leadDays == leadDays)&&(identical(other.leadKm, leadKm) || other.leadKm == leadKm)&&(identical(other.notify, notify) || other.notify == notify)&&(identical(other.lastCompletedDate, lastCompletedDate) || other.lastCompletedDate == lastCompletedDate)&&(identical(other.lastCompletedOdometer, lastCompletedOdometer) || other.lastCompletedOdometer == lastCompletedOdometer)&&(identical(other.linkedExpenseCategoryId, linkedExpenseCategoryId) || other.linkedExpenseCategoryId == linkedExpenseCategoryId)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,vehicleId,type,title,triggerMode,dueDate,dueOdometer,recurEvery,recurUnit,recurKmEvery,leadDays,leadKm,notify,lastCompletedDate,lastCompletedOdometer,linkedExpenseCategoryId,active,createdAt,updatedAt]);

@override
String toString() {
  return 'Reminder(id: $id, vehicleId: $vehicleId, type: $type, title: $title, triggerMode: $triggerMode, dueDate: $dueDate, dueOdometer: $dueOdometer, recurEvery: $recurEvery, recurUnit: $recurUnit, recurKmEvery: $recurKmEvery, leadDays: $leadDays, leadKm: $leadKm, notify: $notify, lastCompletedDate: $lastCompletedDate, lastCompletedOdometer: $lastCompletedOdometer, linkedExpenseCategoryId: $linkedExpenseCategoryId, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReminderCopyWith<$Res>  {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) _then) = _$ReminderCopyWithImpl;
@useResult
$Res call({
 int id, int vehicleId, ReminderType type, String title, TriggerMode triggerMode, DateTime? dueDate, double? dueOdometer, int? recurEvery, RecurUnit? recurUnit, int? recurKmEvery, int? leadDays, int? leadKm, bool notify, DateTime? lastCompletedDate, double? lastCompletedOdometer, int? linkedExpenseCategoryId, bool active, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ReminderCopyWithImpl<$Res>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._self, this._then);

  final Reminder _self;
  final $Res Function(Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicleId = null,Object? type = null,Object? title = null,Object? triggerMode = null,Object? dueDate = freezed,Object? dueOdometer = freezed,Object? recurEvery = freezed,Object? recurUnit = freezed,Object? recurKmEvery = freezed,Object? leadDays = freezed,Object? leadKm = freezed,Object? notify = null,Object? lastCompletedDate = freezed,Object? lastCompletedOdometer = freezed,Object? linkedExpenseCategoryId = freezed,Object? active = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ReminderType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,triggerMode: null == triggerMode ? _self.triggerMode : triggerMode // ignore: cast_nullable_to_non_nullable
as TriggerMode,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueOdometer: freezed == dueOdometer ? _self.dueOdometer : dueOdometer // ignore: cast_nullable_to_non_nullable
as double?,recurEvery: freezed == recurEvery ? _self.recurEvery : recurEvery // ignore: cast_nullable_to_non_nullable
as int?,recurUnit: freezed == recurUnit ? _self.recurUnit : recurUnit // ignore: cast_nullable_to_non_nullable
as RecurUnit?,recurKmEvery: freezed == recurKmEvery ? _self.recurKmEvery : recurKmEvery // ignore: cast_nullable_to_non_nullable
as int?,leadDays: freezed == leadDays ? _self.leadDays : leadDays // ignore: cast_nullable_to_non_nullable
as int?,leadKm: freezed == leadKm ? _self.leadKm : leadKm // ignore: cast_nullable_to_non_nullable
as int?,notify: null == notify ? _self.notify : notify // ignore: cast_nullable_to_non_nullable
as bool,lastCompletedDate: freezed == lastCompletedDate ? _self.lastCompletedDate : lastCompletedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastCompletedOdometer: freezed == lastCompletedOdometer ? _self.lastCompletedOdometer : lastCompletedOdometer // ignore: cast_nullable_to_non_nullable
as double?,linkedExpenseCategoryId: freezed == linkedExpenseCategoryId ? _self.linkedExpenseCategoryId : linkedExpenseCategoryId // ignore: cast_nullable_to_non_nullable
as int?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Reminder].
extension ReminderPatterns on Reminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reminder value)  $default,){
final _that = this;
switch (_that) {
case _Reminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reminder value)?  $default,){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int vehicleId,  ReminderType type,  String title,  TriggerMode triggerMode,  DateTime? dueDate,  double? dueOdometer,  int? recurEvery,  RecurUnit? recurUnit,  int? recurKmEvery,  int? leadDays,  int? leadKm,  bool notify,  DateTime? lastCompletedDate,  double? lastCompletedOdometer,  int? linkedExpenseCategoryId,  bool active,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.vehicleId,_that.type,_that.title,_that.triggerMode,_that.dueDate,_that.dueOdometer,_that.recurEvery,_that.recurUnit,_that.recurKmEvery,_that.leadDays,_that.leadKm,_that.notify,_that.lastCompletedDate,_that.lastCompletedOdometer,_that.linkedExpenseCategoryId,_that.active,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int vehicleId,  ReminderType type,  String title,  TriggerMode triggerMode,  DateTime? dueDate,  double? dueOdometer,  int? recurEvery,  RecurUnit? recurUnit,  int? recurKmEvery,  int? leadDays,  int? leadKm,  bool notify,  DateTime? lastCompletedDate,  double? lastCompletedOdometer,  int? linkedExpenseCategoryId,  bool active,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Reminder():
return $default(_that.id,_that.vehicleId,_that.type,_that.title,_that.triggerMode,_that.dueDate,_that.dueOdometer,_that.recurEvery,_that.recurUnit,_that.recurKmEvery,_that.leadDays,_that.leadKm,_that.notify,_that.lastCompletedDate,_that.lastCompletedOdometer,_that.linkedExpenseCategoryId,_that.active,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int vehicleId,  ReminderType type,  String title,  TriggerMode triggerMode,  DateTime? dueDate,  double? dueOdometer,  int? recurEvery,  RecurUnit? recurUnit,  int? recurKmEvery,  int? leadDays,  int? leadKm,  bool notify,  DateTime? lastCompletedDate,  double? lastCompletedOdometer,  int? linkedExpenseCategoryId,  bool active,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.vehicleId,_that.type,_that.title,_that.triggerMode,_that.dueDate,_that.dueOdometer,_that.recurEvery,_that.recurUnit,_that.recurKmEvery,_that.leadDays,_that.leadKm,_that.notify,_that.lastCompletedDate,_that.lastCompletedOdometer,_that.linkedExpenseCategoryId,_that.active,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reminder implements Reminder {
  const _Reminder({required this.id, required this.vehicleId, required this.type, required this.title, required this.triggerMode, this.dueDate, this.dueOdometer, this.recurEvery, this.recurUnit, this.recurKmEvery, this.leadDays, this.leadKm, this.notify = true, this.lastCompletedDate, this.lastCompletedOdometer, this.linkedExpenseCategoryId, this.active = true, required this.createdAt, required this.updatedAt});
  factory _Reminder.fromJson(Map<String, dynamic> json) => _$ReminderFromJson(json);

@override final  int id;
@override final  int vehicleId;
@override final  ReminderType type;
@override final  String title;
@override final  TriggerMode triggerMode;
@override final  DateTime? dueDate;
@override final  double? dueOdometer;
@override final  int? recurEvery;
@override final  RecurUnit? recurUnit;
@override final  int? recurKmEvery;
@override final  int? leadDays;
@override final  int? leadKm;
@override@JsonKey() final  bool notify;
@override final  DateTime? lastCompletedDate;
@override final  double? lastCompletedOdometer;
@override final  int? linkedExpenseCategoryId;
@override@JsonKey() final  bool active;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderCopyWith<_Reminder> get copyWith => __$ReminderCopyWithImpl<_Reminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.triggerMode, triggerMode) || other.triggerMode == triggerMode)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.dueOdometer, dueOdometer) || other.dueOdometer == dueOdometer)&&(identical(other.recurEvery, recurEvery) || other.recurEvery == recurEvery)&&(identical(other.recurUnit, recurUnit) || other.recurUnit == recurUnit)&&(identical(other.recurKmEvery, recurKmEvery) || other.recurKmEvery == recurKmEvery)&&(identical(other.leadDays, leadDays) || other.leadDays == leadDays)&&(identical(other.leadKm, leadKm) || other.leadKm == leadKm)&&(identical(other.notify, notify) || other.notify == notify)&&(identical(other.lastCompletedDate, lastCompletedDate) || other.lastCompletedDate == lastCompletedDate)&&(identical(other.lastCompletedOdometer, lastCompletedOdometer) || other.lastCompletedOdometer == lastCompletedOdometer)&&(identical(other.linkedExpenseCategoryId, linkedExpenseCategoryId) || other.linkedExpenseCategoryId == linkedExpenseCategoryId)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,vehicleId,type,title,triggerMode,dueDate,dueOdometer,recurEvery,recurUnit,recurKmEvery,leadDays,leadKm,notify,lastCompletedDate,lastCompletedOdometer,linkedExpenseCategoryId,active,createdAt,updatedAt]);

@override
String toString() {
  return 'Reminder(id: $id, vehicleId: $vehicleId, type: $type, title: $title, triggerMode: $triggerMode, dueDate: $dueDate, dueOdometer: $dueOdometer, recurEvery: $recurEvery, recurUnit: $recurUnit, recurKmEvery: $recurKmEvery, leadDays: $leadDays, leadKm: $leadKm, notify: $notify, lastCompletedDate: $lastCompletedDate, lastCompletedOdometer: $lastCompletedOdometer, linkedExpenseCategoryId: $linkedExpenseCategoryId, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReminderCopyWith<$Res> implements $ReminderCopyWith<$Res> {
  factory _$ReminderCopyWith(_Reminder value, $Res Function(_Reminder) _then) = __$ReminderCopyWithImpl;
@override @useResult
$Res call({
 int id, int vehicleId, ReminderType type, String title, TriggerMode triggerMode, DateTime? dueDate, double? dueOdometer, int? recurEvery, RecurUnit? recurUnit, int? recurKmEvery, int? leadDays, int? leadKm, bool notify, DateTime? lastCompletedDate, double? lastCompletedOdometer, int? linkedExpenseCategoryId, bool active, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ReminderCopyWithImpl<$Res>
    implements _$ReminderCopyWith<$Res> {
  __$ReminderCopyWithImpl(this._self, this._then);

  final _Reminder _self;
  final $Res Function(_Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicleId = null,Object? type = null,Object? title = null,Object? triggerMode = null,Object? dueDate = freezed,Object? dueOdometer = freezed,Object? recurEvery = freezed,Object? recurUnit = freezed,Object? recurKmEvery = freezed,Object? leadDays = freezed,Object? leadKm = freezed,Object? notify = null,Object? lastCompletedDate = freezed,Object? lastCompletedOdometer = freezed,Object? linkedExpenseCategoryId = freezed,Object? active = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Reminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ReminderType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,triggerMode: null == triggerMode ? _self.triggerMode : triggerMode // ignore: cast_nullable_to_non_nullable
as TriggerMode,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueOdometer: freezed == dueOdometer ? _self.dueOdometer : dueOdometer // ignore: cast_nullable_to_non_nullable
as double?,recurEvery: freezed == recurEvery ? _self.recurEvery : recurEvery // ignore: cast_nullable_to_non_nullable
as int?,recurUnit: freezed == recurUnit ? _self.recurUnit : recurUnit // ignore: cast_nullable_to_non_nullable
as RecurUnit?,recurKmEvery: freezed == recurKmEvery ? _self.recurKmEvery : recurKmEvery // ignore: cast_nullable_to_non_nullable
as int?,leadDays: freezed == leadDays ? _self.leadDays : leadDays // ignore: cast_nullable_to_non_nullable
as int?,leadKm: freezed == leadKm ? _self.leadKm : leadKm // ignore: cast_nullable_to_non_nullable
as int?,notify: null == notify ? _self.notify : notify // ignore: cast_nullable_to_non_nullable
as bool,lastCompletedDate: freezed == lastCompletedDate ? _self.lastCompletedDate : lastCompletedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lastCompletedOdometer: freezed == lastCompletedOdometer ? _self.lastCompletedOdometer : lastCompletedOdometer // ignore: cast_nullable_to_non_nullable
as double?,linkedExpenseCategoryId: freezed == linkedExpenseCategoryId ? _self.linkedExpenseCategoryId : linkedExpenseCategoryId // ignore: cast_nullable_to_non_nullable
as int?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
