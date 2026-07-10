// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_edit_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlbumEditState {

 Album? get album; String get title; String get year; List<Track> get allTracks; List<Artist> get allArtists; List<String> get orderedTrackIds; List<String> get selectedArtistIds; Uint8List? get pickedCoverBytes; String? get pickedCoverFilename; bool get loading; bool get saving; bool get saved; bool get error;
/// Create a copy of AlbumEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumEditStateCopyWith<AlbumEditState> get copyWith => _$AlbumEditStateCopyWithImpl<AlbumEditState>(this as AlbumEditState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumEditState&&(identical(other.album, album) || other.album == album)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other.allTracks, allTracks)&&const DeepCollectionEquality().equals(other.allArtists, allArtists)&&const DeepCollectionEquality().equals(other.orderedTrackIds, orderedTrackIds)&&const DeepCollectionEquality().equals(other.selectedArtistIds, selectedArtistIds)&&const DeepCollectionEquality().equals(other.pickedCoverBytes, pickedCoverBytes)&&(identical(other.pickedCoverFilename, pickedCoverFilename) || other.pickedCoverFilename == pickedCoverFilename)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,album,title,year,const DeepCollectionEquality().hash(allTracks),const DeepCollectionEquality().hash(allArtists),const DeepCollectionEquality().hash(orderedTrackIds),const DeepCollectionEquality().hash(selectedArtistIds),const DeepCollectionEquality().hash(pickedCoverBytes),pickedCoverFilename,loading,saving,saved,error);

@override
String toString() {
  return 'AlbumEditState(album: $album, title: $title, year: $year, allTracks: $allTracks, allArtists: $allArtists, orderedTrackIds: $orderedTrackIds, selectedArtistIds: $selectedArtistIds, pickedCoverBytes: $pickedCoverBytes, pickedCoverFilename: $pickedCoverFilename, loading: $loading, saving: $saving, saved: $saved, error: $error)';
}


}

