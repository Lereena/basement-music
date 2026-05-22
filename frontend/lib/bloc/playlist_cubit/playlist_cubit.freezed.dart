// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaylistState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistState()';
}


}

/// @nodoc
class $PlaylistStateCopyWith<$Res>  {
$PlaylistStateCopyWith(PlaylistState _, $Res Function(PlaylistState) __);
}


/// Adds pattern-matching-related methods to [PlaylistState].
extension PlaylistStatePatterns on PlaylistState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _LoadInProgress value)?  loadInProgress,TResult Function( _LoadedEmpty value)?  loadedEmpty,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _LoadedEmpty() when loadedEmpty != null:
return loadedEmpty(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _LoadInProgress value)  loadInProgress,required TResult Function( _LoadedEmpty value)  loadedEmpty,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _LoadInProgress():
return loadInProgress(_that);case _LoadedEmpty():
return loadedEmpty(_that);case _Loaded():
return loaded(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _LoadInProgress value)?  loadInProgress,TResult? Function( _LoadedEmpty value)?  loadedEmpty,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _LoadedEmpty() when loadedEmpty != null:
return loadedEmpty(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loadInProgress,TResult Function( String title)?  loadedEmpty,TResult Function( Playlist playlist)?  loaded,TResult Function()?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadInProgress() when loadInProgress != null:
return loadInProgress();case _LoadedEmpty() when loadedEmpty != null:
return loadedEmpty(_that.title);case _Loaded() when loaded != null:
return loaded(_that.playlist);case _Error() when error != null:
return error();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loadInProgress,required TResult Function( String title)  loadedEmpty,required TResult Function( Playlist playlist)  loaded,required TResult Function()  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _LoadInProgress():
return loadInProgress();case _LoadedEmpty():
return loadedEmpty(_that.title);case _Loaded():
return loaded(_that.playlist);case _Error():
return error();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loadInProgress,TResult? Function( String title)?  loadedEmpty,TResult? Function( Playlist playlist)?  loaded,TResult? Function()?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadInProgress() when loadInProgress != null:
return loadInProgress();case _LoadedEmpty() when loadedEmpty != null:
return loadedEmpty(_that.title);case _Loaded() when loaded != null:
return loaded(_that.playlist);case _Error() when error != null:
return error();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements PlaylistState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistState.initial()';
}


}




/// @nodoc


class _LoadInProgress implements PlaylistState {
  const _LoadInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistState.loadInProgress()';
}


}




/// @nodoc


class _LoadedEmpty implements PlaylistState {
  const _LoadedEmpty({required this.title});
  

 final  String title;

/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedEmptyCopyWith<_LoadedEmpty> get copyWith => __$LoadedEmptyCopyWithImpl<_LoadedEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadedEmpty&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,title);

@override
String toString() {
  return 'PlaylistState.loadedEmpty(title: $title)';
}


}

/// @nodoc
abstract mixin class _$LoadedEmptyCopyWith<$Res> implements $PlaylistStateCopyWith<$Res> {
  factory _$LoadedEmptyCopyWith(_LoadedEmpty value, $Res Function(_LoadedEmpty) _then) = __$LoadedEmptyCopyWithImpl;
@useResult
$Res call({
 String title
});




}
/// @nodoc
class __$LoadedEmptyCopyWithImpl<$Res>
    implements _$LoadedEmptyCopyWith<$Res> {
  __$LoadedEmptyCopyWithImpl(this._self, this._then);

  final _LoadedEmpty _self;
  final $Res Function(_LoadedEmpty) _then;

/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,}) {
  return _then(_LoadedEmpty(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loaded implements PlaylistState {
  const _Loaded({required this.playlist});
  

 final  Playlist playlist;

/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.playlist, playlist) || other.playlist == playlist));
}


@override
int get hashCode => Object.hash(runtimeType,playlist);

@override
String toString() {
  return 'PlaylistState.loaded(playlist: $playlist)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $PlaylistStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 Playlist playlist
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playlist = null,}) {
  return _then(_Loaded(
playlist: null == playlist ? _self.playlist : playlist // ignore: cast_nullable_to_non_nullable
as Playlist,
  ));
}


}

/// @nodoc


class _Error implements PlaylistState {
  const _Error();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistState.error()';
}


}




// dart format on
