// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_uploader_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TracksUploaderState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TracksUploaderState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TracksUploaderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TracksUploaderState()';
}


}

/// @nodoc
class $TracksUploaderStateCopyWith<$Res>  {
$TracksUploaderStateCopyWith(TracksUploaderState _, $Res Function(TracksUploaderState) __);
}


/// Adds pattern-matching-related methods to [TracksUploaderState].
extension TracksUploaderStatePatterns on TracksUploaderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _FilesSelectStart value)?  filesSelectStart,TResult Function( _FilesSelectSuccess value)?  filesSelectSuccess,TResult Function( _UploadInProgress value)?  uploadInProgress,TResult Function( _UploadSuccess value)?  uploadSuccess,TResult Function( _UploadError value)?  uploadError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilesSelectStart() when filesSelectStart != null:
return filesSelectStart(_that);case _FilesSelectSuccess() when filesSelectSuccess != null:
return filesSelectSuccess(_that);case _UploadInProgress() when uploadInProgress != null:
return uploadInProgress(_that);case _UploadSuccess() when uploadSuccess != null:
return uploadSuccess(_that);case _UploadError() when uploadError != null:
return uploadError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _FilesSelectStart value)  filesSelectStart,required TResult Function( _FilesSelectSuccess value)  filesSelectSuccess,required TResult Function( _UploadInProgress value)  uploadInProgress,required TResult Function( _UploadSuccess value)  uploadSuccess,required TResult Function( _UploadError value)  uploadError,}){
final _that = this;
switch (_that) {
case _FilesSelectStart():
return filesSelectStart(_that);case _FilesSelectSuccess():
return filesSelectSuccess(_that);case _UploadInProgress():
return uploadInProgress(_that);case _UploadSuccess():
return uploadSuccess(_that);case _UploadError():
return uploadError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _FilesSelectStart value)?  filesSelectStart,TResult? Function( _FilesSelectSuccess value)?  filesSelectSuccess,TResult? Function( _UploadInProgress value)?  uploadInProgress,TResult? Function( _UploadSuccess value)?  uploadSuccess,TResult? Function( _UploadError value)?  uploadError,}){
final _that = this;
switch (_that) {
case _FilesSelectStart() when filesSelectStart != null:
return filesSelectStart(_that);case _FilesSelectSuccess() when filesSelectSuccess != null:
return filesSelectSuccess(_that);case _UploadInProgress() when uploadInProgress != null:
return uploadInProgress(_that);case _UploadSuccess() when uploadSuccess != null:
return uploadSuccess(_that);case _UploadError() when uploadError != null:
return uploadError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  filesSelectStart,TResult Function( List<({String name, PlatformFile file})> files)?  filesSelectSuccess,TResult Function()?  uploadInProgress,TResult Function()?  uploadSuccess,TResult Function()?  uploadError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilesSelectStart() when filesSelectStart != null:
return filesSelectStart();case _FilesSelectSuccess() when filesSelectSuccess != null:
return filesSelectSuccess(_that.files);case _UploadInProgress() when uploadInProgress != null:
return uploadInProgress();case _UploadSuccess() when uploadSuccess != null:
return uploadSuccess();case _UploadError() when uploadError != null:
return uploadError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  filesSelectStart,required TResult Function( List<({String name, PlatformFile file})> files)  filesSelectSuccess,required TResult Function()  uploadInProgress,required TResult Function()  uploadSuccess,required TResult Function()  uploadError,}) {final _that = this;
switch (_that) {
case _FilesSelectStart():
return filesSelectStart();case _FilesSelectSuccess():
return filesSelectSuccess(_that.files);case _UploadInProgress():
return uploadInProgress();case _UploadSuccess():
return uploadSuccess();case _UploadError():
return uploadError();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  filesSelectStart,TResult? Function( List<({String name, PlatformFile file})> files)?  filesSelectSuccess,TResult? Function()?  uploadInProgress,TResult? Function()?  uploadSuccess,TResult? Function()?  uploadError,}) {final _that = this;
switch (_that) {
case _FilesSelectStart() when filesSelectStart != null:
return filesSelectStart();case _FilesSelectSuccess() when filesSelectSuccess != null:
return filesSelectSuccess(_that.files);case _UploadInProgress() when uploadInProgress != null:
return uploadInProgress();case _UploadSuccess() when uploadSuccess != null:
return uploadSuccess();case _UploadError() when uploadError != null:
return uploadError();case _:
  return null;

}
}

}

/// @nodoc


class _FilesSelectStart with DiagnosticableTreeMixin implements TracksUploaderState {
  const _FilesSelectStart();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TracksUploaderState.filesSelectStart'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilesSelectStart);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TracksUploaderState.filesSelectStart()';
}


}




/// @nodoc


class _FilesSelectSuccess with DiagnosticableTreeMixin implements TracksUploaderState {
  const _FilesSelectSuccess({required final  List<({String name, PlatformFile file})> files}): _files = files;
  

 final  List<({String name, PlatformFile file})> _files;
 List<({String name, PlatformFile file})> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of TracksUploaderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilesSelectSuccessCopyWith<_FilesSelectSuccess> get copyWith => __$FilesSelectSuccessCopyWithImpl<_FilesSelectSuccess>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TracksUploaderState.filesSelectSuccess'))
    ..add(DiagnosticsProperty('files', files));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilesSelectSuccess&&const DeepCollectionEquality().equals(other._files, _files));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TracksUploaderState.filesSelectSuccess(files: $files)';
}


}

/// @nodoc
abstract mixin class _$FilesSelectSuccessCopyWith<$Res> implements $TracksUploaderStateCopyWith<$Res> {
  factory _$FilesSelectSuccessCopyWith(_FilesSelectSuccess value, $Res Function(_FilesSelectSuccess) _then) = __$FilesSelectSuccessCopyWithImpl;
@useResult
$Res call({
 List<({String name, PlatformFile file})> files
});




}
/// @nodoc
class __$FilesSelectSuccessCopyWithImpl<$Res>
    implements _$FilesSelectSuccessCopyWith<$Res> {
  __$FilesSelectSuccessCopyWithImpl(this._self, this._then);

  final _FilesSelectSuccess _self;
  final $Res Function(_FilesSelectSuccess) _then;

/// Create a copy of TracksUploaderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? files = null,}) {
  return _then(_FilesSelectSuccess(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<({String name, PlatformFile file})>,
  ));
}


}

/// @nodoc


class _UploadInProgress with DiagnosticableTreeMixin implements TracksUploaderState {
  const _UploadInProgress();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TracksUploaderState.uploadInProgress'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TracksUploaderState.uploadInProgress()';
}


}




/// @nodoc


class _UploadSuccess with DiagnosticableTreeMixin implements TracksUploaderState {
  const _UploadSuccess();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TracksUploaderState.uploadSuccess'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TracksUploaderState.uploadSuccess()';
}


}




/// @nodoc


class _UploadError with DiagnosticableTreeMixin implements TracksUploaderState {
  const _UploadError();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TracksUploaderState.uploadError'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TracksUploaderState.uploadError()';
}


}




// dart format on