/// @nodoc
abstract mixin class $AlbumEditStateCopyWith<$Res>  {
  factory $AlbumEditStateCopyWith(AlbumEditState value, $Res Function(AlbumEditState) _then) = _$AlbumEditStateCopyWithImpl;
@useResult
$Res call({
 Album? album, String title, String year, List<Track> allTracks, List<Artist> allArtists, List<String> orderedTrackIds, List<String> selectedArtistIds, Uint8List? pickedCoverBytes, String? pickedCoverFilename, bool loading, bool saving, bool saved, bool error
});




}
/// @nodoc
class _$AlbumEditStateCopyWithImpl<$Res>
    implements $AlbumEditStateCopyWith<$Res> {
  _$AlbumEditStateCopyWithImpl(this._self, this._then);

  final AlbumEditState _self;
  final $Res Function(AlbumEditState) _then;

/// Create a copy of AlbumEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? album = freezed,Object? title = null,Object? year = null,Object? allTracks = null,Object? allArtists = null,Object? orderedTrackIds = null,Object? selectedArtistIds = null,Object? pickedCoverBytes = freezed,Object? pickedCoverFilename = freezed,Object? loading = null,Object? saving = null,Object? saved = null,Object? error = null,}) {
  return _then(_self.copyWith(
album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as Album?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,allTracks: null == allTracks ? _self.allTracks : allTracks // ignore: cast_nullable_to_non_nullable
as List<Track>,allArtists: null == allArtists ? _self.allArtists : allArtists // ignore: cast_nullable_to_non_nullable
as List<Artist>,orderedTrackIds: null == orderedTrackIds ? _self.orderedTrackIds : orderedTrackIds // ignore: cast_nullable_to_non_nullable
as List<String>,selectedArtistIds: null == selectedArtistIds ? _self.selectedArtistIds : selectedArtistIds // ignore: cast_nullable_to_non_nullable
as List<String>,pickedCoverBytes: freezed == pickedCoverBytes ? _self.pickedCoverBytes : pickedCoverBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,pickedCoverFilename: freezed == pickedCoverFilename ? _self.pickedCoverFilename : pickedCoverFilename // ignore: cast_nullable_to_non_nullable
as String?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AlbumEditState].
extension AlbumEditStatePatterns on AlbumEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlbumEditState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlbumEditState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlbumEditState value)  $default,){
final _that = this;
switch (_that) {
case _AlbumEditState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlbumEditState value)?  $default,){
final _that = this;
switch (_that) {
case _AlbumEditState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Album? album,  String title,  String year,  List<Track> allTracks,  List<Artist> allArtists,  List<String> orderedTrackIds,  List<String> selectedArtistIds,  Uint8List? pickedCoverBytes,  String? pickedCoverFilename,  bool loading,  bool saving,  bool saved,  bool error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlbumEditState() when $default != null:
return $default(_that.album,_that.title,_that.year,_that.allTracks,_that.allArtists,_that.orderedTrackIds,_that.selectedArtistIds,_that.pickedCoverBytes,_that.pickedCoverFilename,_that.loading,_that.saving,_that.saved,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Album? album,  String title,  String year,  List<Track> allTracks,  List<Artist> allArtists,  List<String> orderedTrackIds,  List<String> selectedArtistIds,  Uint8List? pickedCoverBytes,  String? pickedCoverFilename,  bool loading,  bool saving,  bool saved,  bool error)  $default,) {final _that = this;
switch (_that) {
case _AlbumEditState():
return $default(_that.album,_that.title,_that.year,_that.allTracks,_that.allArtists,_that.orderedTrackIds,_that.selectedArtistIds,_that.pickedCoverBytes,_that.pickedCoverFilename,_that.loading,_that.saving,_that.saved,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Album? album,  String title,  String year,  List<Track> allTracks,  List<Artist> allArtists,  List<String> orderedTrackIds,  List<String> selectedArtistIds,  Uint8List? pickedCoverBytes,  String? pickedCoverFilename,  bool loading,  bool saving,  bool saved,  bool error)?  $default,) {final _that = this;
switch (_that) {
case _AlbumEditState() when $default != null:
return $default(_that.album,_that.title,_that.year,_that.allTracks,_that.allArtists,_that.orderedTrackIds,_that.selectedArtistIds,_that.pickedCoverBytes,_that.pickedCoverFilename,_that.loading,_that.saving,_that.saved,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AlbumEditState implements AlbumEditState {
  const _AlbumEditState({this.album, this.title = '', this.year = '', final  List<Track> allTracks = const [], final  List<Artist> allArtists = const [], final  List<String> orderedTrackIds = const [], final  List<String> selectedArtistIds = const [], this.pickedCoverBytes, this.pickedCoverFilename, this.loading = false, this.saving = false, this.saved = false, this.error = false}): _allTracks = allTracks,_allArtists = allArtists,_orderedTrackIds = orderedTrackIds,_selectedArtistIds = selectedArtistIds;
  

@override final  Album? album;
@override@JsonKey() final  String title;
@override@JsonKey() final  String year;
 final  List<Track> _allTracks;
@override@JsonKey() List<Track> get allTracks {
  if (_allTracks is EqualUnmodifiableListView) return _allTracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allTracks);
}

 final  List<Artist> _allArtists;
@override@JsonKey() List<Artist> get allArtists {
  if (_allArtists is EqualUnmodifiableListView) return _allArtists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allArtists);
}

 final  List<String> _orderedTrackIds;
@override@JsonKey() List<String> get orderedTrackIds {
  if (_orderedTrackIds is EqualUnmodifiableListView) return _orderedTrackIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orderedTrackIds);
}

 final  List<String> _selectedArtistIds;
@override@JsonKey() List<String> get selectedArtistIds {
  if (_selectedArtistIds is EqualUnmodifiableListView) return _selectedArtistIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedArtistIds);
}

@override final  Uint8List? pickedCoverBytes;
@override final  String? pickedCoverFilename;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool saved;
@override@JsonKey() final  bool error;

/// Create a copy of AlbumEditState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumEditStateCopyWith<_AlbumEditState> get copyWith => __$AlbumEditStateCopyWithImpl<_AlbumEditState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlbumEditState&&(identical(other.album, album) || other.album == album)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&const DeepCollectionEquality().equals(other._allTracks, _allTracks)&&const DeepCollectionEquality().equals(other._allArtists, _allArtists)&&const DeepCollectionEquality().equals(other._orderedTrackIds, _orderedTrackIds)&&const DeepCollectionEquality().equals(other._selectedArtistIds, _selectedArtistIds)&&const DeepCollectionEquality().equals(other.pickedCoverBytes, pickedCoverBytes)&&(identical(other.pickedCoverFilename, pickedCoverFilename) || other.pickedCoverFilename == pickedCoverFilename)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,album,title,year,const DeepCollectionEquality().hash(_allTracks),const DeepCollectionEquality().hash(_allArtists),const DeepCollectionEquality().hash(_orderedTrackIds),const DeepCollectionEquality().hash(_selectedArtistIds),const DeepCollectionEquality().hash(pickedCoverBytes),pickedCoverFilename,loading,saving,saved,error);

@override
String toString() {
  return 'AlbumEditState(album: $album, title: $title, year: $year, allTracks: $allTracks, allArtists: $allArtists, orderedTrackIds: $orderedTrackIds, selectedArtistIds: $selectedArtistIds, pickedCoverBytes: $pickedCoverBytes, pickedCoverFilename: $pickedCoverFilename, loading: $loading, saving: $saving, saved: $saved, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AlbumEditStateCopyWith<$Res> implements $AlbumEditStateCopyWith<$Res> {
  factory _$AlbumEditStateCopyWith(_AlbumEditState value, $Res Function(_AlbumEditState) _then) = __$AlbumEditStateCopyWithImpl;
@override @useResult
$Res call({
 Album? album, String title, String year, List<Track> allTracks, List<Artist> allArtists, List<String> orderedTrackIds, List<String> selectedArtistIds, Uint8List? pickedCoverBytes, String? pickedCoverFilename, bool loading, bool saving, bool saved, bool error
});




}
/// @nodoc
class __$AlbumEditStateCopyWithImpl<$Res>
    implements _$AlbumEditStateCopyWith<$Res> {
  __$AlbumEditStateCopyWithImpl(this._self, this._then);

  final _AlbumEditState _self;
  final $Res Function(_AlbumEditState) _then;

/// Create a copy of AlbumEditState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? album = freezed,Object? title = null,Object? year = null,Object? allTracks = null,Object? allArtists = null,Object? orderedTrackIds = null,Object? selectedArtistIds = null,Object? pickedCoverBytes = freezed,Object? pickedCoverFilename = freezed,Object? loading = null,Object? saving = null,Object? saved = null,Object? error = null,}) {
  return _then(_AlbumEditState(
album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as Album?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,allTracks: null == allTracks ? _self._allTracks : allTracks // ignore: cast_nullable_to_non_nullable
as List<Track>,allArtists: null == allArtists ? _self._allArtists : allArtists // ignore: cast_nullable_to_non_nullable
as List<Artist>,orderedTrackIds: null == orderedTrackIds ? _self._orderedTrackIds : orderedTrackIds // ignore: cast_nullable_to_non_nullable
as List<String>,selectedArtistIds: null == selectedArtistIds ? _self._selectedArtistIds : selectedArtistIds // ignore: cast_nullable_to_non_nullable
as List<String>,pickedCoverBytes: freezed == pickedCoverBytes ? _self.pickedCoverBytes : pickedCoverBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,pickedCoverFilename: freezed == pickedCoverFilename ? _self.pickedCoverFilename : pickedCoverFilename // ignore: cast_nullable_to_non_nullable
as String?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
