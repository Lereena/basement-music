import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../repositories/repositories.dart';

part 'cacher_event.dart';
part 'cacher_state.dart';

class CacherBloc extends Bloc<CacherEvent, CacherState> {
  final CacheRepository cacheRepository;
  final TracksRepository tracksRepository;

  CacherBloc({required this.cacheRepository, required this.tracksRepository})
      : super(const CacherInitial()) {
    on<CacherValidateStarted>(_onValidateStarted);
    on<CacherTracksCachingStarted>(_onTracksCachingStarted);
    on<CacherCacheAllAvailableTracksStarted>(
      _onCacherCacheAllAvailableTracksStarted,
    );
    on<CacherRemoveTracksFromCacheStarted>(
      _onCacherRemoveTracksFromCacheStarted,
    );
    on<CacherAvailableTracksUpdated>(_onCacherAvailableTracksUpdated);
    on<CacherClearingStarted>(_onCacherClearingStarted);

    tracksRepository.tracksSubject.listen(
      (tracks) => add(CacherAvailableTracksUpdated(tracks.length)),
    );
  }

  FutureOr<void> _onValidateStarted(
    CacherValidateStarted event,
    Emitter<CacherState> emit,
  ) async {
    if (kIsWeb) {
      emit(const CacherInitial());
      return;
    }

    final isCacheValid = await cacheRepository.validateCache();

    if (!isCacheValid) {
      emit(
        state.copyWith(
          cached: {},
          available: tracksRepository.items.length,
        ),
      );
    } else {
      emit(
        state.copyWith(
          cached: cacheRepository.items,
          available: tracksRepository.items.length,
        ),
      );
    }
  }

  FutureOr<void> _onTracksCachingStarted(
    CacherTracksCachingStarted event,
    Emitter<CacherState> emit,
  ) async {
    emit(
      state.copyWith(caching: {...state.caching, ...event.trackIds}),
    );

    for (final trackId in event.trackIds) {
      emit(await _cacheOneTrack(trackId));
    }
  }

  FutureOr<void> _onCacherCacheAllAvailableTracksStarted(
    CacherCacheAllAvailableTracksStarted event,
    Emitter<CacherState> emit,
  ) async {
    final tracksToCache = tracksRepository.items
        .where((track) => !cacheRepository.items.contains(track.id))
        .map((track) => track.id);

    emit(state.copyWith(caching: tracksToCache.toSet()));

    for (final trackId in tracksToCache) {
      emit(await _cacheOneTrack(trackId));
    }
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

  FutureOr<void> _onCacherRemoveTracksFromCacheStarted(
    CacherRemoveTracksFromCacheStarted event,
    Emitter<CacherState> emit,
  ) async {
    for (final trackId in event.trackIds) {
      emit(await _removeOneTrackFromCache(trackId));
    }
  }

  FutureOr<void> _onCacherClearingStarted(
    CacherClearingStarted event,
    Emitter<CacherState> emit,
  ) async {
    final tracksToRemove = tracksRepository.items
        .where((track) => cacheRepository.items.contains(track.id));

    for (final track in tracksToRemove) {
      emit(await _removeOneTrackFromCache(track.id));
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

  FutureOr<void> _onCacherAvailableTracksUpdated(
    CacherAvailableTracksUpdated event,
    Emitter<CacherState> emit,
  ) {
    emit(state.copyWith(available: event.availableTracksCout));
  }
}
