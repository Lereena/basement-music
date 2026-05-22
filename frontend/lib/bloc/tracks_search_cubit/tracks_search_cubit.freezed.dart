// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracks_search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TracksSearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TracksSearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TracksSearchState()';
}


}

/// @nodoc
class $TracksSearchStateCopyWith<$Res>  {
$TracksSearchStateCopyWith(TracksSearchState _, $Res Function(TracksSearchState) __);
}


/// Adds pattern-matching-related methods to [TracksSearchState].
extension TracksSearchStatePatterns on TracksSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _LoadInProgress value)?  loadInProgress,TResult Function( _Success value)?  success,TResult Function( _SuccessEmpty value)?  successEmpty,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _Success() when success != null:
return success(_that);case _SuccessEmpty() when successEmpty != null:
return successEmpty(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _LoadInProgress value)  loadInProgress,required TResult Function( _Success value)  success,required TResult Function( _SuccessEmpty value)  successEmpty,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _LoadInProgress():
return loadInProgress(_that);case _Success():
return success(_that);case _SuccessEmpty():
return successEmpty(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _LoadInProgress value)?  loadInProgress,TResult? Function( _Success value)?  success,TResult? Function( _SuccessEmpty value)?  successEmpty,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _Success() when success != null:
return success(_that);case _SuccessEmpty() when successEmpty != null:
return successEmpty(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String searchQuery)?  loadInProgress,TResult Function( String searchQuery,  List<Track> tracks)?  success,TResult Function( String searchQuery)?  successEmpty,TResult Function()?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that.searchQuery);case _Success() when success != null:
return success(_that.searchQuery,_that.tracks);case _SuccessEmpty() when successEmpty != null:
return successEmpty(_that.searchQuery);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String searchQuery)  loadInProgress,required TResult Function( String searchQuery,  List<Track> tracks)  success,required TResult Function( String searchQuery)  successEmpty,required TResult Function()  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _LoadInProgress():
return loadInProgress(_that.searchQuery);case _Success():
return success(_that.searchQuery,_that.tracks);case _SuccessEmpty():
return successEmpty(_that.searchQuery);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String searchQuery)?  loadInProgress,TResult? Function( String searchQuery,  List<Track> tracks)?  success,TResult? Function( String searchQuery)?  successEmpty,TResult? Function()?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that.searchQuery);case _Success() when success != null:
return success(_that.searchQuery,_that.tracks);case _SuccessEmpty() when successEmpty != null:
return successEmpty(_that.searchQuery);case _Error() when error != null:
return error();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TracksSearchState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TracksSearchState.initial()';
}


}




/// @nodoc


class _LoadInProgress implements TracksSearchState {
  const _LoadInProgress({required this.searchQuery});
  

 final  String searchQuery;

/// Create a copy of TracksSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadInProgressCopyWith<_LoadInProgress> get copyWith => __$LoadInProgressCopyWithImpl<_LoadInProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadInProgress&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery);

@override
String toString() {
  return 'TracksSearchState.loadInProgress(searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$LoadInProgressCopyWith<$Res> implements $TracksSearchStateCopyWith<$Res> {
  factory _$LoadInProgressCopyWith(_LoadInProgress value, $Res Function(_LoadInProgress) _then) = __$LoadInProgressCopyWithImpl;
@useResult
$Res call({
 String searchQuery
});




}
/// @nodoc
class __$LoadInProgressCopyWithImpl<$Res>
    implements _$LoadInProgressCopyWith<$Res> {
  __$LoadInProgressCopyWithImpl(this._self, this._then);

  final _LoadInProgress _self;
  final $Res Function(_LoadInProgress) _then;

/// Create a copy of TracksSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,}) {
  return _then(_LoadInProgress(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Success implements TracksSearchState {
  const _Success({required this.searchQuery, required final  List<Track> tracks}): _tracks = tracks;
  

 final  String searchQuery;
 final  List<Track> _tracks;
 List<Track> get tracks {
  if (_tracks is EqualUnmodifiableListView) return _tracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tracks);
}


/// Create a copy of TracksSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._tracks, _tracks));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,const DeepCollectionEquality().hash(_tracks));

@override
String toString() {
  return 'TracksSearchState.success(searchQuery: $searchQuery, tracks: $tracks)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $TracksSearchStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 String searchQuery, List<Track> tracks
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of TracksSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,Object? tracks = null,}) {
  return _then(_Success(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,tracks: null == tracks ? _self._tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<Track>,
  ));
}


}

/// @nodoc


class _SuccessEmpty implements TracksSearchState {
  const _SuccessEmpty({required this.searchQuery});
  

 final  String searchQuery;

/// Create a copy of TracksSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessEmptyCopyWith<_SuccessEmpty> get copyWith => __$SuccessEmptyCopyWithImpl<_SuccessEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuccessEmpty&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery);

@override
String toString() {
  return 'TracksSearchState.successEmpty(searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$SuccessEmptyCopyWith<$Res> implements $TracksSearchStateCopyWith<$Res> {
  factory _$SuccessEmptyCopyWith(_SuccessEmpty value, $Res Function(_SuccessEmpty) _then) = __$SuccessEmptyCopyWithImpl;
@useResult
$Res call({
 String searchQuery
});




}
/// @nodoc
class __$SuccessEmptyCopyWithImpl<$Res>
    implements _$SuccessEmptyCopyWith<$Res> {
  __$SuccessEmptyCopyWithImpl(this._self, this._then);

  final _SuccessEmpty _self;
  final $Res Function(_SuccessEmpty) _then;

/// Create a copy of TracksSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,}) {
  return _then(_SuccessEmpty(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements TracksSearchState {
  const _Error();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TracksSearchState.error()';
}


}




// dart format on
