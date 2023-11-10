import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../app_config.dart';

class CacheRepository {
  final AppConfig _appConfig;

  final Box<String> _cachedBox;

  CacheRepository(this._appConfig, this._cachedBox) {
    _items.addAll(_cachedBox.values);
  }

  final _items = <String>{};

  Set<String> get items => _items;

  Future<void> cacheTrack(String trackId) async {
    await DefaultCacheManager().downloadFile(
      '${_appConfig.baseUrl}/api/track/$trackId',
      key: trackId,
    );

    _items.add(trackId);
    _cachedBox.add(trackId);
  }

  Future<bool> validateCache() async {
    final cachedFilesCount = await _getCachedFilesCount();

    if (cachedFilesCount != _items.length) {
      await DefaultCacheManager().emptyCache();
      return false;
    }

    return true;
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
}
