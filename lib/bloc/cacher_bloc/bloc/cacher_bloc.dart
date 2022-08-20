import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../api.dart';

part 'cacher_event.dart';
part 'cacher_state.dart';

class CacherBloc extends Bloc<CacherEvent, CacherState> {
  CacherBloc() : super(CacherInitial()) {
    on<CacheTrackEvent>(_onCacheTrackEvent);
    on<CacheTracksEvent>(_onCacheTracksEvent);
  }

  FutureOr<void> _onCacheTrackEvent(CacheTrackEvent event, Emitter<CacherState> emit) async {
    emit(CacherState(state.caching..add(event.trackId), state.cached, state.unsuccessful));

    _cacheOneTrack(event.trackId);
    emit(state);
  }

  FutureOr<void> _onCacheTracksEvent(CacheTracksEvent event, Emitter<CacherState> emit) async {
    emit(CacherState(state.caching..addAll(event.trackIds), state.cached, state.unsuccessful));

    for (var trackId in event.trackIds) {
      _cacheOneTrack(trackId);
      emit(state);
    }
  }

  void _cacheOneTrack(String trackId) async {
    try {
      await DefaultCacheManager().downloadFile(trackPlayback(trackId), key: trackId);

      state.caching.remove(trackId);
      state.cached.add(trackId);
    } catch (e) {
      state.caching.remove(trackId);
      state.unsuccessful.add(trackId);
    }
  }
}
