// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerState {

 Track get currentTrack;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.currentTrack, currentTrack) || other.currentTrack == currentTrack));
}


@override
int get hashCode => Object.hash(runtimeType,currentTrack);

@override
String toString() {
  return 'PlayerState(currentTrack: $currentTrack)';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 Track currentTrack
});




}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentTrack = null,}) {
  return _then(_self.copyWith(
currentTrack: null == currentTrack ? _self.currentTrack : currentTrack // ignore: cast_nullable_to_non_nullable
as Track,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Play value)?  play,TResult Function( _Pause value)?  pause,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Play() when play != null:
return play(_that);case _Pause() when pause != null:
return pause(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Play value)  play,required TResult Function( _Pause value)  pause,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Play():
return play(_that);case _Pause():
return pause(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Play value)?  play,TResult? Function( _Pause value)?  pause,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Play() when play != null:
return play(_that);case _Pause() when pause != null:
return pause(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Track currentTrack)?  initial,TResult Function( Track currentTrack)?  play,TResult Function( Track currentTrack)?  pause,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.currentTrack);case _Play() when play != null:
return play(_that.currentTrack);case _Pause() when pause != null:
return pause(_that.currentTrack);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Track currentTrack)  initial,required TResult Function( Track currentTrack)  play,required TResult Function( Track currentTrack)  pause,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.currentTrack);case _Play():
return play(_that.currentTrack);case _Pause():
return pause(_that.currentTrack);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Track currentTrack)?  initial,TResult? Function( Track currentTrack)?  play,TResult? Function( Track currentTrack)?  pause,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.currentTrack);case _Play() when play != null:
return play(_that.currentTrack);case _Pause() when pause != null:
return pause(_that.currentTrack);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends PlayerState {
  const _Initial({required this.currentTrack}): super._();
  

@override final  Track currentTrack;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.currentTrack, currentTrack) || other.currentTrack == currentTrack));
}


@override
int get hashCode => Object.hash(runtimeType,currentTrack);

@override
String toString() {
  return 'PlayerState.initial(currentTrack: $currentTrack)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 Track currentTrack
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentTrack = null,}) {
  return _then(_Initial(
currentTrack: null == currentTrack ? _self.currentTrack : currentTrack // ignore: cast_nullable_to_non_nullable
as Track,
  ));
}


}

/// @nodoc


class _Play extends PlayerState {
  const _Play({required this.currentTrack}): super._();
  

@override final  Track currentTrack;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayCopyWith<_Play> get copyWith => __$PlayCopyWithImpl<_Play>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Play&&(identical(other.currentTrack, currentTrack) || other.currentTrack == currentTrack));
}


@override
int get hashCode => Object.hash(runtimeType,currentTrack);

@override
String toString() {
  return 'PlayerState.play(currentTrack: $currentTrack)';
}


}

/// @nodoc
abstract mixin class _$PlayCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayCopyWith(_Play value, $Res Function(_Play) _then) = __$PlayCopyWithImpl;
@override @useResult
$Res call({
 Track currentTrack
});




}
/// @nodoc
class __$PlayCopyWithImpl<$Res>
    implements _$PlayCopyWith<$Res> {
  __$PlayCopyWithImpl(this._self, this._then);

  final _Play _self;
  final $Res Function(_Play) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentTrack = null,}) {
  return _then(_Play(
currentTrack: null == currentTrack ? _self.currentTrack : currentTrack // ignore: cast_nullable_to_non_nullable
as Track,
  ));
}


}

/// @nodoc


class _Pause extends PlayerState {
  const _Pause({required this.currentTrack}): super._();
  

@override final  Track currentTrack;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PauseCopyWith<_Pause> get copyWith => __$PauseCopyWithImpl<_Pause>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pause&&(identical(other.currentTrack, currentTrack) || other.currentTrack == currentTrack));
}


@override
int get hashCode => Object.hash(runtimeType,currentTrack);

@override
String toString() {
  return 'PlayerState.pause(currentTrack: $currentTrack)';
}


}

/// @nodoc
abstract mixin class _$PauseCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PauseCopyWith(_Pause value, $Res Function(_Pause) _then) = __$PauseCopyWithImpl;
@override @useResult
$Res call({
 Track currentTrack
});




}
/// @nodoc
class __$PauseCopyWithImpl<$Res>
    implements _$PauseCopyWith<$Res> {
  __$PauseCopyWithImpl(this._self, this._then);

  final _Pause _self;
  final $Res Function(_Pause) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentTrack = null,}) {
  return _then(_Pause(
currentTrack: null == currentTrack ? _self.currentTrack : currentTrack // ignore: cast_nullable_to_non_nullable
as Track,
  ));
}


}

// dart format on
