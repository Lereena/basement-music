part of 'track_editor_bloc.dart';

abstract class TrackEditorEvent extends Equatable {
  const TrackEditorEvent();

  @override
  List<Object> get props => [];
}

class TrackEditorEdited extends TrackEditorEvent {
  final String trackId;
  final String title;
  final String artist;
  final String cover;

  const TrackEditorEdited(
    this.trackId,
    this.title,
    this.artist,
    this.cover,
  );
}
