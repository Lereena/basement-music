import 'dart:async';
import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../logger.dart';
import '../../models/playlist.dart';
import '../../repositories/connectivity_status_repository.dart';
import '../../repositories/playlists_repository.dart';
import '../connectivity_status_bloc/connectivity_status_cubit.dart';

part 'playlists_event.dart';
part 'playlists_state.dart';

const _playlistsInfoKey = 'playlistsInfo';

class PlaylistsBloc extends HydratedBloc<PlaylistsEvent, PlaylistsState> {
  final PlaylistsRepository playlistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  PlaylistsBloc({
    required this.playlistsRepository,
    required this.connectivityStatusRepository,
  }) : super(PlaylistsLoadingState()) {
    on<PlaylistsLoadEvent>(_onLoadingEvent);
    on<PlaylistsUpdated>(_onPlaylistsUpdated);

    connectivityStatusRepository.statusSubject.listen((status) {
      if (status is ConnectivityStatusHasConnection) add(PlaylistsLoadEvent());
    });

    playlistsRepository.playlistsSubject
        .listen((value) => add(PlaylistsUpdated(value)));
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

  FutureOr<void> _onPlaylistsUpdated(
    PlaylistsUpdated event,
    Emitter<PlaylistsState> emit,
  ) {
    emit(PlaylistsLoadedState(event.playlists));
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
