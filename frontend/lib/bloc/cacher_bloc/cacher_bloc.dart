import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../app_config.dart';

part 'cacher_event.dart';
part 'cacher_state.dart';

const _cacherInfoKey = 'cacher';

class CacherBloc extends HydratedBloc<CacherEvent, CacherState> {
  final AppConfig _appConfig;

  CacherBloc(this._appConfig) : super(const CacherInitial()) {
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

    final cachedFilesCount = await _getCachedFilesCount();

    // cache is broken
    if (cachedFilesCount != state.cached.length) {
      emit(state.copyWith(cached: {}));
      await DefaultCacheManager().emptyCache();
    }
  }

  Future<int> _getCachedFilesCount() async {
    final cacheDir = await getTemporaryDirectory();

    final cacheExists = await cacheDir.exists();

    if (!cacheExists) return 0;

    final cachedFilesCount = cacheDir
        .listSync(recursive: true)
        .where(
          (element) => element.statSync().type == FileSystemEntityType.file,
        )
        .length;

    return cachedFilesCount;
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
      await DefaultCacheManager().downloadFile(
        '${_appConfig.baseUrl}/api/track/$trackId',
        key: trackId,
      );

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
      CacherState.fromJson(json[_cacherInfoKey] as String);

  @override
  Map<String, dynamic>? toJson(CacherState state) =>
      {_cacherInfoKey: state.toJson()};
}
