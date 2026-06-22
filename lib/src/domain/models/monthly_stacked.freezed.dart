// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_stacked.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyStacked {

 int get year; int get month; double get fuel; double get expense;
/// Create a copy of MonthlyStacked
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyStackedCopyWith<MonthlyStacked> get copyWith => _$MonthlyStackedCopyWithImpl<MonthlyStacked>(this as MonthlyStacked, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyStacked&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.fuel, fuel) || other.fuel == fuel)&&(identical(other.expense, expense) || other.expense == expense));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,fuel,expense);

@override
String toString() {
  return 'MonthlyStacked(year: $year, month: $month, fuel: $fuel, expense: $expense)';
}


}

/// @nodoc
abstract mixin class $MonthlyStackedCopyWith<$Res>  {
  factory $MonthlyStackedCopyWith(MonthlyStacked value, $Res Function(MonthlyStacked) _then) = _$MonthlyStackedCopyWithImpl;
@useResult
$Res call({
 int year, int month, double fuel, double expense
});




}
/// @nodoc
class _$MonthlyStackedCopyWithImpl<$Res>
    implements $MonthlyStackedCopyWith<$Res> {
  _$MonthlyStackedCopyWithImpl(this._self, this._then);

  final MonthlyStacked _self;
  final $Res Function(MonthlyStacked) _then;

/// Create a copy of MonthlyStacked
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? fuel = null,Object? expense = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,fuel: null == fuel ? _self.fuel : fuel // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyStacked].
extension MonthlyStackedPatterns on MonthlyStacked {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyStacked value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyStacked() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyStacked value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyStacked():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyStacked value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyStacked() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  double fuel,  double expense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyStacked() when $default != null:
return $default(_that.year,_that.month,_that.fuel,_that.expense);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  double fuel,  double expense)  $default,) {final _that = this;
switch (_that) {
case _MonthlyStacked():
return $default(_that.year,_that.month,_that.fuel,_that.expense);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  double fuel,  double expense)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyStacked() when $default != null:
return $default(_that.year,_that.month,_that.fuel,_that.expense);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyStacked extends MonthlyStacked {
  const _MonthlyStacked({required this.year, required this.month, this.fuel = 0, this.expense = 0}): super._();
  

@override final  int year;
@override final  int month;
@override@JsonKey() final  double fuel;
@override@JsonKey() final  double expense;

/// Create a copy of MonthlyStacked
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyStackedCopyWith<_MonthlyStacked> get copyWith => __$MonthlyStackedCopyWithImpl<_MonthlyStacked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyStacked&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.fuel, fuel) || other.fuel == fuel)&&(identical(other.expense, expense) || other.expense == expense));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,fuel,expense);

@override
String toString() {
  return 'MonthlyStacked(year: $year, month: $month, fuel: $fuel, expense: $expense)';
}


}

/// @nodoc
abstract mixin class _$MonthlyStackedCopyWith<$Res> implements $MonthlyStackedCopyWith<$Res> {
  factory _$MonthlyStackedCopyWith(_MonthlyStacked value, $Res Function(_MonthlyStacked) _then) = __$MonthlyStackedCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, double fuel, double expense
});




}
/// @nodoc
class __$MonthlyStackedCopyWithImpl<$Res>
    implements _$MonthlyStackedCopyWith<$Res> {
  __$MonthlyStackedCopyWithImpl(this._self, this._then);

  final _MonthlyStacked _self;
  final $Res Function(_MonthlyStacked) _then;

/// Create a copy of MonthlyStacked
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? fuel = null,Object? expense = null,}) {
  return _then(_MonthlyStacked(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,fuel: null == fuel ? _self.fuel : fuel // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
