import 'package:basement_music/logger.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'artists_cubit.freezed.dart';
part 'artists_state.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  final ArtistsRepository artistsRepository;

  ArtistsCubit({required this.artistsRepository}) : super(const ArtistsState.initial());

  Future<void> uploadArtistImage(String artistId, List<int> bytes, String filename) async {
    await artistsRepository.updateArtistImage(artistId, bytes, filename);
    await loadArtists();
  }

  Future<void> loadArtists() async {
    final oldState = state;
    emit(const ArtistsState.loading());

    try {
      await artistsRepository.getAllArtists();
      if (artistsRepository.items.isEmpty) {
        emit(const ArtistsState.empty());
      } else {
        emit(ArtistsState.loaded(artists: artistsRepository.items));
      }
    } catch (e) {
      oldState.maybeWhen(
        loaded: (artists) => emit(ArtistsState.loaded(artists: artists)),
        orElse: () => emit(ArtistsState.error(message: e.toString())),
      );
      logger.e('Error loading artists: $e');
    }
  }
}
