class Track {
  final String url;
  final String title;
  final String artist;
  final String cover;

  Track({
    required this.url,
    required this.title,
    required this.artist,
    this.cover = '',
  });
}
