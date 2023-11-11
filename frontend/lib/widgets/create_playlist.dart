import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../bloc/playlist_creation_bloc/playlist_creation_bloc.dart';
import '../repositories/playlists_repository.dart';
import 'dialogs/dialog.dart';

class CreatePlaylistDialog extends StatefulWidget {
  const CreatePlaylistDialog({super.key});

  static Future<void> show({required BuildContext context}) => showDialog(
        context: context,
        builder: (_) => CustomDialog(
          height: min(30.h, 300),
          width: min(50.w, 450),
          child: BlocProvider(
            create: (_) =>
                PlaylistCreationBloc(context.read<PlaylistsRepository>()),
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
      child: Center(
        child: BlocBuilder<PlaylistCreationBloc, PlaylistCreationState>(
          builder: (context, state) {
            if (state is PlaylistCreationInProgress) {
              return const CircularProgressIndicator();
            }

            if (state is PlaylistCreationSuccess) {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              });

              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 30,
                  ),
                  SizedBox(height: 16),
                  Text('Playlist was successfully created'),
                ],
              );
            }

            if (state is PlaylistCreationError) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Playlist was not created, please try again later'),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create new playlist',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                    controller: _titleController,
                    autofocus: true,
                    validator: (value) => value?.isNotEmpty != true
                        ? 'Title must not be empty'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _onCreate,
                      child: const Text(
                        'Create',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onCreate() {
    final isValid = _formKey.currentState?.validate() == true;

    if (isValid) {
      context.read<PlaylistCreationBloc>().add(
            PlaylistCreationLoadingStarted(_titleController.text),
          );
    }
  }
}
