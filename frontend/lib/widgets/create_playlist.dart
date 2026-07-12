import 'package:basement_music/bloc/playlist_creation_cubit/playlist_creation_cubit.dart';
import 'package:basement_music/repositories/playlists_repository.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePlaylistDialog extends StatefulWidget {
  const CreatePlaylistDialog({super.key});

  static Future<void> show({required BuildContext context}) => showDialog(
    context: context,
    builder: (_) => BaseDialog(
      child: BlocProvider(
        create: (_) => PlaylistCreationCubit(context.read<PlaylistsRepository>()),
        child: const CreatePlaylistDialog(),
      ),
    ),
  );

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocBuilder<PlaylistCreationCubit, PlaylistCreationState>(
        builder: (context, state) => state.when(
          inProgress: () => const CircularProgressIndicator(),
          success: () {
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: context.semanticColors.success, size: 30),
                const SizedBox(height: AppSpacing.lg),
                const Text('Playlist was successfully created'),
              ],
            );
          },
          error: () => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Playlist was not created, please try again later'),
          ),
          initial: () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Create new playlist', style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Playlist name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  controller: _titleController,
                  autofocus: true,
                  validator: (value) => value?.isNotEmpty != true ? 'Title must not be empty' : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(onPressed: _onCreate, child: const Text('Create')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCreate() {
    final isValid = _formKey.currentState?.validate() == true;

    if (isValid) {
      context.read<PlaylistCreationCubit>().createPlaylist(_titleController.text);
    }
  }
}
