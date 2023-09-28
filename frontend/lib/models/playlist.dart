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
      id: json['Id'] as String,
      title: json['Title'] as String,
      tracks: List.castFrom<dynamic, Track>(
        json['Tracks']
            .map((e) => Track.fromJson(e as Map<String, dynamic>))
            .toList() as List<dynamic>,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'tracks': tracks.map((e) => e.toMap()).toList(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as String,
      title: map['title'] as String,
      tracks: (map['tracks'] as List<dynamic>)
          .map<Track>(
            (x) => Track.fromMap(x as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
