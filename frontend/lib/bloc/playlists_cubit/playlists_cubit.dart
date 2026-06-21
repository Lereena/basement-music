import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlists_cubit.freezed.dart';
part 'playlists_state.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  final PlaylistsRepository playlistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  PlaylistsCubit({required this.playlistsRepository, required this.connectivityStatusRepository})
    : super(
        playlistsRepository.items.isNotEmpty
            ? PlaylistsState.loaded(playlists: playlistsRepository.items)
            : const PlaylistsState.loading(),
      ) {
    connectivityStatusRepository.statusSubject.listen((status) {
      if (!status.contains(ConnectivityResult.none)) {
        loadPlaylists();
      }
    });

    playlistsRepository.playlistsSubject.listen((value) => _updatePlaylists(value));
  }

  Playlist get openedPlaylist => playlistsRepository.openedPlaylist;

  Future<void> loadPlaylists() async {
    final oldState = state;
    emit(const PlaylistsState.loading());

    try {
      await playlistsRepository.getAllPlaylists();

      if (playlistsRepository.items.isEmpty) {
        emit(const PlaylistsState.empty());
      } else {
        emit(PlaylistsState.loaded(playlists: playlistsRepository.items));
      }
    } catch (e) {
      final oldPlaylists = oldState.maybeWhen(loaded: (playlists) => playlists, orElse: () => <Playlist>[]);

      if (oldPlaylists.isNotEmpty) {
        emit(PlaylistsState.loaded(playlists: oldPlaylists));
      } else {
        emit(const PlaylistsState.error());
      }
      logger.e('Error loading playlists: $e');
    }
  }

  Future<void> uploadPlaylistImage(String playlistId, List<int> bytes, String filename) async {
    await playlistsRepository.updatePlaylistImage(playlistId, bytes, filename);
    await loadPlaylists();
  }

  void _updatePlaylists(List<Playlist> playlists) {
    if (isClosed) return;
    emit(PlaylistsState.loaded(playlists: playlists));
  }
}
