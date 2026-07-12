import 'package:basement_music/bloc/cacher_cubit/cacher_cubit.dart';
import 'package:basement_music/bloc/favourites_cubit/favourites_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/widgets/dialogs/add_to_playlist_dialog.dart';
import 'package:basement_music/widgets/dialogs/remove_from_playlist_dialog.dart';
import 'package:basement_music/widgets/dialogs/set_album_dialog.dart';
import 'package:basement_music/widgets/dialogs/set_track_artists_dialog.dart';
import 'package:basement_music/widgets/edit_track.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreButton extends StatelessWidget {
  final Track track;
  final Playlist? playlist;

  /// When true, offers a "Remove from Favourites" action (used on the
  /// Favourites list where the inline heart button is hidden).
  final bool showRemoveFavourite;

  const MoreButton({super.key, required this.track, this.playlist, this.showRemoveFavourite = false});

  @override
  Widget build(BuildContext context) {
    final cacherCubit = context.read<CacherCubit>();

    return InkWell(
      child: const Icon(Icons.more_vert),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            children: [
              _MenuOption(
                icon: Icons.edit_outlined,
                label: 'Edit track info',
                onPressed: () {
                  Navigator.pop(context);
                  EditTrack.show(context: context, track: track);
                },
              ),
              _MenuOption(
                icon: Icons.playlist_add,
                label: 'Add to playlist',
                onPressed: () {
                  Navigator.pop(context);
                  AddToPlaylistDialog.show(context: context, trackId: track.id);
                },
              ),
              _MenuOption(
                icon: Icons.person_outline,
                label: 'Change artist',
                onPressed: () {
                  Navigator.pop(context);
                  SetTrackArtistsDialog.show(context: context, track: track);
                },
              ),
              _MenuOption(
                icon: Icons.album_outlined,
                label: 'Set album',
                onPressed: () {
                  Navigator.pop(context);
                  SetAlbumDialog.show(context: context, trackId: track.id);
                },
              ),
              if (showRemoveFavourite)
                _MenuOption(
                  icon: Icons.favorite_border,
                  label: 'Remove from Favourites',
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<FavouritesCubit>().toggleFavourite(track.id);
                  },
                ),
              if (playlist != null)
                _MenuOption(
                  icon: Icons.playlist_remove,
                  label: 'Remove from playlist',
                  onPressed: () {
                    Navigator.pop(context);
                    RemoveFromPlaylistDialog.show(context: context, track: track, playlist: playlist!);
                  },
                ),
              if (!kIsWeb && !cacherCubit.state.cached.contains(track.id))
                _MenuOption(
                  icon: Icons.download_outlined,
                  label: 'Cache track',
                  onPressed: () {
                    cacherCubit.cacheTrackIds([track.id]);
                    Navigator.pop(context);
                  },
                ),
              if (!kIsWeb && cacherCubit.state.cached.contains(track.id))
                _MenuOption(
                  icon: Icons.delete_outline,
                  label: 'Remove from cache',
                  onPressed: () {
                    cacherCubit.removeTrackIds([track.id]);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _MenuOption({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.md),
          Text(label, style: context.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
