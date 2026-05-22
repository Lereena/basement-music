// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_extractor_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$YoutubeExtractorState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YoutubeExtractorState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'YoutubeExtractorState()';
}


}

/// @nodoc
class $YoutubeExtractorStateCopyWith<$Res>  {
$YoutubeExtractorStateCopyWith(YoutubeExtractorState _, $Res Function(YoutubeExtractorState) __);
}


/// Adds pattern-matching-related methods to [YoutubeExtractorState].
extension YoutubeExtractorStatePatterns on YoutubeExtractorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LinkInputInProgress value)?  linkInputInProgress,TResult Function( _LinkInputError value)?  linkInputError,TResult Function( _LoadInProgress value)?  loadInProgress,TResult Function( _InfoObserve value)?  infoObserve,TResult Function( _ExtractInProgress value)?  extractInProgress,TResult Function( _ExtractSuccess value)?  extractSuccess,TResult Function( _ExtractError value)?  extractError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LinkInputInProgress() when linkInputInProgress != null:
return linkInputInProgress(_that);case _LinkInputError() when linkInputError != null:
return linkInputError(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _InfoObserve() when infoObserve != null:
return infoObserve(_that);case _ExtractInProgress() when extractInProgress != null:
return extractInProgress(_that);case _ExtractSuccess() when extractSuccess != null:
return extractSuccess(_that);case _ExtractError() when extractError != null:
return extractError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LinkInputInProgress value)  linkInputInProgress,required TResult Function( _LinkInputError value)  linkInputError,required TResult Function( _LoadInProgress value)  loadInProgress,required TResult Function( _InfoObserve value)  infoObserve,required TResult Function( _ExtractInProgress value)  extractInProgress,required TResult Function( _ExtractSuccess value)  extractSuccess,required TResult Function( _ExtractError value)  extractError,}){
final _that = this;
switch (_that) {
case _LinkInputInProgress():
return linkInputInProgress(_that);case _LinkInputError():
return linkInputError(_that);case _LoadInProgress():
return loadInProgress(_that);case _InfoObserve():
return infoObserve(_that);case _ExtractInProgress():
return extractInProgress(_that);case _ExtractSuccess():
return extractSuccess(_that);case _ExtractError():
return extractError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LinkInputInProgress value)?  linkInputInProgress,TResult? Function( _LinkInputError value)?  linkInputError,TResult? Function( _LoadInProgress value)?  loadInProgress,TResult? Function( _InfoObserve value)?  infoObserve,TResult? Function( _ExtractInProgress value)?  extractInProgress,TResult? Function( _ExtractSuccess value)?  extractSuccess,TResult? Function( _ExtractError value)?  extractError,}){
final _that = this;
switch (_that) {
case _LinkInputInProgress() when linkInputInProgress != null:
return linkInputInProgress(_that);case _LinkInputError() when linkInputError != null:
return linkInputError(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _InfoObserve() when infoObserve != null:
return infoObserve(_that);case _ExtractInProgress() when extractInProgress != null:
return extractInProgress(_that);case _ExtractSuccess() when extractSuccess != null:
return extractSuccess(_that);case _ExtractError() when extractError != null:
return extractError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? url)?  linkInputInProgress,TResult Function()?  linkInputError,TResult Function()?  loadInProgress,TResult Function( String url,  String artist,  String title)?  infoObserve,TResult Function()?  extractInProgress,TResult Function()?  extractSuccess,TResult Function()?  extractError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkInputInProgress() when linkInputInProgress != null:
return linkInputInProgress(_that.url);case _LinkInputError() when linkInputError != null:
return linkInputError();case _LoadInProgress() when loadInProgress != null:
return loadInProgress();case _InfoObserve() when infoObserve != null:
return infoObserve(_that.url,_that.artist,_that.title);case _ExtractInProgress() when extractInProgress != null:
return extractInProgress();case _ExtractSuccess() when extractSuccess != null:
return extractSuccess();case _ExtractError() when extractError != null:
return extractError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? url)  linkInputInProgress,required TResult Function()  linkInputError,required TResult Function()  loadInProgress,required TResult Function( String url,  String artist,  String title)  infoObserve,required TResult Function()  extractInProgress,required TResult Function()  extractSuccess,required TResult Function()  extractError,}) {final _that = this;
switch (_that) {
case _LinkInputInProgress():
return linkInputInProgress(_that.url);case _LinkInputError():
return linkInputError();case _LoadInProgress():
return loadInProgress();case _InfoObserve():
return infoObserve(_that.url,_that.artist,_that.title);case _ExtractInProgress():
return extractInProgress();case _ExtractSuccess():
return extractSuccess();case _ExtractError():
return extractError();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? url)?  linkInputInProgress,TResult? Function()?  linkInputError,TResult? Function()?  loadInProgress,TResult? Function( String url,  String artist,  String title)?  infoObserve,TResult? Function()?  extractInProgress,TResult? Function()?  extractSuccess,TResult? Function()?  extractError,}) {final _that = this;
switch (_that) {
case _LinkInputInProgress() when linkInputInProgress != null:
return linkInputInProgress(_that.url);case _LinkInputError() when linkInputError != null:
return linkInputError();case _LoadInProgress() when loadInProgress != null:
return loadInProgress();case _InfoObserve() when infoObserve != null:
return infoObserve(_that.url,_that.artist,_that.title);case _ExtractInProgress() when extractInProgress != null:
return extractInProgress();case _ExtractSuccess() when extractSuccess != null:
return extractSuccess();case _ExtractError() when extractError != null:
return extractError();case _:
  return null;

}
}

}

