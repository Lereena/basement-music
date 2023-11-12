import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../app_config.dart';
import '../tracks_cache_manager.dart';

const _cacheKey = 'tracks';

class CacheRepository {
  final AppConfig _appConfig;

  final Box<String> _cachedBox;

  CacheRepository(this._appConfig, this._cachedBox) {
    _items.addAll(_cachedBox.values);
  }

  final _cacheManager = TracksCacheManager(cacheKey: _cacheKey);

  final _items = <String>{};

  Set<String> get items => _items;

  Future<void> cacheTrack(String trackId) async {
    await _cacheManager.downloadFile(
      '${_appConfig.baseUrl}/api/track/$trackId',
      key: trackId,
    );

    _items.add(trackId);
    _cachedBox.add(trackId);
  }

  Future<void> removeOneTrackFromCache(String trackId) async {
    await _cacheManager.removeFile(trackId);

    _items.remove(trackId);
    _cachedBox.delete(trackId);
  }

  Future<bool> validateCache() async {
    final cachedFilesCount = await _getCachedFilesCount();

    if (cachedFilesCount != _items.length) {
      await _cacheManager.emptyCache();
      _cachedBox.clear();
      return false;
    }

    return true;
  }

  Future<int> _getCachedFilesCount() async {
    final tempDir = await getTemporaryDirectory();
    final cacheDir = Directory('${tempDir.uri.path}$_cacheKey');

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
}
