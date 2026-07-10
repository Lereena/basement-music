// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_cover_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlbumCoverState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumCoverState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlbumCoverState()';
}


}

/// @nodoc
class $AlbumCoverStateCopyWith<$Res>  {
$AlbumCoverStateCopyWith(AlbumCoverState _, $Res Function(AlbumCoverState) __);
}


/// Adds pattern-matching-related methods to [AlbumCoverState].
extension AlbumCoverStatePatterns on AlbumCoverState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Searching value)?  searching,TResult Function( _Candidates value)?  candidates,TResult Function( _Applying value)?  applying,TResult Function( _Applied value)?  applied,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Searching() when searching != null:
return searching(_that);case _Candidates() when candidates != null:
return candidates(_that);case _Applying() when applying != null:
return applying(_that);case _Applied() when applied != null:
return applied(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Searching value)  searching,required TResult Function( _Candidates value)  candidates,required TResult Function( _Applying value)  applying,required TResult Function( _Applied value)  applied,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Searching():
return searching(_that);case _Candidates():
return candidates(_that);case _Applying():
return applying(_that);case _Applied():
return applied(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Searching value)?  searching,TResult? Function( _Candidates value)?  candidates,TResult? Function( _Applying value)?  applying,TResult? Function( _Applied value)?  applied,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Searching() when searching != null:
return searching(_that);case _Candidates() when candidates != null:
return candidates(_that);case _Applying() when applying != null:
return applying(_that);case _Applied() when applied != null:
return applied(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  searching,TResult Function( List<ReleaseGroupCandidate> candidates)?  candidates,TResult Function()?  applying,TResult Function()?  applied,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Searching() when searching != null:
return searching();case _Candidates() when candidates != null:
return candidates(_that.candidates);case _Applying() when applying != null:
return applying();case _Applied() when applied != null:
return applied();case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  searching,required TResult Function( List<ReleaseGroupCandidate> candidates)  candidates,required TResult Function()  applying,required TResult Function()  applied,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Searching():
return searching();case _Candidates():
return candidates(_that.candidates);case _Applying():
return applying();case _Applied():
return applied();case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  searching,TResult? Function( List<ReleaseGroupCandidate> candidates)?  candidates,TResult? Function()?  applying,TResult? Function()?  applied,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Searching() when searching != null:
return searching();case _Candidates() when candidates != null:
return candidates(_that.candidates);case _Applying() when applying != null:
return applying();case _Applied() when applied != null:
return applied();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AlbumCoverState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlbumCoverState.initial()';
}


}




/// @nodoc


class _Searching implements AlbumCoverState {
  const _Searching();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Searching);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlbumCoverState.searching()';
}


}




/// @nodoc


class _Candidates implements AlbumCoverState {
  const _Candidates({required final  List<ReleaseGroupCandidate> candidates}): _candidates = candidates;
  

 final  List<ReleaseGroupCandidate> _candidates;
 List<ReleaseGroupCandidate> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}


/// Create a copy of AlbumCoverState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CandidatesCopyWith<_Candidates> get copyWith => __$CandidatesCopyWithImpl<_Candidates>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Candidates&&const DeepCollectionEquality().equals(other._candidates, _candidates));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_candidates));

@override
String toString() {
  return 'AlbumCoverState.candidates(candidates: $candidates)';
}


}

/// @nodoc
abstract mixin class _$CandidatesCopyWith<$Res> implements $AlbumCoverStateCopyWith<$Res> {
  factory _$CandidatesCopyWith(_Candidates value, $Res Function(_Candidates) _then) = __$CandidatesCopyWithImpl;
@useResult
$Res call({
 List<ReleaseGroupCandidate> candidates
});




}
/// @nodoc
class __$CandidatesCopyWithImpl<$Res>
    implements _$CandidatesCopyWith<$Res> {
  __$CandidatesCopyWithImpl(this._self, this._then);

  final _Candidates _self;
  final $Res Function(_Candidates) _then;

/// Create a copy of AlbumCoverState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? candidates = null,}) {
  return _then(_Candidates(
candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<ReleaseGroupCandidate>,
  ));
}


}

/// @nodoc


class _Applying implements AlbumCoverState {
  const _Applying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Applying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlbumCoverState.applying()';
}


}




/// @nodoc


class _Applied implements AlbumCoverState {
  const _Applied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Applied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AlbumCoverState.applied()';
}


}




/// @nodoc


class _Error implements AlbumCoverState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of AlbumCoverState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AlbumCoverState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AlbumCoverStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AlbumCoverState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
