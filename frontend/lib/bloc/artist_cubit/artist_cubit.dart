import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/repositories/artists_repository.dart';

part 'artist_cubit.freezed.dart';
part 'artist_state.dart';

class ArtistCubit extends Cubit<ArtistState> {
  final ArtistsRepository artistsRepository;
  final String artistId;

  late final StreamSubscription<List<Artist>> _subscription;

  ArtistCubit({required this.artistsRepository, required this.artistId}) : super(const ArtistState.initial()) {
    _subscription = artistsRepository.artistsSubject.listen((value) {
      final artist = value.firstWhereOrNull((element) => element.id == artistId);
      if (artist != null) _artistUpdated(artist);
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  Future<void> uploadImage(List<int> bytes, String filename) async {
    await artistsRepository.updateArtistImage(artistId, bytes, filename);
    await artistsRepository.getArtist(artistId);
  }

  Future<void> loadArtist() async {
    emit(const ArtistState.loadInProgress());

    try {
      final artist = await artistsRepository.getArtist(artistId);
      if (isClosed) return;
      emit(ArtistState.loaded(artist: artist));
    } catch (e) {
      emit(const ArtistState.error());
      logger.e('Error loading artist: $e');
    }
  }

  void _artistUpdated(Artist artist) {
    if (isClosed) return;
    emit(ArtistState.loaded(artist: artist));
  }
}
