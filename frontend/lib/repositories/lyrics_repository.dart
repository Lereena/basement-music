import 'package:basement_music/models/lyrics.dart';
import 'package:basement_music/models/track.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Talks to the public lrclib.net API. Uses its own [Dio] instance: the app
/// dio attaches Firebase auth tokens, which must not leak to a third-party
/// host.
class LyricsRepository {
  LyricsRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://lrclib.net',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
              // Browsers forbid setting User-Agent; only send it on native.
              headers: kIsWeb ? null : {'User-Agent': 'BasementMusic/2.0.0 (https://basement.madetara.dev)'},
            ),
          );

  final Dio _dio;

  // Keyed by track id; a null value means "looked up, nothing found" so 404s
  // are not refetched. Transport errors are not cached (rethrown before put).
  final _cache = <String, Lyrics?>{};

  Future<Lyrics?> getLyrics(Track track) async {
    if (_cache.containsKey(track.id)) return _cache[track.id];

    final lyrics = await _fetch(track);
    _cache[track.id] = lyrics;
    return lyrics;
  }

  Future<Lyrics?> _fetch(Track track) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/get',
        queryParameters: {
          'artist_name': track.artist,
          'track_name': track.title,
          'duration': track.duration,
        },
      );

      return Lyrics.fromJson(response.data!);
    } on DioException catch (e) {
      // /api/get matches duration only within ±2s and the app's track duration
      // can be a placeholder, so fall back to search on a miss.
      if (e.response?.statusCode == 404) return _search(track);
      rethrow;
    }
  }

  Future<Lyrics?> _search(Track track) async {
    final response = await _dio.get<List<dynamic>>(
      '/api/search',
      queryParameters: {'track_name': track.title, 'artist_name': track.artist},
    );

    final results = (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(Lyrics.fromJson)
        .where((lyrics) => !lyrics.isEmpty)
        .toList();
    if (results.isEmpty) return null;

    int score(Lyrics lyrics) {
      var result = 0;
      final duration = lyrics.duration;
      if (duration != null && (duration - track.duration).abs() <= 3) result += 2;
      if (lyrics.hasSynced) result += 1;
      return result;
    }

    results.sort((a, b) => score(b).compareTo(score(a)));
    return results.first;
  }
}
