// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'soulseek_search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SoulseekSearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SoulseekSearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SoulseekSearchState()';
}


}

/// @nodoc
class $SoulseekSearchStateCopyWith<$Res>  {
$SoulseekSearchStateCopyWith(SoulseekSearchState _, $Res Function(SoulseekSearchState) __);
}


/// Adds pattern-matching-related methods to [SoulseekSearchState].
extension SoulseekSearchStatePatterns on SoulseekSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Connecting value)?  connecting,TResult Function( _ConnectionFailed value)?  connectionFailed,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Connecting() when connecting != null:
return connecting(_that);case _ConnectionFailed() when connectionFailed != null:
return connectionFailed(_that);case _Loaded() when loaded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Connecting value)  connecting,required TResult Function( _ConnectionFailed value)  connectionFailed,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Connecting():
return connecting(_that);case _ConnectionFailed():
return connectionFailed(_that);case _Loaded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Connecting value)?  connecting,TResult? Function( _ConnectionFailed value)?  connectionFailed,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Connecting() when connecting != null:
return connecting(_that);case _ConnectionFailed() when connectionFailed != null:
return connectionFailed(_that);case _Loaded() when loaded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  connecting,TResult Function( String reason)?  connectionFailed,TResult Function( List<SoulseekSearchResult> results,  List<SoulseekTempTrack> preloaded,  bool preloadInProgress,  String? preloadError)?  loaded,TResult Function()?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Connecting() when connecting != null:
return connecting();case _ConnectionFailed() when connectionFailed != null:
return connectionFailed(_that.reason);case _Loaded() when loaded != null:
return loaded(_that.results,_that.preloaded,_that.preloadInProgress,_that.preloadError);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  connecting,required TResult Function( String reason)  connectionFailed,required TResult Function( List<SoulseekSearchResult> results,  List<SoulseekTempTrack> preloaded,  bool preloadInProgress,  String? preloadError)  loaded,required TResult Function()  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Connecting():
return connecting();case _ConnectionFailed():
return connectionFailed(_that.reason);case _Loaded():
return loaded(_that.results,_that.preloaded,_that.preloadInProgress,_that.preloadError);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  connecting,TResult? Function( String reason)?  connectionFailed,TResult? Function( List<SoulseekSearchResult> results,  List<SoulseekTempTrack> preloaded,  bool preloadInProgress,  String? preloadError)?  loaded,TResult? Function()?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Connecting() when connecting != null:
return connecting();case _ConnectionFailed() when connectionFailed != null:
return connectionFailed(_that.reason);case _Loaded() when loaded != null:
return loaded(_that.results,_that.preloaded,_that.preloadInProgress,_that.preloadError);case _Error() when error != null:
return error();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements SoulseekSearchState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SoulseekSearchState.initial()';
}


}




/// @nodoc


class _Loading implements SoulseekSearchState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SoulseekSearchState.loading()';
}


}




/// @nodoc


class _Connecting implements SoulseekSearchState {
  const _Connecting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Connecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SoulseekSearchState.connecting()';
}


}




/// @nodoc


class _ConnectionFailed implements SoulseekSearchState {
  const _ConnectionFailed({required this.reason});
  

 final  String reason;

/// Create a copy of SoulseekSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionFailedCopyWith<_ConnectionFailed> get copyWith => __$ConnectionFailedCopyWithImpl<_ConnectionFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionFailed&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'SoulseekSearchState.connectionFailed(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ConnectionFailedCopyWith<$Res> implements $SoulseekSearchStateCopyWith<$Res> {
  factory _$ConnectionFailedCopyWith(_ConnectionFailed value, $Res Function(_ConnectionFailed) _then) = __$ConnectionFailedCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class __$ConnectionFailedCopyWithImpl<$Res>
    implements _$ConnectionFailedCopyWith<$Res> {
  __$ConnectionFailedCopyWithImpl(this._self, this._then);

  final _ConnectionFailed _self;
  final $Res Function(_ConnectionFailed) _then;

/// Create a copy of SoulseekSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(_ConnectionFailed(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loaded implements SoulseekSearchState {
  const _Loaded({required final  List<SoulseekSearchResult> results, required final  List<SoulseekTempTrack> preloaded, this.preloadInProgress = false, this.preloadError}): _results = results,_preloaded = preloaded;
  

 final  List<SoulseekSearchResult> _results;
 List<SoulseekSearchResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  List<SoulseekTempTrack> _preloaded;
 List<SoulseekTempTrack> get preloaded {
  if (_preloaded is EqualUnmodifiableListView) return _preloaded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preloaded);
}

@JsonKey() final  bool preloadInProgress;
 final  String? preloadError;

/// Create a copy of SoulseekSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._results, _results)&&const DeepCollectionEquality().equals(other._preloaded, _preloaded)&&(identical(other.preloadInProgress, preloadInProgress) || other.preloadInProgress == preloadInProgress)&&(identical(other.preloadError, preloadError) || other.preloadError == preloadError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_preloaded),preloadInProgress,preloadError);

@override
String toString() {
  return 'SoulseekSearchState.loaded(results: $results, preloaded: $preloaded, preloadInProgress: $preloadInProgress, preloadError: $preloadError)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $SoulseekSearchStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<SoulseekSearchResult> results, List<SoulseekTempTrack> preloaded, bool preloadInProgress, String? preloadError
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of SoulseekSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? results = null,Object? preloaded = null,Object? preloadInProgress = null,Object? preloadError = freezed,}) {
  return _then(_Loaded(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SoulseekSearchResult>,preloaded: null == preloaded ? _self._preloaded : preloaded // ignore: cast_nullable_to_non_nullable
as List<SoulseekTempTrack>,preloadInProgress: null == preloadInProgress ? _self.preloadInProgress : preloadInProgress // ignore: cast_nullable_to_non_nullable
as bool,preloadError: freezed == preloadError ? _self.preloadError : preloadError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements SoulseekSearchState {
  const _Error();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SoulseekSearchState.error()';
}


}




// dart format on
