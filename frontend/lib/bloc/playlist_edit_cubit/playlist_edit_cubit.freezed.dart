// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_edit_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaylistEditState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistEditState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistEditState()';
}


}

/// @nodoc
class $PlaylistEditStateCopyWith<$Res>  {
$PlaylistEditStateCopyWith(PlaylistEditState _, $Res Function(PlaylistEditState) __);
}


/// Adds pattern-matching-related methods to [PlaylistEditState].
extension PlaylistEditStatePatterns on PlaylistEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _EditInProgress value)?  editInProgress,TResult Function( _SaveInProgress value)?  saveInProgress,TResult Function( _Success value)?  success,TResult Function( _Fail value)?  fail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _EditInProgress() when editInProgress != null:
return editInProgress(_that);case _SaveInProgress() when saveInProgress != null:
return saveInProgress(_that);case _Success() when success != null:
return success(_that);case _Fail() when fail != null:
return fail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _EditInProgress value)  editInProgress,required TResult Function( _SaveInProgress value)  saveInProgress,required TResult Function( _Success value)  success,required TResult Function( _Fail value)  fail,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _EditInProgress():
return editInProgress(_that);case _SaveInProgress():
return saveInProgress(_that);case _Success():
return success(_that);case _Fail():
return fail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _EditInProgress value)?  editInProgress,TResult? Function( _SaveInProgress value)?  saveInProgress,TResult? Function( _Success value)?  success,TResult? Function( _Fail value)?  fail,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _EditInProgress() when editInProgress != null:
return editInProgress(_that);case _SaveInProgress() when saveInProgress != null:
return saveInProgress(_that);case _Success() when success != null:
return success(_that);case _Fail() when fail != null:
return fail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String playlistId,  String title,  List<Track> tracks)?  editInProgress,TResult Function()?  saveInProgress,TResult Function()?  success,TResult Function()?  fail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _EditInProgress() when editInProgress != null:
return editInProgress(_that.playlistId,_that.title,_that.tracks);case _SaveInProgress() when saveInProgress != null:
return saveInProgress();case _Success() when success != null:
return success();case _Fail() when fail != null:
return fail();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String playlistId,  String title,  List<Track> tracks)  editInProgress,required TResult Function()  saveInProgress,required TResult Function()  success,required TResult Function()  fail,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _EditInProgress():
return editInProgress(_that.playlistId,_that.title,_that.tracks);case _SaveInProgress():
return saveInProgress();case _Success():
return success();case _Fail():
return fail();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String playlistId,  String title,  List<Track> tracks)?  editInProgress,TResult? Function()?  saveInProgress,TResult? Function()?  success,TResult? Function()?  fail,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _EditInProgress() when editInProgress != null:
return editInProgress(_that.playlistId,_that.title,_that.tracks);case _SaveInProgress() when saveInProgress != null:
return saveInProgress();case _Success() when success != null:
return success();case _Fail() when fail != null:
return fail();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements PlaylistEditState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistEditState.initial()';
}


}




/// @nodoc


class _EditInProgress implements PlaylistEditState {
  const _EditInProgress({required this.playlistId, required this.title, required final  List<Track> tracks}): _tracks = tracks;
  

 final  String playlistId;
 final  String title;
 final  List<Track> _tracks;
 List<Track> get tracks {
  if (_tracks is EqualUnmodifiableListView) return _tracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tracks);
}


/// Create a copy of PlaylistEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditInProgressCopyWith<_EditInProgress> get copyWith => __$EditInProgressCopyWithImpl<_EditInProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditInProgress&&(identical(other.playlistId, playlistId) || other.playlistId == playlistId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._tracks, _tracks));
}


@override
int get hashCode => Object.hash(runtimeType,playlistId,title,const DeepCollectionEquality().hash(_tracks));

@override
String toString() {
  return 'PlaylistEditState.editInProgress(playlistId: $playlistId, title: $title, tracks: $tracks)';
}


}

/// @nodoc
abstract mixin class _$EditInProgressCopyWith<$Res> implements $PlaylistEditStateCopyWith<$Res> {
  factory _$EditInProgressCopyWith(_EditInProgress value, $Res Function(_EditInProgress) _then) = __$EditInProgressCopyWithImpl;
@useResult
$Res call({
 String playlistId, String title, List<Track> tracks
});




}
/// @nodoc
class __$EditInProgressCopyWithImpl<$Res>
    implements _$EditInProgressCopyWith<$Res> {
  __$EditInProgressCopyWithImpl(this._self, this._then);

  final _EditInProgress _self;
  final $Res Function(_EditInProgress) _then;

/// Create a copy of PlaylistEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playlistId = null,Object? title = null,Object? tracks = null,}) {
  return _then(_EditInProgress(
playlistId: null == playlistId ? _self.playlistId : playlistId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tracks: null == tracks ? _self._tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<Track>,
  ));
}


}

/// @nodoc


class _SaveInProgress implements PlaylistEditState {
  const _SaveInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistEditState.saveInProgress()';
}


}




/// @nodoc


class _Success implements PlaylistEditState {
  const _Success();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistEditState.success()';
}


}




/// @nodoc


class _Fail implements PlaylistEditState {
  const _Fail();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fail);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistEditState.fail()';
}


}




// dart format on
