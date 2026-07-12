import 'package:basement_music/bloc/cacher_cubit/cacher_cubit.dart';
import 'package:basement_music/bloc/favourites_cubit/favourites_cubit.dart';
import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/widgets/buttons/more_button.dart';
import 'package:basement_music/widgets/controls/pause_button.dart';
import 'package:basement_music/widgets/controls/play_button.dart';
import 'package:basement_music/widgets/cover.dart';
import 'package:basement_music/widgets/cover_overlay.dart';
import 'package:basement_music/widgets/keep_alive.dart';
import 'package:basement_music/widgets/track_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackCard extends StatelessWidget {
  final Track track;
  final bool active;
  final Playlist? containingPlaylist;
  final Playlist? openedPlaylist;

  const TrackCard({super.key, required this.track, this.active = true, this.containingPlaylist, this.openedPlaylist});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerCubit>();

    return KeepAliveWrapper(
      child: BlocBuilder<CacherCubit, CacherState>(
        builder: (context, cacherState) {
          final isCaching = cacherState.isCaching([track.id]);
          final isCached = cacherState.isCached([track.id]);
          final canBePlayed = active || isCached;

        return IgnorePointer(
          ignoring: !canBePlayed,
          child: Opacity(
            opacity: canBePlayed ? 1 : 0.5,
            child: BlocBuilder<PlayerCubit, PlayerState>(
              builder: (context, playerState) {
                final isCurrent = playerCubit.state.currentTrack == track;
                final isFavouritesList = openedPlaylist?.id == 'favourites';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: isCurrent ? context.semanticColors.nowPlayingHighlight : null,
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.smAll,
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Cover(
                                cover: track.cover,
                                size: 44,
                                version: track.updatedAt,
                                overlay: CoverOverlay(isCaching: isCaching, isCached: isCached),
                              ),
                              // Circular scrim keeps the control legible on any
                              // artwork, light or dark.
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withValues(alpha: 0.45),
                                ),
                                child: isCurrent && playerState.isPlay
                                    ? const PauseButton(size: 20, color: Colors.white)
                                    : PlayButton(
                                        track: track,
                                        state: playerState,
                                        openedPlaylist: openedPlaylist,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultTextStyle.merge(
                              style: context.textTheme.titleMedium!.copyWith(
                                color: isCurrent ? context.colorScheme.primary : null,
                              ),
                              child: TrackName(track: track, moving: isCurrent, fontSize: 16),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              track.artist,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        track.durationStr,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
                      ),
                      // On the Favourites list the heart is redundant — removal
                      // lives in the ⋮ menu instead.
                      if (!isFavouritesList)
                        BlocBuilder<FavouritesCubit, FavouritesState>(
                          buildWhen: (previous, current) {
                            bool favOf(FavouritesState s) => s.maybeWhen(
                              loaded: (tracks) => tracks.any((t) => t.id == track.id),
                              orElse: () => false,
                            );

                            // Ignore transient loadInProgress/error so cards don't flash; only react when this track's status changes.
                            final isResolved = current.maybeWhen(loaded: (_) => true, orElse: () => false);
                            return isResolved && favOf(previous) != favOf(current);
                          },
                          builder: (context, _) {
                            final isFav = context.read<FavouritesCubit>().isFavourite(track.id);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? context.semanticColors.favourite : null,
                                size: 20,
                              ),
                              onPressed: () => context.read<FavouritesCubit>().toggleFavourite(track.id),
                            );
                          },
                        ),
                      MoreButton(
                        track: track,
                        playlist: containingPlaylist,
                        showRemoveFavourite: isFavouritesList,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      ),
    );
  }
}
