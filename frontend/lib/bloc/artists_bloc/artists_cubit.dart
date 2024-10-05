import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../logger.dart';
import '../../models/artist.dart';
import '../../repositories/artists_repository.dart';

part 'artists_state.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  final ArtistsRepository artistsRepository;

  ArtistsCubit({required this.artistsRepository}) : super(ArtistsInitial());

  Future<void> loadArtists() async {
    final oldState = state;
    emit(ArtistsLoading());

    try {
      await artistsRepository.getAllArtists();
      if (artistsRepository.items.isEmpty) {
        emit(ArtistsEmpty());
      } else {
        emit(ArtistsLoaded(artists: artistsRepository.items));
      }
    } catch (e) {
      if (oldState is ArtistsLoaded) {
        emit(ArtistsLoaded(artists: oldState.artists));
      } else {
        emit(ArtistsError(message: e.toString()));
      }
      logger.e('Error loading artists: $e');
    }
  }
}
