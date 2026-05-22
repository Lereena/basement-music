import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/repositories/repositories.dart';

part 'cacher_cubit.freezed.dart';
part 'cacher_state.dart';

class CacherCubit extends Cubit<CacherState> {
  final CacheRepository cacheRepository;
  final TracksRepository tracksRepository;

  CacherCubit({required this.cacheRepository, required this.tracksRepository})
      : super(const CacherState()) {
    tracksRepository.tracksSubject.listen(
      (tracks) => _updateAvailableCount(tracks.length),
    );
  }

  void initialize() {
    if (kIsWeb) {
      emit(const CacherState());
      return;
    }
    emit(
      state.copyWith(
        cached: cacheRepository.items,
        available: tracksRepository.items.length,
      ),
    );
  }

  Future<void> cacheTrackIds(List<String> trackIds) async {
    emit(state.copyWith(caching: {...state.caching, ...trackIds}));
    for (final trackId in trackIds) {
      emit(await _cacheOneTrack(trackId));
    }
  }

  bool _shouldStopCaching = false;

  Future<void> cacheAllAvailableTracks() async {
    _shouldStopCaching = false;

    final tracksToCache = tracksRepository.items
        .where((track) => !cacheRepository.items.contains(track.id))
        .map((track) => track.id);

    emit(state.copyWith(caching: tracksToCache.toSet()));

    for (final trackId in tracksToCache) {
      if (_shouldStopCaching) {
        emit(state.copyWith(caching: {}));
        break;
      } else {
        emit(await _cacheOneTrack(trackId));
      }
    }
  }

  void stopCaching() {
    _shouldStopCaching = true;
  }

  Future<void> removeTrackIds(List<String> trackIds) async {
    for (final trackId in trackIds) {
      emit(await _removeOneTrackFromCache(trackId));
    }
  }

  Future<void> clearCache() async {
    final tracks = cacheRepository.items.toList();
    for (final trackId in tracks) {
      emit(await _removeOneTrackFromCache(trackId));
    }
  }

  void _updateAvailableCount(int count) {
    emit(state.copyWith(available: count));
  }

  Future<CacherState> _cacheOneTrack(String trackId) async {
    try {
      await cacheRepository.cacheTrack(trackId);
      return state.copyWith(
        caching: state.caching.where((id) => id != trackId).toSet(),
        cached: {...state.cached, trackId},
      );
    } catch (_) {
      return state.copyWith(
        caching: state.caching.where((id) => id != trackId).toSet(),
        unsuccessful: {...state.unsuccessful, trackId},
      );
    }
  }

  Future<CacherState> _removeOneTrackFromCache(String trackId) async {
    try {
      await cacheRepository.removeOneTrackFromCache(trackId);
      return state.copyWith(
        cached: state.cached.where((id) => id != trackId).toSet(),
        caching: state.caching.where((id) => id != trackId).toSet(),
        unsuccessful: state.unsuccessful.where((id) => id != trackId).toSet(),
      );
    } catch (_) {
      return state;
    }
  }
}
