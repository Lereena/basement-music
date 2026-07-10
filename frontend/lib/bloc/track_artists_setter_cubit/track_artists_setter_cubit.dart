import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/repositories.dart';

part 'track_artists_setter_cubit.freezed.dart';
part 'track_artists_setter_state.dart';

class TrackArtistsSetterCubit extends Cubit<TrackArtistsSetterState> {
  final ArtistsRepository artistsRepository;
  final TracksRepository tracksRepository;
  final String trackId;

  TrackArtistsSetterCubit({
    required this.artistsRepository,
    required this.tracksRepository,
    required this.trackId,
  }) : super(const TrackArtistsSetterState.loading());

  Future<void> loadArtists() async {
    emit(const TrackArtistsSetterState.loading());
    try {
      await artistsRepository.getAllArtists();
      emit(TrackArtistsSetterState.loaded(artists: artistsRepository.items));
    } catch (e) {
      emit(const TrackArtistsSetterState.error());
      logger.e('Error loading artists: $e');
    }
  }

  Future<void> save(List<String> artistIds) async {
    emit(const TrackArtistsSetterState.saving());
    try {
      final track = await artistsRepository.setTrackArtists(trackId, artistIds);
      tracksRepository.applyTrackUpdate(track);
      emit(const TrackArtistsSetterState.success());
    } catch (e) {
      emit(const TrackArtistsSetterState.error());
      logger.e('Error setting track artists: $e');
    }
  }
}
