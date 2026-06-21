part of 'playlist_edit_cubit.dart';

@freezed
abstract class PlaylistEditState with _$PlaylistEditState {
  const factory PlaylistEditState.initial() = _Initial;
  const factory PlaylistEditState.editInProgress({
    required String playlistId,
    required String title,
    String? image,
    required List<Track> tracks,
  }) = _EditInProgress;
  const factory PlaylistEditState.saveInProgress() = _SaveInProgress;
  const factory PlaylistEditState.success() = _Success;
  const factory PlaylistEditState.fail() = _Fail;
}
