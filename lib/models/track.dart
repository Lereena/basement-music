import 'package:equatable/equatable.dart';

class Track extends Equatable {
  final String id;
  final String url;
  final String title;
  final String artist;
  final int duration;
  final String cover;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    this.url = '',
    this.duration = 111,
    this.cover = 'assets/cover_placeholder.png',
  });

  @override
  List<Object> get props => [id];

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['Id'] as String,
      url: json['Url'] as String,
      title: json['Title'] as String,
      artist: json['Artist'] as String,
      duration: json['Duration'] as int,
      // cover: json['Cover'] as String,
    );
  }

  factory Track.empty() => Track(
        artist: '',
        title: 'No current track',
        id: '',
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
