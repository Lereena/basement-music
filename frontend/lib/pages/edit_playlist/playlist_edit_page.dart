import 'package:basement_music/bloc/playlist_edit_cubit/playlist_edit_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/pages/upload/result_page.dart';
import 'package:basement_music/repositories/playlists_repository.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      create: (_) =>
          PlaylistEditorCubit(playlistsRepository: context.read<PlaylistsRepository>(), playlistId: playlistId)
            ..startEditing(),
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

  late final _appBarActions = [IconButton(onPressed: _onSave, icon: const Icon(Icons.save))];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistEditorCubit, PlaylistEditState>(
      builder: (context, state) => state.when(
        initial: () => const SizedBox.shrink(),
        editInProgress: (playlistId, title, tracks) {
          _data = _PlaylistData(title: title, tracks: tracks);
          return Scaffold(
            appBar: BasementAppBar(title: 'Edit playlist', actions: _appBarActions),
            body: HorizontalSpaceReducer(
              child: Form(
                key: _formKey,
                child: EditView(data: _data),
              ),
            ),
          );
        },
        saveInProgress: () => const Center(child: CircularProgressIndicator()),
        success: () => ResultPage(
          result: Result.success,
          successMessage: 'Playlist was successfully edited',
          failMessage: 'Playlist editing is failed, please try again later',
          buttonText: 'OK',
          onLeavePage: () => context.pop(),
        ),
        fail: () => ResultPage(
          result: Result.fail,
          successMessage: 'Playlist was successfully edited',
          failMessage: 'Playlist editing is failed, please try again later',
          buttonText: 'OK',
          onLeavePage: () => context.pop(),
        ),
      ),
    );
  }

  void _onSave() {
    final isValid = _formKey.currentState?.validate() == true;
    if (!isValid) return;

    context.read<PlaylistEditorCubit>().save(
      title: _data.title ?? '',
      tracksIds: _data.tracks?.map((e) => e.id).toList() ?? [],
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
          validator: (value) => value?.isNotEmpty != true ? 'Field is required' : null,
          onChanged: (value) => data.title = value,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
