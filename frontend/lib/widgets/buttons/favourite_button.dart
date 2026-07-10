import 'package:basement_music/bloc/favourites_cubit/favourites_cubit.dart';
import 'package:basement_music/models/favourite_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteButton extends StatelessWidget {
  final FavouriteType type;
  final String id;

  const FavouriteButton({super.key, required this.type, required this.id});

  bool _isFavourite(FavouritesCubit cubit) => switch (type) {
    FavouriteType.track => cubit.isFavourite(id),
    FavouriteType.playlist => cubit.isFavouritePlaylist(id),
    FavouriteType.artist => cubit.isFavouriteArtist(id),
    FavouriteType.album => cubit.isFavouriteAlbum(id),
  };

  Future<void> _toggle(FavouritesCubit cubit) => switch (type) {
    FavouriteType.track => cubit.toggleFavourite(id),
    FavouriteType.playlist => cubit.toggleFavouritePlaylist(id),
    FavouriteType.artist => cubit.toggleFavouriteArtist(id),
    FavouriteType.album => cubit.toggleFavouriteAlbum(id),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesCubit, FavouritesState>(
      builder: (context, _) {
        final cubit = context.read<FavouritesCubit>();
        final isFav = _isFavourite(cubit);
        return IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Theme.of(context).colorScheme.error : null,
          ),
          tooltip: isFav ? 'Remove from favourites' : 'Add to favourites',
          onPressed: () => _toggle(cubit),
        );
      },
    );
  }
}
