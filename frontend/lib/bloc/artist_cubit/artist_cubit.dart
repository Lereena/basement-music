import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/repositories/artists_repository.dart';

part 'artist_cubit.freezed.dart';
part 'artist_state.dart';

class ArtistCubit extends Cubit<ArtistState> {
  final ArtistsRepository artistsRepository;
  final String artistId;

  ArtistCubit({required this.artistsRepository, required this.artistId}) : super(const ArtistState.initial()) {
    artistsRepository.artistsSubject.listen(
      (value) => _artistUpdated(
        value.firstWhere((element) => element.id == artistId),
      ),
    );
  }

  Future<void> loadArtist() async {
    emit(const ArtistState.loadInProgress());

    try {
      final artist = await artistsRepository.getArtist(artistId);

      if (artist.tracks?.isEmpty ?? true) {
        emit(ArtistState.loadedEmpty(name: artist.name));
      } else {
        emit(ArtistState.loaded(artist: artist));
      }
    } catch (e) {
      emit(const ArtistState.error());
      logger.e('Error loading artist: $e');
    }
  }

  void _artistUpdated(Artist artist) {
    emit(ArtistState.loaded(artist: artist));
  }
}
