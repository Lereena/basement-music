import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/repositories/playlists_repository.dart';

part 'playlist_creation_cubit.freezed.dart';
part 'playlist_creation_state.dart';

class PlaylistCreationCubit extends Cubit<PlaylistCreationState> {
  final PlaylistsRepository _playlistsRepository;

  PlaylistCreationCubit(this._playlistsRepository)
      : super(const PlaylistCreationState.initial());

  Future<void> createPlaylist(String title) async {
    emit(const PlaylistCreationState.inProgress());

    try {
      await _playlistsRepository.createPlaylist(title);
      emit(const PlaylistCreationState.success());
    } catch (e) {
      emit(const PlaylistCreationState.error());
      logger.e('Error creating playlist: $e');
    }
  }
}
