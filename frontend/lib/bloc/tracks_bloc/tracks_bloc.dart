import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/track.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:basement_music/repositories/repositories.dart';

part 'tracks_event.dart';
part 'tracks_state.dart';

const _tracksInfoKey = 'tracksInfo';

class TracksBloc extends HydratedBloc<TracksEvent, TracksState> {
  final TracksRepository tracksRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  TracksBloc({
    required this.tracksRepository,
    required this.connectivityStatusRepository,
  }) : super(TracksLoadInProgress()) {
    on<TracksLoadStarted>(_onTracksLoadStarted);
    on<TracksUpdated>(_onTracksUpdated);

    connectivityStatusRepository.statusSubject.listen((status) {
      if (status != ConnectivityResult.none) {
        add(TracksLoadStarted());
      }
    });

    tracksRepository.tracksSubject.listen((value) => add(TracksUpdated(value)));
  }

  Future<void> _onTracksLoadStarted(
    TracksLoadStarted event,
    Emitter<TracksState> emit,
  ) async {
    final oldState = state;
    emit(TracksLoadInProgress());

    try {
      await tracksRepository.getAllTracks();

      if (tracksRepository.items.isEmpty) {
        emit(TracksEmptyState());
      } else {
        emit(TracksLoadSuccess(tracksRepository.items));
      }
    } catch (e) {
      if (oldState.tracks.isNotEmpty) {
        emit(TracksLoadSuccess(oldState.tracks));
      } else {
        emit(TracksError());
      }
      logger.e('Error loading tracks: $e');
    }
  }

  void _onTracksUpdated(
    TracksUpdated event,
    Emitter<TracksState> emit,
  ) {
    emit(TracksLoadSuccess(event.tracks));
  }

  @override
  TracksState? fromJson(Map<String, dynamic> json) {
    final state = TracksState.fromJson(json[_tracksInfoKey] as String);
    if (state.tracks.isNotEmpty) {
      return TracksLoadSuccess(state.tracks);
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(TracksState state) => {_tracksInfoKey: state.toJson()};
}
