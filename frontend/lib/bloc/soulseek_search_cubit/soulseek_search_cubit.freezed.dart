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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  connecting,TResult Function( String reason)?  connectionFailed,TResult Function( List<SoulseekSearchResult> results,  Map<String, SoulseekPreload> preloads)?  loaded,TResult Function()?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Connecting() when connecting != null:
return connecting();case _ConnectionFailed() when connectionFailed != null:
return connectionFailed(_that.reason);case _Loaded() when loaded != null:
return loaded(_that.results,_that.preloads);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  connecting,required TResult Function( String reason)  connectionFailed,required TResult Function( List<SoulseekSearchResult> results,  Map<String, SoulseekPreload> preloads)  loaded,required TResult Function()  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Connecting():
return connecting();case _ConnectionFailed():
return connectionFailed(_that.reason);case _Loaded():
return loaded(_that.results,_that.preloads);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  connecting,TResult? Function( String reason)?  connectionFailed,TResult? Function( List<SoulseekSearchResult> results,  Map<String, SoulseekPreload> preloads)?  loaded,TResult? Function()?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Connecting() when connecting != null:
return connecting();case _ConnectionFailed() when connectionFailed != null:
return connectionFailed(_that.reason);case _Loaded() when loaded != null:
return loaded(_that.results,_that.preloads);case _Error() when error != null:
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
  const _Loaded({required final  List<SoulseekSearchResult> results, final  Map<String, SoulseekPreload> preloads = const {}}): _results = results,_preloads = preloads;
  

 final  List<SoulseekSearchResult> _results;
 List<SoulseekSearchResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

// Keyed by resultKey(result): per-card preload lifecycle.
 final  Map<String, SoulseekPreload> _preloads;
// Keyed by resultKey(result): per-card preload lifecycle.
@JsonKey() Map<String, SoulseekPreload> get preloads {
  if (_preloads is EqualUnmodifiableMapView) return _preloads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_preloads);
}


/// Create a copy of SoulseekSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._results, _results)&&const DeepCollectionEquality().equals(other._preloads, _preloads));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_preloads));

@override
String toString() {
  return 'SoulseekSearchState.loaded(results: $results, preloads: $preloads)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $SoulseekSearchStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<SoulseekSearchResult> results, Map<String, SoulseekPreload> preloads
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
@pragma('vm:prefer-inline') $Res call({Object? results = null,Object? preloads = null,}) {
  return _then(_Loaded(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SoulseekSearchResult>,preloads: null == preloads ? _self._preloads : preloads // ignore: cast_nullable_to_non_nullable
as Map<String, SoulseekPreload>,
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




/// @nodoc
mixin _$SoulseekPreload {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SoulseekPreload);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SoulseekPreload()';
}


}

/// @nodoc
class $SoulseekPreloadCopyWith<$Res>  {
$SoulseekPreloadCopyWith(SoulseekPreload _, $Res Function(SoulseekPreload) __);
}


/// Adds pattern-matching-related methods to [SoulseekPreload].
extension SoulseekPreloadPatterns on SoulseekPreload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _PreloadLoading value)?  loading,TResult Function( _PreloadReady value)?  ready,TResult Function( _PreloadSaved value)?  saved,TResult Function( _PreloadError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreloadLoading() when loading != null:
return loading(_that);case _PreloadReady() when ready != null:
return ready(_that);case _PreloadSaved() when saved != null:
return saved(_that);case _PreloadError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _PreloadLoading value)  loading,required TResult Function( _PreloadReady value)  ready,required TResult Function( _PreloadSaved value)  saved,required TResult Function( _PreloadError value)  error,}){
final _that = this;
switch (_that) {
case _PreloadLoading():
return loading(_that);case _PreloadReady():
return ready(_that);case _PreloadSaved():
return saved(_that);case _PreloadError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _PreloadLoading value)?  loading,TResult? Function( _PreloadReady value)?  ready,TResult? Function( _PreloadSaved value)?  saved,TResult? Function( _PreloadError value)?  error,}){
final _that = this;
switch (_that) {
case _PreloadLoading() when loading != null:
return loading(_that);case _PreloadReady() when ready != null:
return ready(_that);case _PreloadSaved() when saved != null:
return saved(_that);case _PreloadError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( SoulseekTempTrack temp)?  ready,TResult Function()?  saved,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreloadLoading() when loading != null:
return loading();case _PreloadReady() when ready != null:
return ready(_that.temp);case _PreloadSaved() when saved != null:
return saved();case _PreloadError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( SoulseekTempTrack temp)  ready,required TResult Function()  saved,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _PreloadLoading():
return loading();case _PreloadReady():
return ready(_that.temp);case _PreloadSaved():
return saved();case _PreloadError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( SoulseekTempTrack temp)?  ready,TResult? Function()?  saved,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _PreloadLoading() when loading != null:
return loading();case _PreloadReady() when ready != null:
return ready(_that.temp);case _PreloadSaved() when saved != null:
return saved();case _PreloadError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _PreloadLoading implements SoulseekPreload {
  const _PreloadLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreloadLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SoulseekPreload.loading()';
}


}




/// @nodoc


class _PreloadReady implements SoulseekPreload {
  const _PreloadReady(this.temp);
  

 final  SoulseekTempTrack temp;

/// Create a copy of SoulseekPreload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreloadReadyCopyWith<_PreloadReady> get copyWith => __$PreloadReadyCopyWithImpl<_PreloadReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreloadReady&&(identical(other.temp, temp) || other.temp == temp));
}


@override
int get hashCode => Object.hash(runtimeType,temp);

@override
String toString() {
  return 'SoulseekPreload.ready(temp: $temp)';
}


}

/// @nodoc
abstract mixin class _$PreloadReadyCopyWith<$Res> implements $SoulseekPreloadCopyWith<$Res> {
  factory _$PreloadReadyCopyWith(_PreloadReady value, $Res Function(_PreloadReady) _then) = __$PreloadReadyCopyWithImpl;
@useResult
$Res call({
 SoulseekTempTrack temp
});




}
/// @nodoc
class __$PreloadReadyCopyWithImpl<$Res>
    implements _$PreloadReadyCopyWith<$Res> {
  __$PreloadReadyCopyWithImpl(this._self, this._then);

  final _PreloadReady _self;
  final $Res Function(_PreloadReady) _then;

/// Create a copy of SoulseekPreload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? temp = null,}) {
  return _then(_PreloadReady(
null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as SoulseekTempTrack,
  ));
}


}

/// @nodoc


class _PreloadSaved implements SoulseekPreload {
  const _PreloadSaved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreloadSaved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SoulseekPreload.saved()';
}


}




/// @nodoc


class _PreloadError implements SoulseekPreload {
  const _PreloadError({required this.message});
  

 final  String message;

/// Create a copy of SoulseekPreload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreloadErrorCopyWith<_PreloadError> get copyWith => __$PreloadErrorCopyWithImpl<_PreloadError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreloadError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SoulseekPreload.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$PreloadErrorCopyWith<$Res> implements $SoulseekPreloadCopyWith<$Res> {
  factory _$PreloadErrorCopyWith(_PreloadError value, $Res Function(_PreloadError) _then) = __$PreloadErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$PreloadErrorCopyWithImpl<$Res>
    implements _$PreloadErrorCopyWith<$Res> {
  __$PreloadErrorCopyWithImpl(this._self, this._then);

  final _PreloadError _self;
  final $Res Function(_PreloadError) _then;

/// Create a copy of SoulseekPreload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_PreloadError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
