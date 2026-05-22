import 'dart:async';
import 'dart:convert';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'tracks_cubit.freezed.dart';
part 'tracks_state.dart';

const _tracksInfoKey = 'tracksInfo';

class TracksCubit extends HydratedCubit<TracksState> {
  final TracksRepository tracksRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  TracksCubit({required this.tracksRepository, required this.connectivityStatusRepository})
    : super(const TracksState.loadInProgress()) {
    connectivityStatusRepository.statusSubject.listen((status) {
      if (status != ConnectivityResult.none) {
        loadTracks();
      }
    });

    tracksRepository.tracksSubject.listen((value) => _updateTracks(value));
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

  @override
  TracksState? fromJson(Map<String, dynamic> json) {
    try {
      final raw = json[_tracksInfoKey] as String?;
      if (raw == null) return null;
      final tracks = (jsonDecode(raw) as List).map((e) => Track.fromJson(e as Map<String, dynamic>)).toList();
      if (tracks.isEmpty) return null;
      return TracksState.loaded(tracks: tracks);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(TracksState state) {
    final tracks = state.maybeWhen(loaded: (tracks) => tracks, orElse: () => null);
    if (tracks == null) return null;
    return {_tracksInfoKey: jsonEncode(tracks.map((e) => e.toJson()).toList())};
  }
}
