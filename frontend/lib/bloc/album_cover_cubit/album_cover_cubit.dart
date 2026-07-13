import 'package:basement_music/logger.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_cover_cubit.freezed.dart';
part 'album_cover_state.dart';

class AlbumCoverCubit extends Cubit<AlbumCoverState> {
  final AlbumsRepository albumsRepository;
  final String albumId;

  /// Overrides for the lookup query. Used when searching from the edit page,
  /// where the album's title/artist may be unsaved. Empty falls back to the
  /// stored album values on the server.
  final String titleOverride;
  final String artistOverride;

  AlbumCoverCubit({
    required this.albumsRepository,
    required this.albumId,
    this.titleOverride = '',
    this.artistOverride = '',
  }) : super(const AlbumCoverState.initial());

  Future<void> search() async {
    emit(const AlbumCoverState.searching());

    try {
      final candidates = await albumsRepository.searchCover(albumId, query: titleOverride, artist: artistOverride);
      emit(AlbumCoverState.candidates(candidates: candidates));
    } catch (e) {
      emit(const AlbumCoverState.error(message: 'Cover provider unavailable'));
      logger.e('Error searching album cover: $e');
    }
  }

  Future<void> apply(String mbid) async {
    emit(const AlbumCoverState.applying());
    try {
      await albumsRepository.applyCover(albumId, mbid);
      emit(const AlbumCoverState.applied());
    } catch (e) {
      emit(const AlbumCoverState.error(message: 'Failed to apply cover'));
      logger.e('Error applying album cover: $e');
    }
  }
}
