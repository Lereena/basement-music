import 'dart:convert';
import 'dart:developer';

import 'package:basement_music/models/track.dart';
import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  final String id;
  final String title;
  final List<Track> tracksIds;

  Playlist({
    required this.id,
    required this.title,
    required this.tracksIds,
  });

  @override
  List<Object> get props => [id];

  factory Playlist.fromJson(Map<String, dynamic> json) {
    log(jsonDecode(json['Tracks']));
    return Playlist(
      id: json['Id'],
      title: json['Title'],
      tracksIds: jsonDecode(json['Tracks']).map((e) => Track.fromJson(e)),
    );
  }
}
