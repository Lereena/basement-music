import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../logger.dart';
import '../../models/playlist.dart';
import '../../repositories/playlists_repository.dart';
import '../playlist_bloc/playlist_bloc.dart';
import 'playlists_event.dart';
import 'playlists_state.dart';

const _playlistsInfoKey = 'playlistsInfo';

class PlaylistsBloc extends HydratedBloc<PlaylistsEvent, PlaylistsState> {
  final PlaylistsRepository _playlistsRepository;
  final PlaylistBloc _playlistBloc;

  PlaylistsBloc(this._playlistsRepository, this._playlistBloc)
      : super(PlaylistsLoadingState()) {
    on<PlaylistsLoadEvent>(_onLoadingEvent);
    on<PlaylistAddedEvent>(_onPlaylistAddedEvent);
  }

  Playlist openedPlaylist = Playlist.empty();

  FutureOr<void> _onLoadingEvent(
    PlaylistsLoadEvent event,
    Emitter<PlaylistsState> emit,
  ) async {
    final oldState = state;
    emit(PlaylistsLoadingState());

    try {
      await _playlistsRepository.getAllPlaylists();

      if (_playlistsRepository.items.isEmpty) {
        emit(PlaylistsEmptyState());
      } else {
        _playlistBloc.add(PlaylistsUpdatedEvent());
        emit(PlaylistsLoadedState(_playlistsRepository.items));
      }
    } catch (e) {
      if (oldState.playlists.isNotEmpty) {
        emit(PlaylistsLoadedState(oldState.playlists));
      } else {
        emit(PlaylistsErrorState());
      }
      logger.e('Error loading playlists: $e');
    }
  }

  FutureOr<void> _onPlaylistAddedEvent(
    PlaylistAddedEvent event,
    Emitter<PlaylistsState> emit,
  ) {
    emit(PlaylistsLoadedState(_playlistsRepository.items));
  }

  @override
  PlaylistsState? fromJson(Map<String, dynamic> json) {
    final state = PlaylistsState.fromJson(json[_playlistsInfoKey] as String);
    if (state.playlists.isNotEmpty) {
      return PlaylistsLoadedState(state.playlists);
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(PlaylistsState state) =>
      {_playlistsInfoKey: state.toJson()};
}
