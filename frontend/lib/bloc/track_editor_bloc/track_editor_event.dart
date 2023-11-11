part of 'track_editor_bloc.dart';

@immutable
sealed class TrackEditorEvent extends Equatable {
  const TrackEditorEvent();

  @override
  List<Object> get props => [];
}

final class TrackEditorEdited extends TrackEditorEvent {
  final String trackId;
  final String title;
  final String artist;
  final String cover;

  const TrackEditorEdited({
    required this.trackId,
    required this.title,
    required this.artist,
    required this.cover,
  });
}
