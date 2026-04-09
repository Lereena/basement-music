import 'dart:math';

import 'package:dio/dio.dart';

import '../logger.dart';
import '../models/track.dart';

/// Names must match at least this similarity (0–1) after normalization, or be identical.
const double _kTheAudioDbNameSimilarityThreshold = 0.88;

/// [TheAudioDB](https://www.theaudiodb.com/free_music_api) free v1 API (key in URL).
class TheAudioDbRepository {
  TheAudioDbRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  final Dio _dio;

  static const _searchTrackPath = 'https://www.theaudiodb.com/api/v1/json/123/searchtrack.php';
  static const _lookupAlbumPath = 'https://www.theaudiodb.com/api/v1/json/123/album.php';

  /// In-memory cache: normalized `'$artist\x00$title'` -> resolved artwork or no match.
  final Map<String, _ResolvedArtwork?> _artworkByArtistTitle = {};

  /// `idAlbum` -> album thumb base URL or null after lookup.
  final Map<String, String?> _albumThumbBaseByAlbumId = {};

  /// Returns a sized image URL when the API result’s artist and track are approximately
  /// equal to [track] (case-insensitive, collapsed whitespace, optional fuzzy match).
  /// If [track.artist] lists several names separated by commas, only the first segment
  /// is used for the search and for comparing against `strArtist`.
  /// Prefers track art; if missing, uses the track’s album cover from a follow-up lookup.
  /// Uses `/small` for [TheAudioDbImageSize.small]. For [TheAudioDbImageSize.medium], album
  /// art uses `/medium`; track art uses the original URL (no `/medium` on track CDN).
  Future<String?> resolveSizedCoverUrl(
    Track track, {
    required TheAudioDbImageSize size,
  }) async {
    if (track.id.isEmpty) return null;

    final queryArtist = track.artist.trim();
    final queryTitle = track.title.trim();
    if (queryTitle.isEmpty || queryArtist.isEmpty) return null;

    final cacheKey = '${_normalizeMusicLabel(queryArtist)}\x00${_normalizeMusicLabel(queryTitle)}';
    final resolved = await _resolveArtwork(
      queryArtist,
      queryTitle,
      cacheKey,
    );
    if (resolved == null) return null;

    if (size == TheAudioDbImageSize.small) {
      return '${resolved.baseUrl}/small';
    }
    if (resolved.kind == _TheAudioDbArtKind.album) {
      return '${resolved.baseUrl}/medium';
    }
    return resolved.baseUrl;
  }

  Future<_ResolvedArtwork?> _resolveArtwork(
    String queryArtist,
    String queryTitle,
    String cacheKey,
  ) async {
    if (_artworkByArtistTitle.containsKey(cacheKey)) {
      return _artworkByArtistTitle[cacheKey];
    }

    try {
      final searchArtist = _primaryArtistSegment(queryArtist);
      if (searchArtist.isEmpty) {
        _artworkByArtistTitle[cacheKey] = null;
        return null;
      }

      final response = await _dio.get<Map<String, dynamic>>(
        _searchTrackPath,
        queryParameters: {
          's': searchArtist,
          't': queryTitle,
        },
      );

      final data = response.data;
      if (data == null) {
        _artworkByArtistTitle[cacheKey] = null;
        return null;
      }

      final rawList = data['track'];
      if (rawList is! List || rawList.isEmpty) {
        _artworkByArtistTitle[cacheKey] = null;
        return null;
      }

      final first = rawList.first;
      if (first is! Map<String, dynamic>) {
        _artworkByArtistTitle[cacheKey] = null;
        return null;
      }

      final apiArtist = (first['strArtist'] as String?)?.trim() ?? '';
      final apiTrack = (first['strTrack'] as String?)?.trim() ?? '';

      final artistOk = _approximatelyEqualStrings(apiArtist, searchArtist);
      final trackOk = _approximatelyEqualStrings(apiTrack, queryTitle);
      if (!artistOk || !trackOk) {
        _artworkByArtistTitle[cacheKey] = null;
        return null;
      }

      final trackThumb = (first['strTrackThumb'] as String?)?.trim() ?? '';
      if (trackThumb.isNotEmpty) {
        final result = _ResolvedArtwork(
          baseUrl: trackThumb,
          kind: _TheAudioDbArtKind.track,
        );
        _artworkByArtistTitle[cacheKey] = result;
        return result;
      }

      final idAlbum = _parseIdAlbum(first['idAlbum']);
      if (idAlbum == null || idAlbum.isEmpty) {
        _artworkByArtistTitle[cacheKey] = null;
        return null;
      }

      final albumBase = await _lookupAlbumThumbBase(idAlbum);
      if (albumBase == null || albumBase.isEmpty) {
        _artworkByArtistTitle[cacheKey] = null;
        return null;
      }

      final result = _ResolvedArtwork(
        baseUrl: albumBase,
        kind: _TheAudioDbArtKind.album,
      );
      _artworkByArtistTitle[cacheKey] = result;
      return result;
    } on DioException catch (e, s) {
      logger.e(
        'TheAudioDB searchtrack request failed',
        error: e,
        stackTrace: s,
      );
      _artworkByArtistTitle[cacheKey] = null;
      return null;
    } catch (e, s) {
      logger.e('TheAudioDB searchtrack failed', error: e, stackTrace: s);
      _artworkByArtistTitle[cacheKey] = null;
      return null;
    }
  }

