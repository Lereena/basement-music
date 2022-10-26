part of 'edit_track_bloc.dart';

abstract class EditTrackEvent extends Equatable {
  const EditTrackEvent();

  @override
  List<Object> get props => [];
}

class GetInputEvent extends EditTrackEvent {}

class LoadingEvent extends EditTrackEvent {
  final String trackId;
  final String title;
  final String artist;
  final String cover;

  const LoadingEvent(
    this.trackId,
    this.title,
    this.artist,
    this.cover,
  );
}
