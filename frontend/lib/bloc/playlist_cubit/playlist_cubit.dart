import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/playlists_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_cubit.freezed.dart';
part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final PlaylistsRepository playlistsRepository;
  final String playlistId;

  PlaylistCubit({required this.playlistsRepository, required this.playlistId}) : super(const PlaylistState.initial()) {
    playlistsRepository.playlistsSubject.listen(
      (value) => _updatePlaylist(value.firstWhere((element) => element.id == playlistId)),
    );
  }

  Future<void> load() async {
    emit(const PlaylistState.loadInProgress());

    try {
      final playlist = await playlistsRepository.getPlaylist(playlistId);

      if (playlist.tracks.isEmpty) {
        emit(PlaylistState.loadedEmpty(title: playlist.title));
      } else {
        emit(PlaylistState.loaded(playlist: playlist));
      }
    } catch (e) {
      emit(const PlaylistState.error());
      logger.e('Error loading playlist: $e');
    }
  }

  void _updatePlaylist(Playlist playlist) {
    if (isClosed) return;
    emit(PlaylistState.loaded(playlist: playlist));
  }
}
