// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_evaluation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReminderEvaluation {

 Reminder get reminder; ReminderStatus get status; int? get daysRemaining; double? get kmRemaining;
/// Create a copy of ReminderEvaluation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderEvaluationCopyWith<ReminderEvaluation> get copyWith => _$ReminderEvaluationCopyWithImpl<ReminderEvaluation>(this as ReminderEvaluation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderEvaluation&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.status, status) || other.status == status)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.kmRemaining, kmRemaining) || other.kmRemaining == kmRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,reminder,status,daysRemaining,kmRemaining);

@override
String toString() {
  return 'ReminderEvaluation(reminder: $reminder, status: $status, daysRemaining: $daysRemaining, kmRemaining: $kmRemaining)';
}


}

/// @nodoc
abstract mixin class $ReminderEvaluationCopyWith<$Res>  {
  factory $ReminderEvaluationCopyWith(ReminderEvaluation value, $Res Function(ReminderEvaluation) _then) = _$ReminderEvaluationCopyWithImpl;
@useResult
$Res call({
 Reminder reminder, ReminderStatus status, int? daysRemaining, double? kmRemaining
});


$ReminderCopyWith<$Res> get reminder;

}
/// @nodoc
class _$ReminderEvaluationCopyWithImpl<$Res>
    implements $ReminderEvaluationCopyWith<$Res> {
  _$ReminderEvaluationCopyWithImpl(this._self, this._then);

  final ReminderEvaluation _self;
  final $Res Function(ReminderEvaluation) _then;

/// Create a copy of ReminderEvaluation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reminder = null,Object? status = null,Object? daysRemaining = freezed,Object? kmRemaining = freezed,}) {
  return _then(_self.copyWith(
reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as Reminder,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReminderStatus,daysRemaining: freezed == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int?,kmRemaining: freezed == kmRemaining ? _self.kmRemaining : kmRemaining // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of ReminderEvaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderCopyWith<$Res> get reminder {
  
  return $ReminderCopyWith<$Res>(_self.reminder, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReminderEvaluation].
extension ReminderEvaluationPatterns on ReminderEvaluation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderEvaluation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderEvaluation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderEvaluation value)  $default,){
final _that = this;
switch (_that) {
case _ReminderEvaluation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderEvaluation value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderEvaluation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Reminder reminder,  ReminderStatus status,  int? daysRemaining,  double? kmRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderEvaluation() when $default != null:
return $default(_that.reminder,_that.status,_that.daysRemaining,_that.kmRemaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Reminder reminder,  ReminderStatus status,  int? daysRemaining,  double? kmRemaining)  $default,) {final _that = this;
switch (_that) {
case _ReminderEvaluation():
return $default(_that.reminder,_that.status,_that.daysRemaining,_that.kmRemaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Reminder reminder,  ReminderStatus status,  int? daysRemaining,  double? kmRemaining)?  $default,) {final _that = this;
switch (_that) {
case _ReminderEvaluation() when $default != null:
return $default(_that.reminder,_that.status,_that.daysRemaining,_that.kmRemaining);case _:
  return null;

}
}

}

/// @nodoc


class _ReminderEvaluation implements ReminderEvaluation {
  const _ReminderEvaluation({required this.reminder, required this.status, this.daysRemaining, this.kmRemaining});
  

@override final  Reminder reminder;
@override final  ReminderStatus status;
@override final  int? daysRemaining;
@override final  double? kmRemaining;

/// Create a copy of ReminderEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderEvaluationCopyWith<_ReminderEvaluation> get copyWith => __$ReminderEvaluationCopyWithImpl<_ReminderEvaluation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderEvaluation&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.status, status) || other.status == status)&&(identical(other.daysRemaining, daysRemaining) || other.daysRemaining == daysRemaining)&&(identical(other.kmRemaining, kmRemaining) || other.kmRemaining == kmRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,reminder,status,daysRemaining,kmRemaining);

@override
String toString() {
  return 'ReminderEvaluation(reminder: $reminder, status: $status, daysRemaining: $daysRemaining, kmRemaining: $kmRemaining)';
}


}

/// @nodoc
abstract mixin class _$ReminderEvaluationCopyWith<$Res> implements $ReminderEvaluationCopyWith<$Res> {
  factory _$ReminderEvaluationCopyWith(_ReminderEvaluation value, $Res Function(_ReminderEvaluation) _then) = __$ReminderEvaluationCopyWithImpl;
@override @useResult
$Res call({
 Reminder reminder, ReminderStatus status, int? daysRemaining, double? kmRemaining
});


@override $ReminderCopyWith<$Res> get reminder;

}
/// @nodoc
class __$ReminderEvaluationCopyWithImpl<$Res>
    implements _$ReminderEvaluationCopyWith<$Res> {
  __$ReminderEvaluationCopyWithImpl(this._self, this._then);

  final _ReminderEvaluation _self;
  final $Res Function(_ReminderEvaluation) _then;

/// Create a copy of ReminderEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reminder = null,Object? status = null,Object? daysRemaining = freezed,Object? kmRemaining = freezed,}) {
  return _then(_ReminderEvaluation(
reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as Reminder,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReminderStatus,daysRemaining: freezed == daysRemaining ? _self.daysRemaining : daysRemaining // ignore: cast_nullable_to_non_nullable
as int?,kmRemaining: freezed == kmRemaining ? _self.kmRemaining : kmRemaining // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of ReminderEvaluation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderCopyWith<$Res> get reminder {
  
  return $ReminderCopyWith<$Res>(_self.reminder, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}
}

// dart format on
