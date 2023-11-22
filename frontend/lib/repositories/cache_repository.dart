import 'package:hive/hive.dart';

import '../app_config.dart';
import '../tracks_cache_manager.dart';

const _cacheKey = 'tracks';

class CacheRepository {
  final AppConfig _appConfig;

  final Box<String> _cachedBox;

  CacheRepository(this._appConfig, this._cachedBox);

  final _cacheManager = TracksCacheManager(cacheKey: _cacheKey);

  Set<String> get items => _cachedBox.values.toSet();

  Future<void> cacheTrack(String trackId) async {
    await _cacheManager.downloadFile(
      '${_appConfig.baseUrl}/api/track/$trackId',
      key: trackId,
    );

    _cachedBox.put(trackId, trackId);
  }

  Future<void> removeOneTrackFromCache(String trackId) async {
    await _cacheManager.removeFile(trackId);

    _cachedBox.delete(trackId);
  }
}
