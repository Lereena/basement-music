part of 'album_cover_cubit.dart';

@freezed
abstract class AlbumCoverState with _$AlbumCoverState {
  const factory AlbumCoverState.initial() = _Initial;
  const factory AlbumCoverState.searching() = _Searching;
  const factory AlbumCoverState.candidates({required List<ReleaseGroupCandidate> candidates}) = _Candidates;
  const factory AlbumCoverState.applying() = _Applying;
  const factory AlbumCoverState.applied() = _Applied;
  const factory AlbumCoverState.error({required String message}) = _Error;
}
