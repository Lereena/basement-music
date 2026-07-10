// Resolves a server image path to an absolute URL and appends a version query
// (?v=<updatedAt>) so the URL changes when the underlying bytes change. The
// stable path alone would be served stale from Flutter's ImageCache and the
// browser HTTP cache on web; the version busts both when the row is updated.
String? imageUrlWithVersion(String? path, String baseUrl, String? updatedAt) {
  if (path == null) return null;
  final absolute = path.startsWith('http') ? path : '$baseUrl$path';
  if (updatedAt == null || updatedAt.isEmpty) return absolute;
  final separator = absolute.contains('?') ? '&' : '?';
  return '$absolute${separator}v=${Uri.encodeComponent(updatedAt)}';
}
