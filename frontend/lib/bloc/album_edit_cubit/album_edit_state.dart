part of 'album_edit_cubit.dart';

@freezed
abstract class AlbumEditState with _$AlbumEditState {
  const factory AlbumEditState({
    Album? album,
    @Default('') String title,
    @Default('') String year,
    @Default([]) List<Track> allTracks,
    @Default([]) List<Artist> allArtists,
    @Default([]) List<String> orderedTrackIds,
    @Default([]) List<String> selectedArtistIds,
    Uint8List? pickedCoverBytes,
    String? pickedCoverFilename,
    @Default(false) bool loading,
    @Default(false) bool saving,
    @Default(false) bool saved,
    @Default(false) bool error,
  }) = _AlbumEditState;
}
