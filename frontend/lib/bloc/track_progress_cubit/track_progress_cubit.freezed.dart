// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_progress_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackProgressState {

 double get percentProgress; String get stringProgress; String get stringDuration;
/// Create a copy of TrackProgressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackProgressStateCopyWith<TrackProgressState> get copyWith => _$TrackProgressStateCopyWithImpl<TrackProgressState>(this as TrackProgressState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackProgressState&&(identical(other.percentProgress, percentProgress) || other.percentProgress == percentProgress)&&(identical(other.stringProgress, stringProgress) || other.stringProgress == stringProgress)&&(identical(other.stringDuration, stringDuration) || other.stringDuration == stringDuration));
}


@override
int get hashCode => Object.hash(runtimeType,percentProgress,stringProgress,stringDuration);

@override
String toString() {
  return 'TrackProgressState(percentProgress: $percentProgress, stringProgress: $stringProgress, stringDuration: $stringDuration)';
}


}

/// @nodoc
abstract mixin class $TrackProgressStateCopyWith<$Res>  {
  factory $TrackProgressStateCopyWith(TrackProgressState value, $Res Function(TrackProgressState) _then) = _$TrackProgressStateCopyWithImpl;
@useResult
$Res call({
 double percentProgress, String stringProgress, String stringDuration
});




}
/// @nodoc
class _$TrackProgressStateCopyWithImpl<$Res>
    implements $TrackProgressStateCopyWith<$Res> {
  _$TrackProgressStateCopyWithImpl(this._self, this._then);

  final TrackProgressState _self;
  final $Res Function(TrackProgressState) _then;

/// Create a copy of TrackProgressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? percentProgress = null,Object? stringProgress = null,Object? stringDuration = null,}) {
  return _then(_self.copyWith(
percentProgress: null == percentProgress ? _self.percentProgress : percentProgress // ignore: cast_nullable_to_non_nullable
as double,stringProgress: null == stringProgress ? _self.stringProgress : stringProgress // ignore: cast_nullable_to_non_nullable
as String,stringDuration: null == stringDuration ? _self.stringDuration : stringDuration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackProgressState].
extension TrackProgressStatePatterns on TrackProgressState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackProgressState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackProgressState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackProgressState value)  $default,){
final _that = this;
switch (_that) {
case _TrackProgressState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackProgressState value)?  $default,){
final _that = this;
switch (_that) {
case _TrackProgressState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double percentProgress,  String stringProgress,  String stringDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackProgressState() when $default != null:
return $default(_that.percentProgress,_that.stringProgress,_that.stringDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double percentProgress,  String stringProgress,  String stringDuration)  $default,) {final _that = this;
switch (_that) {
case _TrackProgressState():
return $default(_that.percentProgress,_that.stringProgress,_that.stringDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double percentProgress,  String stringProgress,  String stringDuration)?  $default,) {final _that = this;
switch (_that) {
case _TrackProgressState() when $default != null:
return $default(_that.percentProgress,_that.stringProgress,_that.stringDuration);case _:
  return null;

}
}

}

/// @nodoc


class _TrackProgressState implements TrackProgressState {
  const _TrackProgressState({this.percentProgress = 0.0, this.stringProgress = '00:00', this.stringDuration = '00:00'});
  

@override@JsonKey() final  double percentProgress;
@override@JsonKey() final  String stringProgress;
@override@JsonKey() final  String stringDuration;

/// Create a copy of TrackProgressState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackProgressStateCopyWith<_TrackProgressState> get copyWith => __$TrackProgressStateCopyWithImpl<_TrackProgressState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackProgressState&&(identical(other.percentProgress, percentProgress) || other.percentProgress == percentProgress)&&(identical(other.stringProgress, stringProgress) || other.stringProgress == stringProgress)&&(identical(other.stringDuration, stringDuration) || other.stringDuration == stringDuration));
}


@override
int get hashCode => Object.hash(runtimeType,percentProgress,stringProgress,stringDuration);

@override
String toString() {
  return 'TrackProgressState(percentProgress: $percentProgress, stringProgress: $stringProgress, stringDuration: $stringDuration)';
}


}

/// @nodoc
abstract mixin class _$TrackProgressStateCopyWith<$Res> implements $TrackProgressStateCopyWith<$Res> {
  factory _$TrackProgressStateCopyWith(_TrackProgressState value, $Res Function(_TrackProgressState) _then) = __$TrackProgressStateCopyWithImpl;
@override @useResult
$Res call({
 double percentProgress, String stringProgress, String stringDuration
});




}
/// @nodoc
class __$TrackProgressStateCopyWithImpl<$Res>
    implements _$TrackProgressStateCopyWith<$Res> {
  __$TrackProgressStateCopyWithImpl(this._self, this._then);

  final _TrackProgressState _self;
  final $Res Function(_TrackProgressState) _then;

/// Create a copy of TrackProgressState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? percentProgress = null,Object? stringProgress = null,Object? stringDuration = null,}) {
  return _then(_TrackProgressState(
percentProgress: null == percentProgress ? _self.percentProgress : percentProgress // ignore: cast_nullable_to_non_nullable
as double,stringProgress: null == stringProgress ? _self.stringProgress : stringProgress // ignore: cast_nullable_to_non_nullable
as String,stringDuration: null == stringDuration ? _self.stringDuration : stringDuration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
