// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupData {

 int get schemaVersion; List<Vehicle> get vehicles; List<Category> get categories; List<FillUp> get fillUps; List<Expense> get expenses; List<Reminder> get reminders;
/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupDataCopyWith<BackupData> get copyWith => _$BackupDataCopyWithImpl<BackupData>(this as BackupData, _$identity);

  /// Serializes this BackupData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupData&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&const DeepCollectionEquality().equals(other.vehicles, vehicles)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.fillUps, fillUps)&&const DeepCollectionEquality().equals(other.expenses, expenses)&&const DeepCollectionEquality().equals(other.reminders, reminders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,const DeepCollectionEquality().hash(vehicles),const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(fillUps),const DeepCollectionEquality().hash(expenses),const DeepCollectionEquality().hash(reminders));

@override
String toString() {
  return 'BackupData(schemaVersion: $schemaVersion, vehicles: $vehicles, categories: $categories, fillUps: $fillUps, expenses: $expenses, reminders: $reminders)';
}


}

/// @nodoc
abstract mixin class $BackupDataCopyWith<$Res>  {
  factory $BackupDataCopyWith(BackupData value, $Res Function(BackupData) _then) = _$BackupDataCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, List<Vehicle> vehicles, List<Category> categories, List<FillUp> fillUps, List<Expense> expenses, List<Reminder> reminders
});




}
/// @nodoc
class _$BackupDataCopyWithImpl<$Res>
    implements $BackupDataCopyWith<$Res> {
  _$BackupDataCopyWithImpl(this._self, this._then);

  final BackupData _self;
  final $Res Function(BackupData) _then;

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? vehicles = null,Object? categories = null,Object? fillUps = null,Object? expenses = null,Object? reminders = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,vehicles: null == vehicles ? _self.vehicles : vehicles // ignore: cast_nullable_to_non_nullable
as List<Vehicle>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,fillUps: null == fillUps ? _self.fillUps : fillUps // ignore: cast_nullable_to_non_nullable
as List<FillUp>,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Reminder>,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupData].
extension BackupDataPatterns on BackupData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupData value)  $default,){
final _that = this;
switch (_that) {
case _BackupData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupData value)?  $default,){
final _that = this;
switch (_that) {
case _BackupData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  List<Vehicle> vehicles,  List<Category> categories,  List<FillUp> fillUps,  List<Expense> expenses,  List<Reminder> reminders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that.schemaVersion,_that.vehicles,_that.categories,_that.fillUps,_that.expenses,_that.reminders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  List<Vehicle> vehicles,  List<Category> categories,  List<FillUp> fillUps,  List<Expense> expenses,  List<Reminder> reminders)  $default,) {final _that = this;
switch (_that) {
case _BackupData():
return $default(_that.schemaVersion,_that.vehicles,_that.categories,_that.fillUps,_that.expenses,_that.reminders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  List<Vehicle> vehicles,  List<Category> categories,  List<FillUp> fillUps,  List<Expense> expenses,  List<Reminder> reminders)?  $default,) {final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that.schemaVersion,_that.vehicles,_that.categories,_that.fillUps,_that.expenses,_that.reminders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupData implements BackupData {
  const _BackupData({this.schemaVersion = 3, final  List<Vehicle> vehicles = const <Vehicle>[], final  List<Category> categories = const <Category>[], final  List<FillUp> fillUps = const <FillUp>[], final  List<Expense> expenses = const <Expense>[], final  List<Reminder> reminders = const <Reminder>[]}): _vehicles = vehicles,_categories = categories,_fillUps = fillUps,_expenses = expenses,_reminders = reminders;
  factory _BackupData.fromJson(Map<String, dynamic> json) => _$BackupDataFromJson(json);

@override@JsonKey() final  int schemaVersion;
 final  List<Vehicle> _vehicles;
@override@JsonKey() List<Vehicle> get vehicles {
  if (_vehicles is EqualUnmodifiableListView) return _vehicles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vehicles);
}

 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<FillUp> _fillUps;
@override@JsonKey() List<FillUp> get fillUps {
  if (_fillUps is EqualUnmodifiableListView) return _fillUps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fillUps);
}

 final  List<Expense> _expenses;
@override@JsonKey() List<Expense> get expenses {
  if (_expenses is EqualUnmodifiableListView) return _expenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenses);
}

 final  List<Reminder> _reminders;
@override@JsonKey() List<Reminder> get reminders {
  if (_reminders is EqualUnmodifiableListView) return _reminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminders);
}


/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupDataCopyWith<_BackupData> get copyWith => __$BackupDataCopyWithImpl<_BackupData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupData&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&const DeepCollectionEquality().equals(other._vehicles, _vehicles)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._fillUps, _fillUps)&&const DeepCollectionEquality().equals(other._expenses, _expenses)&&const DeepCollectionEquality().equals(other._reminders, _reminders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,const DeepCollectionEquality().hash(_vehicles),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_fillUps),const DeepCollectionEquality().hash(_expenses),const DeepCollectionEquality().hash(_reminders));

@override
String toString() {
  return 'BackupData(schemaVersion: $schemaVersion, vehicles: $vehicles, categories: $categories, fillUps: $fillUps, expenses: $expenses, reminders: $reminders)';
}


}

/// @nodoc
abstract mixin class _$BackupDataCopyWith<$Res> implements $BackupDataCopyWith<$Res> {
  factory _$BackupDataCopyWith(_BackupData value, $Res Function(_BackupData) _then) = __$BackupDataCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, List<Vehicle> vehicles, List<Category> categories, List<FillUp> fillUps, List<Expense> expenses, List<Reminder> reminders
});




}
/// @nodoc
class __$BackupDataCopyWithImpl<$Res>
    implements _$BackupDataCopyWith<$Res> {
  __$BackupDataCopyWithImpl(this._self, this._then);

  final _BackupData _self;
  final $Res Function(_BackupData) _then;

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? vehicles = null,Object? categories = null,Object? fillUps = null,Object? expenses = null,Object? reminders = null,}) {
  return _then(_BackupData(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,vehicles: null == vehicles ? _self._vehicles : vehicles // ignore: cast_nullable_to_non_nullable
as List<Vehicle>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,fillUps: null == fillUps ? _self._fillUps : fillUps // ignore: cast_nullable_to_non_nullable
as List<FillUp>,expenses: null == expenses ? _self._expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,reminders: null == reminders ? _self._reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Reminder>,
  ));
}


}

// dart format on
