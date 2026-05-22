import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_to_playlist_adder_cubit.freezed.dart';
part 'track_to_playlist_adder_state.dart';

class TrackToPlaylistAdderCubit extends Cubit<TrackToPlaylistAdderState> {
  final TracksRepository tracksRepository;
  final PlaylistsRepository playlistsRepository;
  final String trackId;

  TrackToPlaylistAdderCubit({required this.tracksRepository, required this.playlistsRepository, required this.trackId})
    : super(TrackToPlaylistAdderState.selectInProgress(playlists: playlistsRepository.items));

  Future<void> selectPlaylist(String playlistId) async {
    if (playlistId.isEmpty) {
      emit(const TrackToPlaylistAdderState.error());
      return;
    }

    try {
      await playlistsRepository.addTrackToPlaylist(playlistId, trackId);
      emit(const TrackToPlaylistAdderState.loading());

      final track = tracksRepository.items.firstWhereOrNull((element) => element.id == trackId);
      if (track != null) {
        playlistsRepository.items.firstWhereOrNull((element) => element.id == playlistId)?.tracks.add(track);
      }
      emit(const TrackToPlaylistAdderState.success());
    } catch (e) {
      emit(const TrackToPlaylistAdderState.error());
      logger.e('Error adding track to playlist: $e');
    }
  }
}
