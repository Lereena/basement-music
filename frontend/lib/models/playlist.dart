import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'track.dart';

class Playlist extends Equatable {
  final String id;
  final String title;
  final List<Track> tracks;

  const Playlist({
    required this.id,
    required this.title,
    required this.tracks,
  });

  @override
  List<Object> get props => [id];

  factory Playlist.empty() {
    return const Playlist(id: '', title: '', tracks: []);
  }

  factory Playlist.anonymous(List<Track> tracks) {
    return Playlist(id: const Uuid().v1(), title: '', tracks: tracks);
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['Id'],
      title: json['Title'],
      tracks: List.castFrom<dynamic, Track>(json['Tracks'].map((e) => Track.fromJson(e)).toList()),
    );
  }
}
