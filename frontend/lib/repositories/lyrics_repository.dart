import 'package:basement_music/models/lyrics.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/rest_client.dart';
import 'package:dio/dio.dart';

enum LyricsSource { file, server }

/// Lyrics are served by our own backend: reading embedded lyrics from the
/// track file, proxying lrclib.net search, and writing lyrics into the file.
class LyricsRepository {
  LyricsRepository(this._restClient, this._dio);

  final RestClient _restClient;
  final Dio _dio;

  // Keyed by '<trackId>/<source>'; a null value means "looked up, nothing
  // found" so 404s are not refetched. Transport errors are not cached.
  final _cache = <String, Lyrics?>{};

  String _key(String trackId, LyricsSource source) => '$trackId/${source.name}';

  /// Cached "does this source have lyrics" result, or null if not probed yet
  /// (e.g. the play-start warmup probe hasn't resolved).
  bool? cachedHasLyrics(String trackId, LyricsSource source) {
    final key = _key(trackId, source);
    if (!_cache.containsKey(key)) return null;
    return _cache[key] != null;
  }

  Future<Lyrics?> getLyrics(Track track, LyricsSource source) async {
    final key = _key(track.id, source);
    if (_cache.containsKey(key)) return _cache[key];

    final lyrics = await _fetch(track, source);
    _cache[key] = lyrics;
    return lyrics;
  }

  Future<Lyrics?> _fetch(Track track, LyricsSource source) async {
    final path = switch (source) {
      LyricsSource.file => '/api/track/${track.id}/lyrics/file',
      LyricsSource.server => '/api/track/${track.id}/lyrics/search',
    };

    // A miss (404) is an expected outcome here, not a transport error —
    // accept it via validateStatus so Dio doesn't throw/log it as one.
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      options: Options(validateStatus: (status) => status != null && (status < 400 || status == 404)),
    );
    if (response.statusCode == 404) return null;
    return Lyrics.fromJson(response.data!);
  }

  /// Writes lyrics into the track's file on the server. Returns the updated
  /// Track (hasLyrics=true). Evicts the file-source cache so the next file
  /// read reflects what was just written.
  Future<Track> saveLyrics(Track track, String lyricsText) async {
    final updated = await _restClient.saveLyrics(id: track.id, lyrics: lyricsText);
    _cache.remove(_key(track.id, LyricsSource.file));
    return updated;
  }
}
