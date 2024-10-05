part of 'artists_cubit.dart';

@immutable
sealed class ArtistsState {}

final class ArtistsInitial extends ArtistsState {}

final class ArtistsLoading extends ArtistsState {}

final class ArtistsEmpty extends ArtistsState {}

final class ArtistsLoaded extends ArtistsState {
  final List<Artist> artists;

  ArtistsLoaded({required this.artists});
}

final class ArtistsError extends ArtistsState {
  final String message;

  ArtistsError({required this.message});
}
