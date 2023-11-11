part of 'track_to_playlist_adder_bloc.dart';

@immutable
sealed class TrackToPlaylistAdderEvent extends Equatable {
  const TrackToPlaylistAdderEvent();

  @override
  List<Object> get props => [];
}

final class TrackToPlaylistAdderPlaylistSelected
    extends TrackToPlaylistAdderEvent {
  final String trackId;
  final String playlistId;

  const TrackToPlaylistAdderPlaylistSelected(this.trackId, this.playlistId);
}
