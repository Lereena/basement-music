final _splitRegexp = RegExp('[-−‐‑‒–—―]');

(String? artist, String title) getArtistAndTitle(String? filename) {
  if (filename == null) return (null, '');

  final extensionDotIndex = filename.lastIndexOf('.');
  final nameWithoutExtension = extensionDotIndex == -1 ? filename : filename.substring(0, extensionDotIndex);

  final splitName = nameWithoutExtension.split(_splitRegexp);

  if (splitName.length < 2) {
    return (null, splitName[0].trim());
  }

  return (
    nameWithoutExtension.substring(0, nameWithoutExtension.length - splitName.last.length - 1).trim(),
    splitName.last.trim(),
  );
}

String constructFilename(String artist, String title) => '$artist - $title.mp3';
