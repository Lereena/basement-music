import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/playlist_edit_bloc/playlist_edit_bloc.dart';
import '../../models/track.dart';
import '../../repositories/playlists_repository.dart';
import '../../widgets/app_bar.dart';
import '../upload/result_page.dart';

class _PlaylistData {
  String? title;
  List<Track>? tracks;

  _PlaylistData({this.title, this.tracks});
}

class PlaylistEditPage extends StatelessWidget {
  final String playlistId;

  const PlaylistEditPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaylistEditBloc(
        playilstsRepository: context.read<PlaylistsRepository>(),
        playlistId: playlistId,
      )..add(PlaylistEditingStartEvent()),
      child: const _PlaylistEdit(),
    );
  }
}

class _PlaylistEdit extends StatefulWidget {
  const _PlaylistEdit();

  @override
  State<_PlaylistEdit> createState() => _PlaylistEditState();
}

class _PlaylistEditState extends State<_PlaylistEdit> {
  _PlaylistData _data = _PlaylistData();

  final _formKey = GlobalKey<FormState>();

  late final _appBarActions = [
    IconButton(
      onPressed: _onSave,
      icon: const Icon(Icons.save),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistEditBloc, PlaylistEditState>(
      builder: (context, state) {
        if (state is PlaylistEditing) {
          _data = _PlaylistData(title: state.title, tracks: state.tracks);

          return Scaffold(
            appBar: BasementAppBar(
              title: 'Edit playlist',
              actions: _appBarActions,
            ),
            body: Form(
              key: _formKey,
              child: EditView(data: _data),
            ),
          );
        }

        if (state is PlaylistLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PlaylistSavingSuccess || state is PlaylistSavingFail) {
          return ResultPage(
            result:
                state is PlaylistSavingSuccess ? Result.success : Result.fail,
            successMessage: 'Playlist was successfully edited',
            failMessage: 'Playlist editing is failed, please try again later',
            buttonText: 'OK',
            onLeavePage: () => context.pop(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _onSave() {
    final isValid = _formKey.currentState?.validate() == true;

    if (!isValid) return;

    context.read<PlaylistEditBloc>().add(
          PlaylistSaveEvent(
            title: _data.title ?? '',
            tracksIds: _data.tracks?.map((e) => e.id).toList() ?? [],
          ),
        );
  }
}

class EditView extends StatelessWidget {
  final _PlaylistData data;

  const EditView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(label: Text('Title')),
          initialValue: data.title,
          validator: (value) =>
              value?.isNotEmpty != true ? 'Field is required' : null,
          onChanged: (value) => data.title = value,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
