part of 'artist_metadata_cubit.dart';

@freezed
abstract class ArtistMetadataState with _$ArtistMetadataState {
  const factory ArtistMetadataState.initial() = _Initial;
  const factory ArtistMetadataState.searching() = _Searching;
  const factory ArtistMetadataState.candidates({required List<ArtistCandidate> candidates}) = _Candidates;
  const factory ArtistMetadataState.previewLoading() = _PreviewLoading;
  const factory ArtistMetadataState.preview({required ArtistMetadataPreview preview}) = _Preview;
  const factory ArtistMetadataState.applying() = _Applying;
  const factory ArtistMetadataState.applied() = _Applied;
  const factory ArtistMetadataState.error({required String message}) = _Error;
}
