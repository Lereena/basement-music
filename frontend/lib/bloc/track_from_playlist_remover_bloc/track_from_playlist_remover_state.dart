part of 'track_from_playlist_remover_bloc.dart';

@immutable
sealed class TrackFromPlaylistRemoverState {}

final class RemoveFromPlaylistInitial extends TrackFromPlaylistRemoverState {}

final class TrackFromPlaylistRemoverLoadingInProgress
    extends TrackFromPlaylistRemoverState {}

final class TrackFromPlaylistRemoverSuccess
    extends TrackFromPlaylistRemoverState {}

final class TrackFromPlaylistRemoverError
    extends TrackFromPlaylistRemoverState {}
