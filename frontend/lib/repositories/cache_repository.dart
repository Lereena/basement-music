import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
    final url = '${_appConfig.baseUrl}/api/track/$trackId';

    final file = await _cacheManager.getSingleFile(url);

    await _cacheManager.putFile(
      url,
      file.readAsBytesSync(),
      maxAge: const Duration(days: 365 * 10),
      key: trackId,
      fileExtension: 'mp3',
    );

    _cachedBox.put(trackId, trackId);
  }

  Future<void> removeOneTrackFromCache(String trackId) async {
    await _cacheManager.removeFile(trackId);

    _cachedBox.delete(trackId);
  }

  Future<FileInfo?> retrieveTrack(String trackId) => _cacheManager.getFileFromCache(trackId);
}
