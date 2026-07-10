import 'package:basement_music/bloc/track_album_setter_cubit/track_album_setter_cubit.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
import 'package:basement_music/widgets/icons/error_icon.dart';
import 'package:basement_music/widgets/icons/success_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetAlbumDialog extends StatelessWidget {
  final String trackId;

  const SetAlbumDialog._({required this.trackId});

  static Future<void> show({required BuildContext context, required String trackId}) => showDialog(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) =>
          TrackAlbumSetterCubit(albumsRepository: context.read<AlbumsRepository>(), trackId: trackId)..loadAlbums(),
      child: SetAlbumDialog._(trackId: trackId),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: BlocBuilder<TrackAlbumSetterCubit, TrackAlbumSetterState>(
        builder: (context, state) => state.when(
          loading: () => const CircularProgressIndicator(),
          selectInProgress: (albums) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: Text('Choose album', style: Theme.of(context).textTheme.headlineSmall),
              ),
              const Divider(height: 1.5, indent: 8, endIndent: 8),
              if (albums.isEmpty)
                const Padding(padding: EdgeInsets.all(16), child: Text('No albums yet'))
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: albums.length,
                    separatorBuilder: (context, _) => const Divider(height: 1.5, indent: 8, endIndent: 8),
                    itemBuilder: (context, index) => SimpleDialogOption(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Text(albums[index].title),
                      onPressed: () => context.read<TrackAlbumSetterCubit>().selectAlbum(albums[index].id),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
          success: () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [SuccessIcon(), SizedBox(height: 20), Text('Track added to album')],
          ),
          error: () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [ErrorIcon(), const SizedBox(height: 20), const Text('Error setting album')],
          ),
        ),
      ),
    );
  }
}
