part of 'artist_cubit.dart';

@immutable
sealed class ArtistState {}

final class ArtistInitial extends ArtistState {}

final class ArtistLoadInProgress extends ArtistState {}

final class ArtistLoaded extends ArtistState {
  final Artist artist;

  ArtistLoaded({required this.artist});
}

final class ArtistLoadedEmpty extends ArtistState {
  final String name;

  ArtistLoadedEmpty({required this.name});
}

final class ArtistError extends ArtistState {}
