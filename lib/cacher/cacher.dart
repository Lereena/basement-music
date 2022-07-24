import 'package:basement_music/api.dart';
import 'package:basement_music/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rxdart/rxdart.dart';

import 'cacher_event.dart';
import 'caching_state.dart';

final cacher = Cacher();

class Cacher {
  final updateSubject = PublishSubject<CacherEvent>();

  Future<void> startCaching(String trackId) async {
    updateSubject.add(CacherEvent(CachingState.startCaching, trackId));

    try {
      await DefaultCacheManager().downloadFile(trackPlayback(trackId), key: trackId);

      cachedTracks.add(trackId);
      updateSubject.add(CacherEvent(CachingState.finishCaching, trackId));
    } catch (e) {
      debugPrint('Couldn\'t cache file: $e');

      updateSubject.add(CacherEvent(CachingState.errorCaching, trackId));
    }
  }

  bool isCached(String trackId) {
    return cachedTracks.contains(trackId);
  }

  Future<FileInfo?> getFile(String trackId) async {
    return await DefaultCacheManager().getFileFromCache(trackId);
  }

  Future<void> fetchAllCachedIds() async {
    for (var track in tracks) {
      if (await _isInCach(track.id)) {
        cachedTracks.add(track.id);
      }
    }
  }

  Future<bool> _isInCach(String trackId) async {
    return (await DefaultCacheManager().getFileFromCache(trackId)) != null;
  }
}
