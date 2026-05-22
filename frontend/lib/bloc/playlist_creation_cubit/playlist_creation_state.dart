part of 'playlist_creation_cubit.dart';

@freezed
abstract class PlaylistCreationState with _$PlaylistCreationState {
  const factory PlaylistCreationState.initial() = _Initial;
  const factory PlaylistCreationState.inProgress() = _InProgress;
  const factory PlaylistCreationState.success() = _Success;
  const factory PlaylistCreationState.error() = _Error;
}
