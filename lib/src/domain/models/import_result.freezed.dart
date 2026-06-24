// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImportResult {

 List<FillUp> get rows; int get skipped; int get duplicates; List<String> get warnings;
/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportResultCopyWith<ImportResult> get copyWith => _$ImportResultCopyWithImpl<ImportResult>(this as ImportResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportResult&&const DeepCollectionEquality().equals(other.rows, rows)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.duplicates, duplicates) || other.duplicates == duplicates)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rows),skipped,duplicates,const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'ImportResult(rows: $rows, skipped: $skipped, duplicates: $duplicates, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $ImportResultCopyWith<$Res>  {
  factory $ImportResultCopyWith(ImportResult value, $Res Function(ImportResult) _then) = _$ImportResultCopyWithImpl;
@useResult
$Res call({
 List<FillUp> rows, int skipped, int duplicates, List<String> warnings
});




}
/// @nodoc
class _$ImportResultCopyWithImpl<$Res>
    implements $ImportResultCopyWith<$Res> {
  _$ImportResultCopyWithImpl(this._self, this._then);

  final ImportResult _self;
  final $Res Function(ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rows = null,Object? skipped = null,Object? duplicates = null,Object? warnings = null,}) {
  return _then(_self.copyWith(
rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<FillUp>,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,duplicates: null == duplicates ? _self.duplicates : duplicates // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportResult].
extension ImportResultPatterns on ImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportResult value)  $default,){
final _that = this;
switch (_that) {
case _ImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FillUp> rows,  int skipped,  int duplicates,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
return $default(_that.rows,_that.skipped,_that.duplicates,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FillUp> rows,  int skipped,  int duplicates,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _ImportResult():
return $default(_that.rows,_that.skipped,_that.duplicates,_that.warnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FillUp> rows,  int skipped,  int duplicates,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
return $default(_that.rows,_that.skipped,_that.duplicates,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc


class _ImportResult implements ImportResult {
  const _ImportResult({final  List<FillUp> rows = const <FillUp>[], this.skipped = 0, this.duplicates = 0, final  List<String> warnings = const <String>[]}): _rows = rows,_warnings = warnings;
  

 final  List<FillUp> _rows;
@override@JsonKey() List<FillUp> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override@JsonKey() final  int skipped;
@override@JsonKey() final  int duplicates;
 final  List<String> _warnings;
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}


/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportResultCopyWith<_ImportResult> get copyWith => __$ImportResultCopyWithImpl<_ImportResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportResult&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.duplicates, duplicates) || other.duplicates == duplicates)&&const DeepCollectionEquality().equals(other._warnings, _warnings));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rows),skipped,duplicates,const DeepCollectionEquality().hash(_warnings));

@override
String toString() {
  return 'ImportResult(rows: $rows, skipped: $skipped, duplicates: $duplicates, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$ImportResultCopyWith<$Res> implements $ImportResultCopyWith<$Res> {
  factory _$ImportResultCopyWith(_ImportResult value, $Res Function(_ImportResult) _then) = __$ImportResultCopyWithImpl;
@override @useResult
$Res call({
 List<FillUp> rows, int skipped, int duplicates, List<String> warnings
});




}
/// @nodoc
class __$ImportResultCopyWithImpl<$Res>
    implements _$ImportResultCopyWith<$Res> {
  __$ImportResultCopyWithImpl(this._self, this._then);

  final _ImportResult _self;
  final $Res Function(_ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rows = null,Object? skipped = null,Object? duplicates = null,Object? warnings = null,}) {
  return _then(_ImportResult(
rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<FillUp>,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,duplicates: null == duplicates ? _self.duplicates : duplicates // ignore: cast_nullable_to_non_nullable
as int,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
