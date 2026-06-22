// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_total.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyTotal {

 int get year; int get month; double get total;
/// Create a copy of MonthlyTotal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyTotalCopyWith<MonthlyTotal> get copyWith => _$MonthlyTotalCopyWithImpl<MonthlyTotal>(this as MonthlyTotal, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyTotal&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,total);

@override
String toString() {
  return 'MonthlyTotal(year: $year, month: $month, total: $total)';
}


}

/// @nodoc
abstract mixin class $MonthlyTotalCopyWith<$Res>  {
  factory $MonthlyTotalCopyWith(MonthlyTotal value, $Res Function(MonthlyTotal) _then) = _$MonthlyTotalCopyWithImpl;
@useResult
$Res call({
 int year, int month, double total
});




}
/// @nodoc
class _$MonthlyTotalCopyWithImpl<$Res>
    implements $MonthlyTotalCopyWith<$Res> {
  _$MonthlyTotalCopyWithImpl(this._self, this._then);

  final MonthlyTotal _self;
  final $Res Function(MonthlyTotal) _then;

/// Create a copy of MonthlyTotal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? total = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyTotal].
extension MonthlyTotalPatterns on MonthlyTotal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyTotal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyTotal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyTotal value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyTotal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyTotal value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyTotal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  double total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyTotal() when $default != null:
return $default(_that.year,_that.month,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  double total)  $default,) {final _that = this;
switch (_that) {
case _MonthlyTotal():
return $default(_that.year,_that.month,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  double total)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyTotal() when $default != null:
return $default(_that.year,_that.month,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyTotal extends MonthlyTotal {
  const _MonthlyTotal({required this.year, required this.month, required this.total}): super._();
  

@override final  int year;
@override final  int month;
@override final  double total;

/// Create a copy of MonthlyTotal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyTotalCopyWith<_MonthlyTotal> get copyWith => __$MonthlyTotalCopyWithImpl<_MonthlyTotal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyTotal&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,total);

@override
String toString() {
  return 'MonthlyTotal(year: $year, month: $month, total: $total)';
}


}

/// @nodoc
abstract mixin class _$MonthlyTotalCopyWith<$Res> implements $MonthlyTotalCopyWith<$Res> {
  factory _$MonthlyTotalCopyWith(_MonthlyTotal value, $Res Function(_MonthlyTotal) _then) = __$MonthlyTotalCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, double total
});




}
/// @nodoc
class __$MonthlyTotalCopyWithImpl<$Res>
    implements _$MonthlyTotalCopyWith<$Res> {
  __$MonthlyTotalCopyWithImpl(this._self, this._then);

  final _MonthlyTotal _self;
  final $Res Function(_MonthlyTotal) _then;

/// Create a copy of MonthlyTotal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? total = null,}) {
  return _then(_MonthlyTotal(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
