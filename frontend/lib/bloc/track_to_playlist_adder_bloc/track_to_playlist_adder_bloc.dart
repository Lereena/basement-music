import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/playlist.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';

part 'track_to_playlist_adder_event.dart';
part 'track_to_playlist_adder_state.dart';

class TrackToPlaylistAdderBloc
    extends Bloc<TrackToPlaylistAdderEvent, TrackToPlaylistAdderState> {
  final TracksRepository tracksRepository;
  final PlaylistsRepository playlistsRepository;
  final String trackId;

  TrackToPlaylistAdderBloc({
    required this.tracksRepository,
    required this.playlistsRepository,
    required this.trackId,
  }) : super(
          TrackToPlaylistAdderPlaylistSelectInProgress(
            playlistsRepository.items,
          ),
        ) {
    on<TrackToPlaylistAdderPlaylistSelected>(_onPlaylistChoosen);
  }

  FutureOr<void> _onPlaylistChoosen(
    TrackToPlaylistAdderPlaylistSelected event,
    Emitter<TrackToPlaylistAdderState> emit,
  ) async {
    if (event.playlistId.isEmpty) {
      emit(TrackToPlaylistAdderError());
      return;
    }

    try {
      await playlistsRepository.addTrackToPlaylist(
        event.playlistId,
        event.trackId,
      );
      emit(TrackToPlaylistAdderLoad());

      playlistsRepository.items
          .firstWhere((element) => element.id == event.playlistId)
          .tracks
          .add(
            tracksRepository.items
                .firstWhere((element) => element.id == event.trackId),
          );
      emit(TrackToPlaylistAdderSuccess());
    } catch (e) {
      emit(TrackToPlaylistAdderError());
      logger.e('Error adding track to playlist: $e');
    }
  }
}
