import 'package:basement_music/bloc/album_edit_cubit/album_edit_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/utils/pick_and_crop_image.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/image_picker_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AlbumEditPage extends StatelessWidget {
  final String albumId;

  const AlbumEditPage({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumEditCubit(
        albumsRepository: context.read<AlbumsRepository>(),
        artistsRepository: context.read<ArtistsRepository>(),
        tracksRepository: context.read<TracksRepository>(),
        albumId: albumId,
      )..startEditing(),
      child: const _AlbumEdit(),
    );
  }
}

class _AlbumEdit extends StatelessWidget {
  const _AlbumEdit();

  Future<void> _pickCover(BuildContext context) async {
    final state = context.read<AlbumEditCubit>().state;
    final picked = await pickAndCropImage(
      context,
      currentImageUrl: state.album?.cover,
      currentBytes: state.pickedCoverBytes,
    );
    if (picked == null || !context.mounted) return;
    context.read<AlbumEditCubit>().pickCover(picked.bytes, picked.name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlbumEditCubit, AlbumEditState>(
      listener: (context, state) {
        if (state.saved && context.mounted) context.pop();
        if (state.error && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
        }
      },
      builder: (context, state) {
        if (state.loading || state.saving) {
          return Scaffold(
            appBar: BasementAppBar(title: 'Edit album'),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: BasementAppBar(
            title: 'Edit album',
            actions: [IconButton(icon: const Icon(Icons.save), onPressed: () => context.read<AlbumEditCubit>().save())],
          ),
          body: HorizontalSpaceReducer(
            child: _EditForm(state: state, onPickCover: () => _pickCover(context)),
          ),
        );
      },
    );
  }
}

class _EditForm extends StatefulWidget {
  final AlbumEditState state;
  final VoidCallback onPickCover;

  const _EditForm({required this.state, required this.onPickCover});

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  String _trackQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<AlbumEditCubit>();
    final state = widget.state;

    final selectedTracks = state.orderedTrackIds
        .map(
          (id) => state.allTracks.firstWhere(
            (t) => t.id == id,
            orElse: () => Track(id: id, title: id, artist: ''),
          ),
        )
        .toList();

    final filtered = state.allTracks.where((t) => _trackQuery.isEmpty || t.matchesQuery(_trackQuery)).toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 164, maxHeight: 164),
          child: ImagePickerBox(
            currentImageUrl: state.album?.cover,
            pickedBytes: state.pickedCoverBytes,
            onTap: widget.onPickCover,
            placeholderIcon: Icons.album,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        TextFormField(
          decoration: const InputDecoration(label: Text('Title')),
          initialValue: state.title,
          onChanged: cubit.setTitle,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          decoration: const InputDecoration(label: Text('Year')),
          initialValue: state.year,
          keyboardType: TextInputType.number,
          onChanged: cubit.setYear,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Artists', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: state.allArtists
              .map(
                (a) => FilterChip(
                  label: Text(a.name),
                  selected: state.selectedArtistIds.contains(a.id),
                  onSelected: (_) => cubit.toggleArtist(a.id),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Tracks in album', style: theme.textTheme.titleMedium),
        if (selectedTracks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text('None yet', style: theme.textTheme.bodyMedium),
          ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: cubit.reorder,
          children: [
            for (final track in selectedTracks)
              ListTile(
                key: ValueKey(track.id),
                contentPadding: EdgeInsets.zero,
                leading: ReorderableDragStartListener(
                  index: selectedTracks.indexOf(track),
                  child: const Icon(Icons.drag_handle),
                ),
                title: Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(track.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => cubit.toggleTrack(track.id),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Add tracks', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search tracks'),
          onChanged: (value) => setState(() => _trackQuery = value),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...filtered.map(
          (track) => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: state.orderedTrackIds.contains(track.id),
            title: Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(track.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
            onChanged: (_) => cubit.toggleTrack(track.id),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}
