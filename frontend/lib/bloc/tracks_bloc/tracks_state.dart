part of 'tracks_bloc.dart';

@immutable
class TracksState {
  final List<Track> tracks;

  const TracksState(this.tracks);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tracks': json.encode(tracks.map((e) => e.toJson()).toList()),
    };
  }

  factory TracksState.fromMap(Map<String, dynamic> map) {
    return TracksState(
      (json.decode(map['tracks'] as String) as List<dynamic>)
          .map<Track>(
            (e) => Track.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TracksState.fromJson(String source) =>
      TracksState.fromMap(json.decode(source) as Map<String, dynamic>);
}

final class TracksEmptyState extends TracksState {
  TracksEmptyState() : super([]);
}

final class TracksLoadInProgress extends TracksState {
  TracksLoadInProgress() : super([]);
}

final class TracksLoadSuccess extends TracksState {
  const TracksLoadSuccess(super.tracks);
}

final class TracksError extends TracksState {
  TracksError() : super([]);
}
