// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_album_setter_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackAlbumSetterState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackAlbumSetterState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackAlbumSetterState()';
}


}

/// @nodoc
class $TrackAlbumSetterStateCopyWith<$Res>  {
$TrackAlbumSetterStateCopyWith(TrackAlbumSetterState _, $Res Function(TrackAlbumSetterState) __);
}


/// Adds pattern-matching-related methods to [TrackAlbumSetterState].
extension TrackAlbumSetterStatePatterns on TrackAlbumSetterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Loading value)?  loading,TResult Function( _SelectInProgress value)?  selectInProgress,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _SelectInProgress() when selectInProgress != null:
return selectInProgress(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Loading value)  loading,required TResult Function( _SelectInProgress value)  selectInProgress,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Loading():
return loading(_that);case _SelectInProgress():
return selectInProgress(_that);case _Success():
return success(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Loading value)?  loading,TResult? Function( _SelectInProgress value)?  selectInProgress,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _SelectInProgress() when selectInProgress != null:
return selectInProgress(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Album> albums)?  selectInProgress,TResult Function()?  success,TResult Function()?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _SelectInProgress() when selectInProgress != null:
return selectInProgress(_that.albums);case _Success() when success != null:
return success();case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Album> albums)  selectInProgress,required TResult Function()  success,required TResult Function()  error,}) {final _that = this;
switch (_that) {
case _Loading():
return loading();case _SelectInProgress():
return selectInProgress(_that.albums);case _Success():
return success();case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Album> albums)?  selectInProgress,TResult? Function()?  success,TResult? Function()?  error,}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _SelectInProgress() when selectInProgress != null:
return selectInProgress(_that.albums);case _Success() when success != null:
return success();case _Error() when error != null:
return error();case _:
  return null;

}
}

}

/// @nodoc


class _Loading implements TrackAlbumSetterState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackAlbumSetterState.loading()';
}


}




/// @nodoc


class _SelectInProgress implements TrackAlbumSetterState {
  const _SelectInProgress({required final  List<Album> albums}): _albums = albums;
  

 final  List<Album> _albums;
 List<Album> get albums {
  if (_albums is EqualUnmodifiableListView) return _albums;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_albums);
}


/// Create a copy of TrackAlbumSetterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectInProgressCopyWith<_SelectInProgress> get copyWith => __$SelectInProgressCopyWithImpl<_SelectInProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectInProgress&&const DeepCollectionEquality().equals(other._albums, _albums));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_albums));

@override
String toString() {
  return 'TrackAlbumSetterState.selectInProgress(albums: $albums)';
}


}

/// @nodoc
abstract mixin class _$SelectInProgressCopyWith<$Res> implements $TrackAlbumSetterStateCopyWith<$Res> {
  factory _$SelectInProgressCopyWith(_SelectInProgress value, $Res Function(_SelectInProgress) _then) = __$SelectInProgressCopyWithImpl;
@useResult
$Res call({
 List<Album> albums
});




}
/// @nodoc
class __$SelectInProgressCopyWithImpl<$Res>
    implements _$SelectInProgressCopyWith<$Res> {
  __$SelectInProgressCopyWithImpl(this._self, this._then);

  final _SelectInProgress _self;
  final $Res Function(_SelectInProgress) _then;

/// Create a copy of TrackAlbumSetterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? albums = null,}) {
  return _then(_SelectInProgress(
albums: null == albums ? _self._albums : albums // ignore: cast_nullable_to_non_nullable
as List<Album>,
  ));
}


}

/// @nodoc


class _Success implements TrackAlbumSetterState {
  const _Success();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackAlbumSetterState.success()';
}


}




/// @nodoc


class _Error implements TrackAlbumSetterState {
  const _Error();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackAlbumSetterState.error()';
}


}




// dart format on
