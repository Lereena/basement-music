import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/track_to_playlist_adder_bloc/track_to_playlist_adder_bloc.dart';
import '../../repositories/repositories.dart';
import '../icons/error_icon.dart';
import '../icons/success_icon.dart';
import 'base_dialog.dart';

class AddToPlaylistDialog extends StatelessWidget {
  final String trackId;

  const AddToPlaylistDialog._({required this.trackId});

  static Future<void> show({
    required BuildContext context,
    required String trackId,
  }) =>
      showDialog(
        context: context,
        builder: (_) => BlocProvider(
          create: (_) => TrackToPlaylistAdderBloc(
            tracksRepository: context.read<TracksRepository>(),
            playlistsRepository: context.read<PlaylistsRepository>(),
            trackId: trackId,
          ),
          child: AddToPlaylistDialog._(trackId: trackId),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: BlocBuilder<TrackToPlaylistAdderBloc, TrackToPlaylistAdderState>(
        builder: (context, state) {
          if (state is TrackToPlaylistAdderPlaylistSelectInProgress) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  child: Text(
                    'Choose playlist',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const Divider(height: 1.5, indent: 8, endIndent: 8),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.playlists.length,
                    separatorBuilder: (context, _) => const Divider(height: 1.5, indent: 8, endIndent: 8),
                    itemBuilder: (context, index) => SimpleDialogOption(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Text(state.playlists[index].title),
                      onPressed: () => context.read<TrackToPlaylistAdderBloc>().add(
                            TrackToPlaylistAdderPlaylistSelected(
                              trackId,
                              state.playlists[index].id,
                            ),
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }

          if (state is TrackToPlaylistAdderLoad) {
            return const CircularProgressIndicator();
          }

          if (state is TrackToPlaylistAdderSuccess) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SuccessIcon(),
                const SizedBox(height: 20),
                const Text('Track is successfully added to playlist'),
              ],
            );
          }

          if (state is TrackToPlaylistAdderError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ErrorIcon(),
                const SizedBox(height: 20),
                const Text('Error adding track to playlist'),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
