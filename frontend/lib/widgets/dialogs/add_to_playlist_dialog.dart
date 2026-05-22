import 'package:basement_music/bloc/track_to_playlist_adder_cubit/track_to_playlist_adder_cubit.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
import 'package:basement_music/widgets/icons/error_icon.dart';
import 'package:basement_music/widgets/icons/success_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddToPlaylistDialog extends StatelessWidget {
  final String trackId;

  const AddToPlaylistDialog._({required this.trackId});

  static Future<void> show({required BuildContext context, required String trackId}) => showDialog(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => TrackToPlaylistAdderCubit(
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
      child: BlocBuilder<TrackToPlaylistAdderCubit, TrackToPlaylistAdderState>(
        builder: (context, state) => state.when(
          selectInProgress: (playlists) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: Text('Choose playlist', style: Theme.of(context).textTheme.headlineSmall),
              ),
              const Divider(height: 1.5, indent: 8, endIndent: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  separatorBuilder: (context, _) => const Divider(height: 1.5, indent: 8, endIndent: 8),
                  itemBuilder: (context, index) => SimpleDialogOption(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Text(playlists[index].title),
                    onPressed: () => context.read<TrackToPlaylistAdderCubit>().selectPlaylist(playlists[index].id),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          success: () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SuccessIcon(),
              const SizedBox(height: 20),
              const Text('Track is successfully added to playlist'),
            ],
          ),
          error: () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [ErrorIcon(), const SizedBox(height: 20), const Text('Error adding track to playlist')],
          ),
        ),
      ),
    );
  }
}
