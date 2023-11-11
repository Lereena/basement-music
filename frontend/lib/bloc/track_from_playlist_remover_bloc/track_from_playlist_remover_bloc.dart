import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../logger.dart';
import '../../repositories/repositories.dart';

part 'track_from_playlist_remover_event.dart';
part 'track_from_playlist_remover_state.dart';

class TrackFromPlaylistRemoverBloc
    extends Bloc<TrackFromPlaylistRemoverEvent, TrackFromPlaylistRemoverState> {
  final TracksRepository tracksRepository;
  final PlaylistsRepository playlistsRepository;
  final String trackId;
  final String playlistId;

  TrackFromPlaylistRemoverBloc({
    required this.tracksRepository,
    required this.playlistsRepository,
    required this.trackId,
    required this.playlistId,
  }) : super(RemoveFromPlaylistInitial()) {
    on<TrackFromPlaylistRemoverConfirmed>(_onTrackFromPlaylistRemoverConfirmed);
  }

  FutureOr<void> _onTrackFromPlaylistRemoverConfirmed(
    TrackFromPlaylistRemoverConfirmed event,
    Emitter<TrackFromPlaylistRemoverState> emit,
  ) async {
    try {
      emit(TrackFromPlaylistRemoverLoadingInProgress());

      await playlistsRepository.removeTrackFromPlaylist(
        playlistId,
        trackId,
      );

      playlistsRepository.items
          .firstWhere((playlist) => playlist.id == playlistId)
          .tracks
          .remove(
            tracksRepository.items.firstWhere((track) => track.id == trackId),
          );

      emit(TrackFromPlaylistRemoverSuccess());
    } catch (e) {
      emit(TrackFromPlaylistRemoverError());
      logger.e('Error removing track from playlist: $e');
    }
  }
}
