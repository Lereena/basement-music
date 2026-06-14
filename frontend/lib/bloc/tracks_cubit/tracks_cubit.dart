import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracks_cubit.freezed.dart';
part 'tracks_state.dart';

class TracksCubit extends Cubit<TracksState> {
  final TracksRepository tracksRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  TracksCubit({required this.tracksRepository, required this.connectivityStatusRepository})
    : super(
        tracksRepository.items.isNotEmpty
            ? TracksState.loaded(tracks: tracksRepository.items)
            : const TracksState.loadInProgress(),
      ) {
    connectivityStatusRepository.statusSubject.listen((status) {
      if (!status.contains(ConnectivityResult.none) && state is! _LoadInProgress) {
        loadTracks();
      }
    });

    tracksRepository.tracksSubject.listen((value) => _updateTracks(value));

    if (tracksRepository.items.isEmpty) {
      loadTracks();
    }
  }

  Future<void> loadTracks() async {
    final oldState = state;
    emit(const TracksState.loadInProgress());

    try {
      await tracksRepository.getAllTracks();

      if (tracksRepository.items.isEmpty) {
        emit(const TracksState.empty());
      } else {
        emit(TracksState.loaded(tracks: tracksRepository.items));
      }
    } catch (e) {
      final oldTracks = oldState.maybeWhen(loaded: (tracks) => tracks, orElse: () => <Track>[]);
      if (oldTracks.isNotEmpty) {
        emit(TracksState.loaded(tracks: oldTracks));
      } else {
        emit(const TracksState.error());
      }
      logger.e('Error loading tracks: $e');
    }
  }

  void _updateTracks(List<Track> tracks) {
    emit(TracksState.loaded(tracks: tracks));
  }
}
