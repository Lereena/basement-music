import 'package:basement_music/api.dart';
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

      updateSubject.add(CacherEvent(CachingState.finishCaching, trackId));
    } catch (e) {
      debugPrint('Couldn\'t cache file: $e');

      updateSubject.add(CacherEvent(CachingState.errorCaching, trackId));
    }
  }

  Future<bool> isCached(String trackId) async {
    return (await DefaultCacheManager().getFileFromCache(trackId)) != null;
  }
}
