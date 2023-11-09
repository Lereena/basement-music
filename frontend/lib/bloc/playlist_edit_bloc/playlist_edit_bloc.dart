import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../logger.dart';
import '../../models/track.dart';
import '../../repositories/playlists_repository.dart';

part 'playlist_edit_event.dart';
part 'playlist_edit_state.dart';

class PlaylistEditBloc extends Bloc<PlaylistEditEvent, PlaylistEditState> {
  final PlaylistsRepository playilstsRepository;
  final String playlistId;

  PlaylistEditBloc({
    required this.playilstsRepository,
    required this.playlistId,
  }) : super(PlayilstEditInitial()) {
    on<PlaylistEditingStartEvent>(_onPlaylistEditEvent);
    on<PlaylistSaveEvent>(_onPlaylistSaveEvent);
  }

  FutureOr<void> _onPlaylistEditEvent(
    PlaylistEditingStartEvent event,
    Emitter<PlaylistEditState> emit,
  ) async {
    emit(PlaylistLoading());

    final playlist = await playilstsRepository.getPlaylist(
      playlistId,
    );

    emit(
      PlaylistEditing(
        playlistId: playlist.id,
        title: playlist.title,
        tracks: playlist.tracks,
      ),
    );
  }

  FutureOr<void> _onPlaylistSaveEvent(
    PlaylistSaveEvent event,
    Emitter<PlaylistEditState> emit,
  ) async {
    emit(PlaylistLoading());

    try {
      await playilstsRepository.editPlaylist(
        id: playlistId,
        title: event.title,
        tracksIds: event.tracksIds,
      );

      emit(PlaylistSavingSuccess());
    } catch (e) {
      emit(PlaylistSavingFail());
      logger.e('Error editing track: $e');
    }
  }
}
