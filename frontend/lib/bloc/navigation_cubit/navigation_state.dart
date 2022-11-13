part of 'navigation_cubit.dart';

@immutable
abstract class NavigationState {}

class NavigationHome extends NavigationState {}

class NavigationLibrary extends NavigationState {}

class NavigationSearch extends NavigationState {}

class NavigationArtistsList extends NavigationState {}

class NavigationSettings extends NavigationState {}

class NavigationArtist extends NavigationState {
  final String artistId;

  NavigationArtist(this.artistId);
}

class NavigationAlbum extends NavigationState {
  final String albumId;

  NavigationAlbum(this.albumId);
}

class NavigationPlaylist extends NavigationState {
  final Playlist playlist;

  NavigationPlaylist(this.playlist);
}

class NavigationUploadTrack extends NavigationState {}
