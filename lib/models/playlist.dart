import 'package:basement_music/models/track.dart';
import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  final String id;
  final String title;
  final List<Track> tracks;

  Playlist({
    required this.id,
    required this.title,
    required this.tracks,
  });

  @override
  List<Object> get props => [id];

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['Id'],
      title: json['Title'],
      tracks: List.castFrom<dynamic, Track>(json['Tracks'].map((e) => Track.fromJson(e)).toList()),
    );
  }
}
