import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../repositories/cache_repository.dart';

part 'cacher_event.dart';
part 'cacher_state.dart';

class CacherBloc extends Bloc<CacherEvent, CacherState> {
  final CacheRepository cacheRepository;

  CacherBloc(this.cacheRepository) : super(const CacherInitial()) {
    on<CacherValidateStarted>(_onValidateStarted);
    on<CacherTracksCachingStarted>(_onTracksCachingStarted);
    on<CacherRemoveTracksFromCacheStarted>(
      _onCacherRemoveTracksFromCacheStarted,
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
      emit(state.copyWith(cached: {}));
    } else {
      emit(CacherState(cached: cacheRepository.items));
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
