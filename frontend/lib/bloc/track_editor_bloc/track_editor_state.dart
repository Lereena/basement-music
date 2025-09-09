part of 'track_editor_bloc.dart';

@immutable
sealed class TrackEditorState extends Equatable {
  const TrackEditorState();

  @override
  List<Object> get props => [];
}

final class TrackEditorInitial extends TrackEditorState {}

final class TrackEditorLoadInProgress extends TrackEditorState {}

final class TrackEditorSuccess extends TrackEditorState {}

final class TrackEditorError extends TrackEditorState {}
