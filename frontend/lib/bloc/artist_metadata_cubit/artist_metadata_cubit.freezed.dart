// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist_metadata_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArtistMetadataState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtistMetadataState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArtistMetadataState()';
}


}

/// @nodoc
class $ArtistMetadataStateCopyWith<$Res>  {
$ArtistMetadataStateCopyWith(ArtistMetadataState _, $Res Function(ArtistMetadataState) __);
}


/// Adds pattern-matching-related methods to [ArtistMetadataState].
extension ArtistMetadataStatePatterns on ArtistMetadataState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Searching value)?  searching,TResult Function( _Candidates value)?  candidates,TResult Function( _PreviewLoading value)?  previewLoading,TResult Function( _Preview value)?  preview,TResult Function( _Applying value)?  applying,TResult Function( _Applied value)?  applied,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Searching() when searching != null:
return searching(_that);case _Candidates() when candidates != null:
return candidates(_that);case _PreviewLoading() when previewLoading != null:
return previewLoading(_that);case _Preview() when preview != null:
return preview(_that);case _Applying() when applying != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Searching value)  searching,required TResult Function( _Candidates value)  candidates,required TResult Function( _PreviewLoading value)  previewLoading,required TResult Function( _Preview value)  preview,required TResult Function( _Applying value)  applying,required TResult Function( _Applied value)  applied,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Searching():
return searching(_that);case _Candidates():
return candidates(_that);case _PreviewLoading():
return previewLoading(_that);case _Preview():
return preview(_that);case _Applying():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Searching value)?  searching,TResult? Function( _Candidates value)?  candidates,TResult? Function( _PreviewLoading value)?  previewLoading,TResult? Function( _Preview value)?  preview,TResult? Function( _Applying value)?  applying,TResult? Function( _Applied value)?  applied,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Searching() when searching != null:
return searching(_that);case _Candidates() when candidates != null:
return candidates(_that);case _PreviewLoading() when previewLoading != null:
return previewLoading(_that);case _Preview() when preview != null:
return preview(_that);case _Applying() when applying != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  searching,TResult Function( List<ArtistCandidate> candidates)?  candidates,TResult Function()?  previewLoading,TResult Function( ArtistMetadataPreview preview)?  preview,TResult Function()?  applying,TResult Function()?  applied,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Searching() when searching != null:
return searching();case _Candidates() when candidates != null:
return candidates(_that.candidates);case _PreviewLoading() when previewLoading != null:
return previewLoading();case _Preview() when preview != null:
return preview(_that.preview);case _Applying() when applying != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  searching,required TResult Function( List<ArtistCandidate> candidates)  candidates,required TResult Function()  previewLoading,required TResult Function( ArtistMetadataPreview preview)  preview,required TResult Function()  applying,required TResult Function()  applied,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Searching():
return searching();case _Candidates():
return candidates(_that.candidates);case _PreviewLoading():
return previewLoading();case _Preview():
return preview(_that.preview);case _Applying():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  searching,TResult? Function( List<ArtistCandidate> candidates)?  candidates,TResult? Function()?  previewLoading,TResult? Function( ArtistMetadataPreview preview)?  preview,TResult? Function()?  applying,TResult? Function()?  applied,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Searching() when searching != null:
return searching();case _Candidates() when candidates != null:
return candidates(_that.candidates);case _PreviewLoading() when previewLoading != null:
return previewLoading();case _Preview() when preview != null:
return preview(_that.preview);case _Applying() when applying != null:
return applying();case _Applied() when applied != null:
return applied();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ArtistMetadataState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArtistMetadataState.initial()';
}


}




/// @nodoc


class _Searching implements ArtistMetadataState {
  const _Searching();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Searching);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArtistMetadataState.searching()';
}


}




/// @nodoc


class _Candidates implements ArtistMetadataState {
  const _Candidates({required final  List<ArtistCandidate> candidates}): _candidates = candidates;
  

 final  List<ArtistCandidate> _candidates;
 List<ArtistCandidate> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}


/// Create a copy of ArtistMetadataState
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
  return 'ArtistMetadataState.candidates(candidates: $candidates)';
}


}

/// @nodoc
abstract mixin class _$CandidatesCopyWith<$Res> implements $ArtistMetadataStateCopyWith<$Res> {
  factory _$CandidatesCopyWith(_Candidates value, $Res Function(_Candidates) _then) = __$CandidatesCopyWithImpl;
@useResult
$Res call({
 List<ArtistCandidate> candidates
});




}
/// @nodoc
class __$CandidatesCopyWithImpl<$Res>
    implements _$CandidatesCopyWith<$Res> {
  __$CandidatesCopyWithImpl(this._self, this._then);

  final _Candidates _self;
  final $Res Function(_Candidates) _then;

/// Create a copy of ArtistMetadataState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? candidates = null,}) {
  return _then(_Candidates(
candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<ArtistCandidate>,
  ));
}


}

/// @nodoc


class _PreviewLoading implements ArtistMetadataState {
  const _PreviewLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviewLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArtistMetadataState.previewLoading()';
}


}




/// @nodoc


class _Preview implements ArtistMetadataState {
  const _Preview({required this.preview});
  

 final  ArtistMetadataPreview preview;

/// Create a copy of ArtistMetadataState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviewCopyWith<_Preview> get copyWith => __$PreviewCopyWithImpl<_Preview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Preview&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,preview);

@override
String toString() {
  return 'ArtistMetadataState.preview(preview: $preview)';
}


}

/// @nodoc
abstract mixin class _$PreviewCopyWith<$Res> implements $ArtistMetadataStateCopyWith<$Res> {
  factory _$PreviewCopyWith(_Preview value, $Res Function(_Preview) _then) = __$PreviewCopyWithImpl;
@useResult
$Res call({
 ArtistMetadataPreview preview
});




}
/// @nodoc
class __$PreviewCopyWithImpl<$Res>
    implements _$PreviewCopyWith<$Res> {
  __$PreviewCopyWithImpl(this._self, this._then);

  final _Preview _self;
  final $Res Function(_Preview) _then;

/// Create a copy of ArtistMetadataState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? preview = null,}) {
  return _then(_Preview(
preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as ArtistMetadataPreview,
  ));
}


}

/// @nodoc


class _Applying implements ArtistMetadataState {
  const _Applying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Applying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArtistMetadataState.applying()';
}


}




/// @nodoc


class _Applied implements ArtistMetadataState {
  const _Applied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Applied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ArtistMetadataState.applied()';
}


}




/// @nodoc


class _Error implements ArtistMetadataState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of ArtistMetadataState
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
  return 'ArtistMetadataState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ArtistMetadataStateCopyWith<$Res> {
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

/// Create a copy of ArtistMetadataState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
