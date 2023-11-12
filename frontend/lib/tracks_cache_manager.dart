import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TracksCacheManager extends CacheManager {
  TracksCacheManager({required String cacheKey}) : super(Config(cacheKey));
}
