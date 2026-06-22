// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Expense {

 int get id; int get vehicleId; DateTime get date; double? get odometer; int get categoryId; double get amount; String? get description; bool get isRecurring; int? get reminderId; String? get receiptPhotoPath; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.date, date) || other.date == date)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId)&&(identical(other.receiptPhotoPath, receiptPhotoPath) || other.receiptPhotoPath == receiptPhotoPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,date,odometer,categoryId,amount,description,isRecurring,reminderId,receiptPhotoPath,createdAt,updatedAt);

@override
String toString() {
  return 'Expense(id: $id, vehicleId: $vehicleId, date: $date, odometer: $odometer, categoryId: $categoryId, amount: $amount, description: $description, isRecurring: $isRecurring, reminderId: $reminderId, receiptPhotoPath: $receiptPhotoPath, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 int id, int vehicleId, DateTime date, double? odometer, int categoryId, double amount, String? description, bool isRecurring, int? reminderId, String? receiptPhotoPath, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? odometer = freezed,Object? categoryId = null,Object? amount = null,Object? description = freezed,Object? isRecurring = null,Object? reminderId = freezed,Object? receiptPhotoPath = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,odometer: freezed == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as double?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as int?,receiptPhotoPath: freezed == receiptPhotoPath ? _self.receiptPhotoPath : receiptPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int vehicleId,  DateTime date,  double? odometer,  int categoryId,  double amount,  String? description,  bool isRecurring,  int? reminderId,  String? receiptPhotoPath,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.odometer,_that.categoryId,_that.amount,_that.description,_that.isRecurring,_that.reminderId,_that.receiptPhotoPath,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int vehicleId,  DateTime date,  double? odometer,  int categoryId,  double amount,  String? description,  bool isRecurring,  int? reminderId,  String? receiptPhotoPath,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.vehicleId,_that.date,_that.odometer,_that.categoryId,_that.amount,_that.description,_that.isRecurring,_that.reminderId,_that.receiptPhotoPath,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int vehicleId,  DateTime date,  double? odometer,  int categoryId,  double amount,  String? description,  bool isRecurring,  int? reminderId,  String? receiptPhotoPath,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.vehicleId,_that.date,_that.odometer,_that.categoryId,_that.amount,_that.description,_that.isRecurring,_that.reminderId,_that.receiptPhotoPath,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Expense implements Expense {
  const _Expense({required this.id, required this.vehicleId, required this.date, this.odometer, required this.categoryId, required this.amount, this.description, this.isRecurring = false, this.reminderId, this.receiptPhotoPath, required this.createdAt, required this.updatedAt});
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override final  int id;
@override final  int vehicleId;
@override final  DateTime date;
@override final  double? odometer;
@override final  int categoryId;
@override final  double amount;
@override final  String? description;
@override@JsonKey() final  bool isRecurring;
@override final  int? reminderId;
@override final  String? receiptPhotoPath;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.date, date) || other.date == date)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId)&&(identical(other.receiptPhotoPath, receiptPhotoPath) || other.receiptPhotoPath == receiptPhotoPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,date,odometer,categoryId,amount,description,isRecurring,reminderId,receiptPhotoPath,createdAt,updatedAt);

@override
String toString() {
  return 'Expense(id: $id, vehicleId: $vehicleId, date: $date, odometer: $odometer, categoryId: $categoryId, amount: $amount, description: $description, isRecurring: $isRecurring, reminderId: $reminderId, receiptPhotoPath: $receiptPhotoPath, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 int id, int vehicleId, DateTime date, double? odometer, int categoryId, double amount, String? description, bool isRecurring, int? reminderId, String? receiptPhotoPath, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicleId = null,Object? date = null,Object? odometer = freezed,Object? categoryId = null,Object? amount = null,Object? description = freezed,Object? isRecurring = null,Object? reminderId = freezed,Object? receiptPhotoPath = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,odometer: freezed == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as double?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as int?,receiptPhotoPath: freezed == receiptPhotoPath ? _self.receiptPhotoPath : receiptPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
