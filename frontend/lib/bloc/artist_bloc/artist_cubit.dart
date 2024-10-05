import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../logger.dart';
import '../../models/artist.dart';
import '../../repositories/artists_repository.dart';

part 'artist_state.dart';

class ArtistCubit extends Cubit<ArtistState> {
  final ArtistsRepository artistsRepository;
  final String artistId;

  ArtistCubit({required this.artistsRepository, required this.artistId}) : super(ArtistInitial()) {
    artistsRepository.artistsSubject.listen(
      (value) => _artistUpdated(
        value.firstWhere((element) => element.id == artistId),
      ),
    );
  }

  Future<void> loadArtist() async {
    emit(ArtistLoadInProgress());

    try {
      final artist = await artistsRepository.getArtist(artistId);

      if (artist.tracks?.isEmpty ?? true) {
        emit(ArtistLoadedEmpty(name: artist.name));
      } else {
        emit(ArtistLoaded(artist: artist));
      }
    } catch (e) {
      emit(ArtistError());
      logger.e('Error loading artist: $e');
    }
  }

  void _artistUpdated(Artist artist) {
    emit(ArtistLoaded(artist: artist));
  }
}
