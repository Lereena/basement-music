import 'dart:async';
import 'dart:convert';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'playlists_cubit.freezed.dart';
part 'playlists_state.dart';

const _playlistsInfoKey = 'playlistsInfo';

class PlaylistsCubit extends HydratedCubit<PlaylistsState> {
  final PlaylistsRepository playlistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  PlaylistsCubit({required this.playlistsRepository, required this.connectivityStatusRepository})
    : super(const PlaylistsState.loading()) {
    connectivityStatusRepository.statusSubject.listen((status) {
      if (status != ConnectivityResult.none) {
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

  void _updatePlaylists(List<Playlist> playlists) {
    if (isClosed) return;
    emit(PlaylistsState.loaded(playlists: playlists));
  }

  @override
  PlaylistsState? fromJson(Map<String, dynamic> json) {
    try {
      final raw = json[_playlistsInfoKey] as String?;
      if (raw == null) return null;

      final playlists = (jsonDecode(raw) as List).map((e) => Playlist.fromJson(e as Map<String, dynamic>)).toList();
      if (playlists.isEmpty) return null;

      return PlaylistsState.loaded(playlists: playlists);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PlaylistsState state) {
    final playlists = state.maybeWhen(loaded: (playlists) => playlists, orElse: () => null);
    if (playlists == null) return null;

    return {_playlistsInfoKey: jsonEncode(playlists.map((e) => e.toJson()).toList())};
  }
}
