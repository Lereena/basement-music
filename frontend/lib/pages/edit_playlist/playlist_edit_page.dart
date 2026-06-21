import 'dart:typed_data';

import 'package:basement_music/bloc/playlist_edit_cubit/playlist_edit_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/pages/upload/result_page.dart';
import 'package:basement_music/repositories/playlists_repository.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _PlaylistData {
  String? title;
  List<Track>? tracks;
  Uint8List? imageBytes;
  String? imageFilename;

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

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image, withData: true);
    if (result == null || result.files.isEmpty || result.files.first.bytes == null) return;
    setState(() {
      _data.imageBytes = result.files.first.bytes;
      _data.imageFilename = result.files.first.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistEditorCubit, PlaylistEditState>(
      builder: (context, state) => state.when(
        initial: () => const SizedBox.shrink(),
        editInProgress: (playlistId, title, image, tracks) {
          _data = _PlaylistData(title: title, tracks: tracks)
            ..imageBytes = _data.imageBytes
            ..imageFilename = _data.imageFilename;

          return Scaffold(
            appBar: BasementAppBar(title: 'Edit playlist', actions: _appBarActions),
            body: HorizontalSpaceReducer(
              child: Form(
                key: _formKey,
                child: _EditView(data: _data, currentImageUrl: image, onPickImage: _pickImage),
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
      imageBytes: _data.imageBytes,
      imageFilename: _data.imageFilename,
    );
  }
}

class _EditView extends StatelessWidget {
  final _PlaylistData data;
  final String? currentImageUrl;
  final VoidCallback onPickImage;

  const _EditView({required this.data, required this.currentImageUrl, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 164, maxHeight: 164),
          child: _ImagePicker(currentImageUrl: currentImageUrl, pickedBytes: data.imageBytes, onTap: onPickImage),
        ),
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

class _ImagePicker extends StatelessWidget {
  final String? currentImageUrl;
  final Uint8List? pickedBytes;
  final VoidCallback onTap;

  const _ImagePicker({required this.currentImageUrl, required this.pickedBytes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (pickedBytes != null)
                Image.memory(pickedBytes!, fit: BoxFit.cover)
              else if (currentImageUrl != null)
                Image.network(currentImageUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => _placeholder(theme))
              else
                _placeholder(theme),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.image_outlined, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) =>
      Container(color: theme.colorScheme.surfaceContainerHighest, child: const Icon(Icons.queue_music, size: 64));
}
