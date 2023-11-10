import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../logger.dart';
import '../../models/playlist.dart';
import '../../repositories/connectivity_status_repository.dart';
import '../../repositories/playlists_repository.dart';
import '../connectivity_status_bloc/connectivity_status_cubit.dart';
import 'playlists_event.dart';
import 'playlists_state.dart';

const _playlistsInfoKey = 'playlistsInfo';

class PlaylistsBloc extends HydratedBloc<PlaylistsEvent, PlaylistsState> {
  final PlaylistsRepository playlistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  PlaylistsBloc({
    required this.playlistsRepository,
    required this.connectivityStatusRepository,
  }) : super(PlaylistsLoadingState()) {
    on<PlaylistsLoadEvent>(_onLoadingEvent);

    connectivityStatusRepository.statusSubject.listen((status) {
      if (status is ConnectivityStatusHasConnection) add(PlaylistsLoadEvent());
    });

    playlistsRepository.playlistsSubject
        .listen((value) => PlaylistsLoadedState(value));
  }

  Playlist get openedPlaylist => playlistsRepository.openedPlaylist;

  FutureOr<void> _onLoadingEvent(
    PlaylistsLoadEvent event,
    Emitter<PlaylistsState> emit,
  ) async {
    final oldState = state;
    emit(PlaylistsLoadingState());

    try {
      await playlistsRepository.getAllPlaylists();

      if (playlistsRepository.items.isEmpty) {
        emit(PlaylistsEmptyState());
      } else {
        emit(PlaylistsLoadedState(playlistsRepository.items));
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
