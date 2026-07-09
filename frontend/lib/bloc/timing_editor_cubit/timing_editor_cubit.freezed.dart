// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timing_editor_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimingEditorState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimingEditorState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimingEditorState()';
}


}

/// @nodoc
class $TimingEditorStateCopyWith<$Res>  {
$TimingEditorStateCopyWith(TimingEditorState _, $Res Function(TimingEditorState) __);
}


/// Adds pattern-matching-related methods to [TimingEditorState].
extension TimingEditorStatePatterns on TimingEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Loading value)?  loading,TResult Function( _Error value)?  error,TResult Function( _Editing value)?  editing,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _Editing() when editing != null:
return editing(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Loading value)  loading,required TResult Function( _Error value)  error,required TResult Function( _Editing value)  editing,}){
final _that = this;
switch (_that) {
case _Loading():
return loading(_that);case _Error():
return error(_that);case _Editing():
return editing(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Loading value)?  loading,TResult? Function( _Error value)?  error,TResult? Function( _Editing value)?  editing,}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _Editing() when editing != null:
return editing(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function()?  error,TResult Function( List<LrcLine> lines,  List<String> metaTags,  int focusIndex,  bool isPlaying,  double playbackRate,  bool canUndo,  bool dirty,  bool saving,  bool trackChanged)?  editing,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error();case _Editing() when editing != null:
return editing(_that.lines,_that.metaTags,_that.focusIndex,_that.isPlaying,_that.playbackRate,_that.canUndo,_that.dirty,_that.saving,_that.trackChanged);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function()  error,required TResult Function( List<LrcLine> lines,  List<String> metaTags,  int focusIndex,  bool isPlaying,  double playbackRate,  bool canUndo,  bool dirty,  bool saving,  bool trackChanged)  editing,}) {final _that = this;
switch (_that) {
case _Loading():
return loading();case _Error():
return error();case _Editing():
return editing(_that.lines,_that.metaTags,_that.focusIndex,_that.isPlaying,_that.playbackRate,_that.canUndo,_that.dirty,_that.saving,_that.trackChanged);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function()?  error,TResult? Function( List<LrcLine> lines,  List<String> metaTags,  int focusIndex,  bool isPlaying,  double playbackRate,  bool canUndo,  bool dirty,  bool saving,  bool trackChanged)?  editing,}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error();case _Editing() when editing != null:
return editing(_that.lines,_that.metaTags,_that.focusIndex,_that.isPlaying,_that.playbackRate,_that.canUndo,_that.dirty,_that.saving,_that.trackChanged);case _:
  return null;

}
}

}

/// @nodoc


class _Loading extends TimingEditorState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimingEditorState.loading()';
}


}




/// @nodoc


class _Error extends TimingEditorState {
  const _Error(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TimingEditorState.error()';
}


}




/// @nodoc


class _Editing extends TimingEditorState {
  const _Editing({required final  List<LrcLine> lines, required final  List<String> metaTags, required this.focusIndex, this.isPlaying = false, this.playbackRate = 1.0, this.canUndo = false, this.dirty = false, this.saving = false, this.trackChanged = false}): _lines = lines,_metaTags = metaTags,super._();
  

 final  List<LrcLine> _lines;
 List<LrcLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

 final  List<String> _metaTags;
 List<String> get metaTags {
  if (_metaTags is EqualUnmodifiableListView) return _metaTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_metaTags);
}

// Line the next stamp lands on (and the nudge strip target).
 final  int focusIndex;
@JsonKey() final  bool isPlaying;
@JsonKey() final  double playbackRate;
@JsonKey() final  bool canUndo;
@JsonKey() final  bool dirty;
@JsonKey() final  bool saving;
// Playback moved on to another track: stamping is meaningless until the
// edited track is resumed.
@JsonKey() final  bool trackChanged;

/// Create a copy of TimingEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditingCopyWith<_Editing> get copyWith => __$EditingCopyWithImpl<_Editing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Editing&&const DeepCollectionEquality().equals(other._lines, _lines)&&const DeepCollectionEquality().equals(other._metaTags, _metaTags)&&(identical(other.focusIndex, focusIndex) || other.focusIndex == focusIndex)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.playbackRate, playbackRate) || other.playbackRate == playbackRate)&&(identical(other.canUndo, canUndo) || other.canUndo == canUndo)&&(identical(other.dirty, dirty) || other.dirty == dirty)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.trackChanged, trackChanged) || other.trackChanged == trackChanged));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_lines),const DeepCollectionEquality().hash(_metaTags),focusIndex,isPlaying,playbackRate,canUndo,dirty,saving,trackChanged);

@override
String toString() {
  return 'TimingEditorState.editing(lines: $lines, metaTags: $metaTags, focusIndex: $focusIndex, isPlaying: $isPlaying, playbackRate: $playbackRate, canUndo: $canUndo, dirty: $dirty, saving: $saving, trackChanged: $trackChanged)';
}


}

/// @nodoc
abstract mixin class _$EditingCopyWith<$Res> implements $TimingEditorStateCopyWith<$Res> {
  factory _$EditingCopyWith(_Editing value, $Res Function(_Editing) _then) = __$EditingCopyWithImpl;
@useResult
$Res call({
 List<LrcLine> lines, List<String> metaTags, int focusIndex, bool isPlaying, double playbackRate, bool canUndo, bool dirty, bool saving, bool trackChanged
});




}
/// @nodoc
class __$EditingCopyWithImpl<$Res>
    implements _$EditingCopyWith<$Res> {
  __$EditingCopyWithImpl(this._self, this._then);

  final _Editing _self;
  final $Res Function(_Editing) _then;

/// Create a copy of TimingEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lines = null,Object? metaTags = null,Object? focusIndex = null,Object? isPlaying = null,Object? playbackRate = null,Object? canUndo = null,Object? dirty = null,Object? saving = null,Object? trackChanged = null,}) {
  return _then(_Editing(
lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<LrcLine>,metaTags: null == metaTags ? _self._metaTags : metaTags // ignore: cast_nullable_to_non_nullable
as List<String>,focusIndex: null == focusIndex ? _self.focusIndex : focusIndex // ignore: cast_nullable_to_non_nullable
as int,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,playbackRate: null == playbackRate ? _self.playbackRate : playbackRate // ignore: cast_nullable_to_non_nullable
as double,canUndo: null == canUndo ? _self.canUndo : canUndo // ignore: cast_nullable_to_non_nullable
as bool,dirty: null == dirty ? _self.dirty : dirty // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,trackChanged: null == trackChanged ? _self.trackChanged : trackChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
