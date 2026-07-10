// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist_edit_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArtistEditState {

 String get name; String get description; String? get currentImageUrl; Uint8List? get pickedBytes; String? get pickedFilename; bool get loading; bool get saving; bool get saved; bool get error;
/// Create a copy of ArtistEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtistEditStateCopyWith<ArtistEditState> get copyWith => _$ArtistEditStateCopyWithImpl<ArtistEditState>(this as ArtistEditState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtistEditState&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.currentImageUrl, currentImageUrl) || other.currentImageUrl == currentImageUrl)&&const DeepCollectionEquality().equals(other.pickedBytes, pickedBytes)&&(identical(other.pickedFilename, pickedFilename) || other.pickedFilename == pickedFilename)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,currentImageUrl,const DeepCollectionEquality().hash(pickedBytes),pickedFilename,loading,saving,saved,error);

@override
String toString() {
  return 'ArtistEditState(name: $name, description: $description, currentImageUrl: $currentImageUrl, pickedBytes: $pickedBytes, pickedFilename: $pickedFilename, loading: $loading, saving: $saving, saved: $saved, error: $error)';
}


}

/// @nodoc
abstract mixin class $ArtistEditStateCopyWith<$Res>  {
  factory $ArtistEditStateCopyWith(ArtistEditState value, $Res Function(ArtistEditState) _then) = _$ArtistEditStateCopyWithImpl;
@useResult
$Res call({
 String name, String description, String? currentImageUrl, Uint8List? pickedBytes, String? pickedFilename, bool loading, bool saving, bool saved, bool error
});




}
/// @nodoc
class _$ArtistEditStateCopyWithImpl<$Res>
    implements $ArtistEditStateCopyWith<$Res> {
  _$ArtistEditStateCopyWithImpl(this._self, this._then);

  final ArtistEditState _self;
  final $Res Function(ArtistEditState) _then;

/// Create a copy of ArtistEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? currentImageUrl = freezed,Object? pickedBytes = freezed,Object? pickedFilename = freezed,Object? loading = null,Object? saving = null,Object? saved = null,Object? error = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,currentImageUrl: freezed == currentImageUrl ? _self.currentImageUrl : currentImageUrl // ignore: cast_nullable_to_non_nullable
as String?,pickedBytes: freezed == pickedBytes ? _self.pickedBytes : pickedBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,pickedFilename: freezed == pickedFilename ? _self.pickedFilename : pickedFilename // ignore: cast_nullable_to_non_nullable
as String?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ArtistEditState].
extension ArtistEditStatePatterns on ArtistEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArtistEditState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArtistEditState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArtistEditState value)  $default,){
final _that = this;
switch (_that) {
case _ArtistEditState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArtistEditState value)?  $default,){
final _that = this;
switch (_that) {
case _ArtistEditState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  String? currentImageUrl,  Uint8List? pickedBytes,  String? pickedFilename,  bool loading,  bool saving,  bool saved,  bool error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArtistEditState() when $default != null:
return $default(_that.name,_that.description,_that.currentImageUrl,_that.pickedBytes,_that.pickedFilename,_that.loading,_that.saving,_that.saved,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  String? currentImageUrl,  Uint8List? pickedBytes,  String? pickedFilename,  bool loading,  bool saving,  bool saved,  bool error)  $default,) {final _that = this;
switch (_that) {
case _ArtistEditState():
return $default(_that.name,_that.description,_that.currentImageUrl,_that.pickedBytes,_that.pickedFilename,_that.loading,_that.saving,_that.saved,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  String? currentImageUrl,  Uint8List? pickedBytes,  String? pickedFilename,  bool loading,  bool saving,  bool saved,  bool error)?  $default,) {final _that = this;
switch (_that) {
case _ArtistEditState() when $default != null:
return $default(_that.name,_that.description,_that.currentImageUrl,_that.pickedBytes,_that.pickedFilename,_that.loading,_that.saving,_that.saved,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ArtistEditState implements ArtistEditState {
  const _ArtistEditState({this.name = '', this.description = '', this.currentImageUrl, this.pickedBytes, this.pickedFilename, this.loading = false, this.saving = false, this.saved = false, this.error = false});
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override final  String? currentImageUrl;
@override final  Uint8List? pickedBytes;
@override final  String? pickedFilename;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool saved;
@override@JsonKey() final  bool error;

/// Create a copy of ArtistEditState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtistEditStateCopyWith<_ArtistEditState> get copyWith => __$ArtistEditStateCopyWithImpl<_ArtistEditState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtistEditState&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.currentImageUrl, currentImageUrl) || other.currentImageUrl == currentImageUrl)&&const DeepCollectionEquality().equals(other.pickedBytes, pickedBytes)&&(identical(other.pickedFilename, pickedFilename) || other.pickedFilename == pickedFilename)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,currentImageUrl,const DeepCollectionEquality().hash(pickedBytes),pickedFilename,loading,saving,saved,error);

@override
String toString() {
  return 'ArtistEditState(name: $name, description: $description, currentImageUrl: $currentImageUrl, pickedBytes: $pickedBytes, pickedFilename: $pickedFilename, loading: $loading, saving: $saving, saved: $saved, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ArtistEditStateCopyWith<$Res> implements $ArtistEditStateCopyWith<$Res> {
  factory _$ArtistEditStateCopyWith(_ArtistEditState value, $Res Function(_ArtistEditState) _then) = __$ArtistEditStateCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, String? currentImageUrl, Uint8List? pickedBytes, String? pickedFilename, bool loading, bool saving, bool saved, bool error
});




}
/// @nodoc
class __$ArtistEditStateCopyWithImpl<$Res>
    implements _$ArtistEditStateCopyWith<$Res> {
  __$ArtistEditStateCopyWithImpl(this._self, this._then);

  final _ArtistEditState _self;
  final $Res Function(_ArtistEditState) _then;

/// Create a copy of ArtistEditState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? currentImageUrl = freezed,Object? pickedBytes = freezed,Object? pickedFilename = freezed,Object? loading = null,Object? saving = null,Object? saved = null,Object? error = null,}) {
  return _then(_ArtistEditState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,currentImageUrl: freezed == currentImageUrl ? _self.currentImageUrl : currentImageUrl // ignore: cast_nullable_to_non_nullable
as String?,pickedBytes: freezed == pickedBytes ? _self.pickedBytes : pickedBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,pickedFilename: freezed == pickedFilename ? _self.pickedFilename : pickedFilename // ignore: cast_nullable_to_non_nullable
as String?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