  Future<String?> _lookupAlbumThumbBase(String idAlbum) async {
    if (_albumThumbBaseByAlbumId.containsKey(idAlbum)) {
      return _albumThumbBaseByAlbumId[idAlbum];
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _lookupAlbumPath,
        queryParameters: {'m': idAlbum},
      );

      final data = response.data;
      if (data == null) {
        _albumThumbBaseByAlbumId[idAlbum] = null;
        return null;
      }

      final rawList = data['album'];
      if (rawList is! List || rawList.isEmpty) {
        _albumThumbBaseByAlbumId[idAlbum] = null;
        return null;
      }

      final row = rawList.first;
      if (row is! Map<String, dynamic>) {
        _albumThumbBaseByAlbumId[idAlbum] = null;
        return null;
      }

      final hq = (row['strAlbumThumbHQ'] as String?)?.trim() ?? '';
      final thumb = (row['strAlbumThumb'] as String?)?.trim() ?? '';
      final picked = hq.isNotEmpty ? hq : thumb;
      if (picked.isEmpty) {
        _albumThumbBaseByAlbumId[idAlbum] = null;
        return null;
      }

      _albumThumbBaseByAlbumId[idAlbum] = picked;
      return picked;
    } on DioException catch (e, s) {
      logger.e(
        'TheAudioDB album lookup failed',
        error: e,
        stackTrace: s,
      );
      _albumThumbBaseByAlbumId[idAlbum] = null;
      return null;
    } catch (e, s) {
      logger.e('TheAudioDB album lookup failed', error: e, stackTrace: s);
      _albumThumbBaseByAlbumId[idAlbum] = null;
      return null;
    }
  }
}

enum TheAudioDbImageSize {
  small,
  medium,
}

enum _TheAudioDbArtKind {
  track,
  album,
}

class _ResolvedArtwork {
  const _ResolvedArtwork({
    required this.baseUrl,
    required this.kind,
  });

  final String baseUrl;
  final _TheAudioDbArtKind kind;
}

/// First non-empty segment when [artist] is split on commas (e.g. featured / collaborations).
String _primaryArtistSegment(String artist) {
  for (final part in artist.split(',')) {
    final t = part.trim();
    if (t.isNotEmpty) return t;
  }

  return artist.trim();
}

String? _parseIdAlbum(Object? raw) {
  if (raw == null) return null;

  if (raw is String) {
    final t = raw.trim();
    return t.isEmpty ? null : t;
  }

  if (raw is int) return raw.toString();

  return null;
}

String _normalizeMusicLabel(String value) {
  final lower = value.trim().toLowerCase();

  if (lower.isEmpty) return '';

  final out = StringBuffer();
  var pendingSpace = false;

  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    final isSpace = ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r' || ch == '\f' || ch == '\u00a0';

    if (isSpace) {
      pendingSpace = true;
    } else {
      if (pendingSpace && out.isNotEmpty) {
        out.write(' ');
      }

      pendingSpace = false;
      out.write(ch);
    }
  }
  return out.toString();
}

bool _approximatelyEqualStrings(String a, String b) {
  final na = _normalizeMusicLabel(a);
  final nb = _normalizeMusicLabel(b);

  if (na.isEmpty || nb.isEmpty) return false;

  if (na == nb) return true;

  return _stringSimilarityRatio(na, nb) >= _kTheAudioDbNameSimilarityThreshold;
}

double _stringSimilarityRatio(String a, String b) {
  if (a == b) return 1;
  final maxLen = max(a.length, b.length);
  if (maxLen == 0) return 1;
  final distance = _levenshteinDistance(a, b);
  return 1 - distance / maxLen;
}

int _levenshteinDistance(String a, String b) {
  final m = a.length;
  final n = b.length;

  if (m == 0) return n;
  if (n == 0) return m;

  var previous = List<int>.generate(n + 1, (j) => j);
  var current = List<int>.filled(n + 1, 0);

  for (var i = 1; i <= m; i++) {
    current[0] = i;

    for (var j = 1; j <= n; j++) {
      final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;

      current[j] = min(
        current[j - 1] + 1,
        min(previous[j] + 1, previous[j - 1] + cost),
      );
    }

    final swap = previous;
    previous = current;
    current = swap;
  }

  return previous[n];
}
