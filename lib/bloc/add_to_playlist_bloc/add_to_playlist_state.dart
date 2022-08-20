part of 'add_to_playlist_bloc.dart';

abstract class AddToPlaylistState extends Equatable {
  const AddToPlaylistState();

  @override
  List<Object> get props => [];
}

class AddToPlaylistInitial extends AddToPlaylistState {}

class ChoosePlaylist extends AddToPlaylistState {
  final List<Playlist> playlists;

  ChoosePlaylist(this.playlists);
}

class Loading extends AddToPlaylistState {}

class Added extends AddToPlaylistState {}

class Error extends AddToPlaylistState {}
