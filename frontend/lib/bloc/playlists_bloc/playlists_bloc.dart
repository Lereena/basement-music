import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/bloc/connectivity_status_bloc/connectivity_status_cubit.dart';

part 'playlists_event.dart';
part 'playlists_state.dart';

const _playlistsInfoKey = 'playlistsInfo';

class PlaylistsCubit extends HydratedCubit<PlaylistsState> {
  final PlaylistsRepository playlistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  PlaylistsCubit({
    required this.playlistsRepository,
    required this.connectivityStatusRepository,
  }) : super(PlaylistsLoadingState()) {
    connectivityStatusRepository.statusSubject.listen((status) {
      if (status is ConnectivityStatusHasConnection) {
        loadPlaylists();
      }
    });

    playlistsRepository.playlistsSubject.listen((value) => updatePlaylists(value));
  }

  Playlist get openedPlaylist => playlistsRepository.openedPlaylist;

  Future<void> loadPlaylists() async {
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

  void updatePlaylists(List<Playlist> playlists) {
    if (isClosed) return;
    emit(PlaylistsLoadedState(playlists));
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
  Map<String, dynamic>? toJson(PlaylistsState state) => {_playlistsInfoKey: state.toJson()};
}
