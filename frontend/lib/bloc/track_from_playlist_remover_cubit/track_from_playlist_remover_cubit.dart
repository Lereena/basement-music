import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_from_playlist_remover_cubit.freezed.dart';
part 'track_from_playlist_remover_state.dart';

class TrackFromPlaylistRemoverCubit extends Cubit<TrackFromPlaylistRemoverState> {
  final TracksRepository tracksRepository;
  final PlaylistsRepository playlistsRepository;
  final String trackId;
  final String playlistId;

  TrackFromPlaylistRemoverCubit({
    required this.tracksRepository,
    required this.playlistsRepository,
    required this.trackId,
    required this.playlistId,
  }) : super(const TrackFromPlaylistRemoverState.initial());

  Future<void> confirm() async {
    try {
      emit(const TrackFromPlaylistRemoverState.loadInProgress());

      await playlistsRepository.removeTrackFromPlaylist(playlistId, trackId);

      playlistsRepository.items
          .firstWhereOrNull((playlist) => playlist.id == playlistId)
          ?.tracks
          .remove(tracksRepository.items.firstWhere((track) => track.id == trackId));

      emit(const TrackFromPlaylistRemoverState.success());
    } catch (e) {
      emit(const TrackFromPlaylistRemoverState.error());
      logger.e('Error removing track from playlist: $e');
    }
  }
}
