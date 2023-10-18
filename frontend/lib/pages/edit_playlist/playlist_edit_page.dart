import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/playlist_edit_bloc/playlist_edit_bloc.dart';
import '../../models/track.dart';
import '../../widgets/app_bar.dart';
import 'playlist_edit_result_page.dart';

class _PlaylistData {
  String? title;
  List<Track>? tracks;

  _PlaylistData({this.title, this.tracks});
}

class PlaylistEditPage extends StatefulWidget {
  final String playlistId;

  const PlaylistEditPage({super.key, required this.playlistId});

  @override
  State<PlaylistEditPage> createState() => _PlaylistEditPageState();
}

class _PlaylistEditPageState extends State<PlaylistEditPage> {
  late final PlaylistEditBloc _playlistEditBloc =
      context.read<PlaylistEditBloc>();

  _PlaylistData _data = _PlaylistData();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _playlistEditBloc.add(PlaylistEditingStartEvent(widget.playlistId));
  }

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

        if (state is PlaylistSavingSuccess) {
          return PlaylistEditResultPage(
            result: EditingResult.success,
            onClose: () => context.pop(),
          );
        }

        if (state is PlaylistSavingFail) {
          return PlaylistEditResultPage(
            result: EditingResult.fail,
            onClose: () => context.pop(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _onSave() {
    final isValid = _formKey.currentState?.validate() == true;

    if (!isValid) return;

    _playlistEditBloc.add(
      PlaylistSaveEvent(
        playlistId: widget.playlistId,
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
