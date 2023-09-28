import 'dart:convert';

import '../../models/track.dart';

class TracksState {
  final List<Track> tracks;

  TracksState(this.tracks);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tracks': json.encode(tracks.map((e) => e.toMap()).toList()),
    };
  }

  factory TracksState.fromMap(Map<String, dynamic> map) {
    return TracksState(
      (json.decode(map['tracks'] as String) as List<dynamic>)
          .map<Track>(
            (e) => Track.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TracksState.fromJson(String source) =>
      TracksState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class TracksEmptyState extends TracksState {
  TracksEmptyState() : super([]);
}

class TracksLoadingState extends TracksState {
  TracksLoadingState() : super([]);
}

class TracksLoadedState extends TracksState {
  TracksLoadedState(super.tracks);
}

class TracksErrorState extends TracksState {
  TracksErrorState() : super([]);
}
