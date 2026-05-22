import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:basement_music/bloc/track_from_playlist_remover_bloc/track_from_playlist_remover_bloc.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/widgets/icons/error_icon.dart';
import 'package:basement_music/widgets/icons/success_icon.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';

class RemoveFromPlaylistDialog extends StatelessWidget {
  final Track track;
  final Playlist playlist;

  const RemoveFromPlaylistDialog._({
    required this.track,
    required this.playlist,
  });

  static Future<void> show({
    required BuildContext context,
    required Track track,
    required Playlist playlist,
  }) =>
      showDialog(
        context: context,
        builder: (_) => BlocProvider(
          create: (_) => TrackFromPlaylistRemoverBloc(
            tracksRepository: context.read<TracksRepository>(),
            playlistsRepository: context.read<PlaylistsRepository>(),
            trackId: track.id,
            playlistId: playlist.id,
          ),
          child: RemoveFromPlaylistDialog._(track: track, playlist: playlist),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseDialog(
      child: BlocBuilder<TrackFromPlaylistRemoverBloc, TrackFromPlaylistRemoverState>(
        builder: (context, state) {
          if (state is RemoveFromPlaylistInitial) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Do you want to remove ',
                    children: [
                      TextSpan(
                        text: track.title,
                        style: const TextStyle(decoration: TextDecoration.underline),
                      ),
                      const TextSpan(text: ' from '),
                      TextSpan(
                        text: '${playlist.title} ',
                        style: const TextStyle(decoration: TextDecoration.underline),
                      ),
                      const TextSpan(text: 'playlist?'),
                    ],
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<TrackFromPlaylistRemoverBloc>().add(
                        TrackFromPlaylistRemoverConfirmed(
                          track.id,
                          playlist.id,
                        ),
                      ),
                  child: const Text('Remove'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            );
          }

          if (state is TrackFromPlaylistRemoverLoadingInProgress) {
            return const CircularProgressIndicator();
          }

          if (state is TrackFromPlaylistRemoverSuccess) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SuccessIcon(),
                const SizedBox(height: 20),
                const Text('Track is successfully removed from playlist'),
              ],
            );
          }

          if (state is TrackFromPlaylistRemoverError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ErrorIcon(),
                const SizedBox(height: 20),
                const Text('Error removing track from playlist'),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}
