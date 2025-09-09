import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/track_to_playlist_adder_bloc/track_to_playlist_adder_bloc.dart';
import '../../repositories/repositories.dart';
import '../icons/error_icon.dart';
import '../icons/success_icon.dart';
import 'dialog.dart';

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
    return CustomDialog(
      width: SizerUtil.deviceType == DeviceType.mobile ? 80.w : 40.w,
      height: 50.h,
      child: BlocBuilder<TrackToPlaylistAdderBloc, TrackToPlaylistAdderState>(
        builder: (context, state) {
          if (state is TrackToPlaylistAdderPlaylistSelectInProgress) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Choose playlist',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const Divider(
                  height: 1.5,
                  indent: 10,
                  endIndent: 10,
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.playlists.length,
                    separatorBuilder: (context, _) => const Divider(
                      height: 1.5,
                      indent: 10,
                      endIndent: 10,
                    ),
                    itemBuilder: (context, index) => SimpleDialogOption(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: Text(state.playlists[index].title),
                      onPressed: () =>
                          context.read<TrackToPlaylistAdderBloc>().add(
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
              children: [
                ErrorIcon(),
                const SizedBox(height: 20),
                const Text('Error adding track to playlist'),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}
