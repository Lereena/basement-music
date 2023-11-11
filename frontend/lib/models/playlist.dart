import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'track.dart';

part 'playlist.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Playlist extends Equatable {
  final String id;
  final String title;
  final List<Track> tracks;

  const Playlist({
    required this.id,
    required this.title,
    required this.tracks,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

  @override
  List<Object> get props => [id, title, tracks];

  Playlist copyWith({
    String? title,
    List<Track>? tracks,
  }) {
    return Playlist(
      id: id,
      title: title ?? this.title,
      tracks: tracks ?? this.tracks,
    );
  }

  factory Playlist.empty() {
    return const Playlist(id: '', title: '', tracks: []);
  }

  factory Playlist.anonymous(List<Track> tracks) {
    return Playlist(id: const Uuid().v1(), title: '', tracks: tracks);
  }
}