/// @nodoc


class _LinkInputInProgress implements YoutubeExtractorState {
  const _LinkInputInProgress({this.url});
  

 final  String? url;

/// Create a copy of YoutubeExtractorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkInputInProgressCopyWith<_LinkInputInProgress> get copyWith => __$LinkInputInProgressCopyWithImpl<_LinkInputInProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkInputInProgress&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'YoutubeExtractorState.linkInputInProgress(url: $url)';
}


}

/// @nodoc
abstract mixin class _$LinkInputInProgressCopyWith<$Res> implements $YoutubeExtractorStateCopyWith<$Res> {
  factory _$LinkInputInProgressCopyWith(_LinkInputInProgress value, $Res Function(_LinkInputInProgress) _then) = __$LinkInputInProgressCopyWithImpl;
@useResult
$Res call({
 String? url
});




}
/// @nodoc
class __$LinkInputInProgressCopyWithImpl<$Res>
    implements _$LinkInputInProgressCopyWith<$Res> {
  __$LinkInputInProgressCopyWithImpl(this._self, this._then);

  final _LinkInputInProgress _self;
  final $Res Function(_LinkInputInProgress) _then;

/// Create a copy of YoutubeExtractorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = freezed,}) {
  return _then(_LinkInputInProgress(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _LinkInputError implements YoutubeExtractorState {
  const _LinkInputError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkInputError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'YoutubeExtractorState.linkInputError()';
}


}




/// @nodoc


class _LoadInProgress implements YoutubeExtractorState {
  const _LoadInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'YoutubeExtractorState.loadInProgress()';
}


}




/// @nodoc


class _InfoObserve implements YoutubeExtractorState {
  const _InfoObserve({required this.url, required this.artist, required this.title});
  

 final  String url;
 final  String artist;
 final  String title;

/// Create a copy of YoutubeExtractorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InfoObserveCopyWith<_InfoObserve> get copyWith => __$InfoObserveCopyWithImpl<_InfoObserve>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InfoObserve&&(identical(other.url, url) || other.url == url)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,url,artist,title);

@override
String toString() {
  return 'YoutubeExtractorState.infoObserve(url: $url, artist: $artist, title: $title)';
}


}

/// @nodoc
abstract mixin class _$InfoObserveCopyWith<$Res> implements $YoutubeExtractorStateCopyWith<$Res> {
  factory _$InfoObserveCopyWith(_InfoObserve value, $Res Function(_InfoObserve) _then) = __$InfoObserveCopyWithImpl;
@useResult
$Res call({
 String url, String artist, String title
});




}
/// @nodoc
class __$InfoObserveCopyWithImpl<$Res>
    implements _$InfoObserveCopyWith<$Res> {
  __$InfoObserveCopyWithImpl(this._self, this._then);

  final _InfoObserve _self;
  final $Res Function(_InfoObserve) _then;

/// Create a copy of YoutubeExtractorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,Object? artist = null,Object? title = null,}) {
  return _then(_InfoObserve(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ExtractInProgress implements YoutubeExtractorState {
  const _ExtractInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'YoutubeExtractorState.extractInProgress()';
}


}




/// @nodoc


class _ExtractSuccess implements YoutubeExtractorState {
  const _ExtractSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'YoutubeExtractorState.extractSuccess()';
}


}




/// @nodoc


class _ExtractError implements YoutubeExtractorState {
  const _ExtractError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'YoutubeExtractorState.extractError()';
}


}




// dart format on
