import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../api_service.dart';

part 'cacher_event.dart';
part 'cacher_state.dart';

class CacherBloc extends HydratedBloc<CacherEvent, CacherState> {
  final ApiService _apiService;

  CacherBloc(this._apiService) : super(const CacherInitial()) {
    on<CacheTrackEvent>(_onCacheTrackEvent);
    on<CacheTracksEvent>(_onCacheTracksEvent);
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
      await DefaultCacheManager()
          .downloadFile(_apiService.trackPlayback(trackId), key: trackId);

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

  @override
  CacherState? fromJson(Map<String, dynamic> json) =>
      CacherState.fromJson(json['cacher'] as String);

  @override
  Map<String, dynamic>? toJson(CacherState state) => {'cacher': state.toJson()};
}
