import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../logger.dart';
import '../../models/track.dart';
import '../../repositories/playlists_repository.dart';

part 'playlist_edit_event.dart';
part 'playlist_edit_state.dart';

class PlaylistEditorBloc extends Bloc<PlaylistEditorEvent, PlaylistEditState> {
  final PlaylistsRepository playilstsRepository;
  final String playlistId;

  PlaylistEditorBloc({
    required this.playilstsRepository,
    required this.playlistId,
  }) : super(PlayilstEditInitial()) {
    on<PlaylistEditorStarted>(_onPlaylistEditorStarted);
    on<PlaylistEditorSaved>(_onPlaylistEditorSaved);
  }

  FutureOr<void> _onPlaylistEditorStarted(
    PlaylistEditorStarted event,
    Emitter<PlaylistEditState> emit,
  ) async {
    emit(PlaylistEditorSaveInProgress());

    final playlist = await playilstsRepository.getPlaylist(
      playlistId,
    );

    emit(
      PlaylistEditorEditInProgress(
        playlistId: playlist.id,
        title: playlist.title,
        tracks: playlist.tracks,
      ),
    );
  }

  FutureOr<void> _onPlaylistEditorSaved(
    PlaylistEditorSaved event,
    Emitter<PlaylistEditState> emit,
  ) async {
    emit(PlaylistEditorSaveInProgress());

    try {
      await playilstsRepository.editPlaylist(
        id: playlistId,
        title: event.title,
        tracksIds: event.tracksIds,
      );

      emit(PlaylistEditorSuccess());
    } catch (e) {
      emit(PlaylistEditorFail());
      logger.e('Error editing track: $e');
    }
  }
}
