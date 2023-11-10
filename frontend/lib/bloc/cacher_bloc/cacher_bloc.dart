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
    on<CacheValidateEvent>(_onCacheValidateEvent);
    on<CacheTrackEvent>(_onCacheTrackEvent);
    on<CacheTracksEvent>(_onCacheTracksEvent);

    add(CacheValidateEvent());
  }

  FutureOr<void> _onCacheValidateEvent(
    CacheValidateEvent event,
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

  FutureOr<void> _onCacheTrackEvent(
    CacheTrackEvent event,
    Emitter<CacherState> emit,
  ) async {
    emit(
      state.copyWith(caching: {...state.caching, event.trackId}),
    );

    emit(await _cacheOneTrack(event.trackId));
  }

  FutureOr<void> _onCacheTracksEvent(
    CacheTracksEvent event,
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
    } catch (e) {
      return state.copyWith(
        caching: state.caching.where((id) => id != trackId).toSet(),
        unsuccessful: {...state.unsuccessful, trackId},
      );
    }
  }
}
