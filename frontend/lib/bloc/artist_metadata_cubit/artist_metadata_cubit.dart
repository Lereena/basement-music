import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/repositories/artists_repository.dart';

part 'artist_metadata_cubit.freezed.dart';
part 'artist_metadata_state.dart';

class ArtistMetadataCubit extends Cubit<ArtistMetadataState> {
  final ArtistsRepository artistsRepository;
  final String artistId;

  ArtistMetadataCubit({required this.artistsRepository, required this.artistId})
    : super(const ArtistMetadataState.initial());

  Future<void> search({String query = ''}) async {
    emit(const ArtistMetadataState.searching());
    try {
      final candidates = await artistsRepository.searchMetadata(artistId, query: query);
      emit(ArtistMetadataState.candidates(candidates: candidates));
    } catch (e) {
      emit(const ArtistMetadataState.error(message: 'Metadata provider unavailable'));
      logger.e('Error searching artist metadata: $e');
    }
  }

  Future<void> preview(String mbid) async {
    emit(const ArtistMetadataState.previewLoading());
    try {
      final preview = await artistsRepository.previewMetadata(artistId, mbid);
      emit(ArtistMetadataState.preview(preview: preview));
    } catch (e) {
      emit(const ArtistMetadataState.error(message: 'No metadata found'));
      logger.e('Error previewing artist metadata: $e');
    }
  }

  Future<void> apply({String description = '', String imageUrl = ''}) async {
    emit(const ArtistMetadataState.applying());
    try {
      await artistsRepository.applyMetadata(artistId, description: description, imageUrl: imageUrl);
      emit(const ArtistMetadataState.applied());
    } catch (e) {
      emit(const ArtistMetadataState.error(message: 'Failed to apply metadata'));
      logger.e('Error applying artist metadata: $e');
    }
  }
}
