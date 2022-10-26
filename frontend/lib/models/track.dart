import 'package:basement_music/utils/time.dart';
import 'package:equatable/equatable.dart';

class Track extends Equatable {
  final String id;
  final String url;
  final String title;
  final String artist;
  final int duration;
  final String cover;

  const Track({
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

  factory Track.empty() => const Track(
        artist: '',
        title: 'No current track',
        id: '',
      );

  String get durationStr => durationString(duration);

  Track copyWith({
    String? title,
    String? artist,
    String? cover,
  }) {
    return Track(
      id: id,
      url: url,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration,
      cover: cover ?? this.cover,
    );
  }
}
