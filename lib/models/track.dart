class Track {
  final String url;
  final String title;
  final String artist;
  final int duration;
  final String cover;

  Track({
    required this.url,
    required this.title,
    required this.artist,
    this.duration = 111,
    this.cover = '',
  });

  factory Track.empty() => Track(
        artist: '',
        title: 'No current track',
        url: '',
      );

  String get durationStr {
    var hours = duration ~/ (60 * 60);
    var minutes = duration % (60 * 60) ~/ 60;
    var seconds = duration % (60 * 60) % 60;

    return "${_timeStr(hours)}${_timeStr(minutes)}:${_timeStr(seconds)}";
  }

  String _timeStr(int number) {
    return number > 0
        ? number < 10
            ? '0$number'
            : '$number'
        : '';
  }
}
