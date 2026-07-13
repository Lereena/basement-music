import 'package:basement_music/bloc/album_edit_cubit/album_edit_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/utils/pick_and_crop_image.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/dialogs/album_cover_dialog.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
import 'package:basement_music/widgets/image_picker_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AlbumEditPage extends StatelessWidget {
  final String albumId;
  final bool isNew;

  const AlbumEditPage({super.key, required this.albumId, this.isNew = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumEditCubit(
        albumsRepository: context.read<AlbumsRepository>(),
        artistsRepository: context.read<ArtistsRepository>(),
        tracksRepository: context.read<TracksRepository>(),
        albumId: albumId,
        isNew: isNew,
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

  void _findCover(BuildContext context) {
    final state = context.read<AlbumEditCubit>().state;
    final title = state.title.trim();
    final artistNames = state.allArtists
        .where((a) => state.selectedArtistIds.contains(a.id))
        .map((a) => a.name)
        .toList();

    if (title.isEmpty || artistNames.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Set the album name and at least one artist to look up a cover')));
      return;
    }

    AlbumCoverDialog.show(
      context: context,
      album: state.album!,
      titleOverride: title,
      artistOverride: artistNames.first,
      onApplied: context.read<AlbumEditCubit>().reloadCover,
    );
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
            child: _EditForm(
              state: state,
              onPickCover: () => _pickCover(context),
              onFindCover: () => _findCover(context),
            ),
          ),
        );
      },
    );
  }
}

class _EditForm extends StatelessWidget {
  final AlbumEditState state;
  final VoidCallback onPickCover;
  final VoidCallback onFindCover;

  const _EditForm({required this.state, required this.onPickCover, required this.onFindCover});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<AlbumEditCubit>();

    final selectedArtists = state.allArtists.where((a) => state.selectedArtistIds.contains(a.id)).toList();

    final selectedTracks = state.orderedTrackIds
        .map(
          (id) => state.allTracks.firstWhere(
            (t) => t.id == id,
            orElse: () => Track(id: id, title: id, artist: ''),
          ),
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240, maxHeight: 240),
            child: ImagePickerBox(
              currentImageUrl: state.album?.cover,
              pickedBytes: state.pickedCoverBytes,
              onTap: onPickCover,
              placeholderIcon: Icons.album,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: TextButton.icon(
            onPressed: onFindCover,
            icon: const Icon(Icons.image_search),
            label: const Text('Find cover'),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
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
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final artist in selectedArtists)
              InputChip(label: Text(artist.name), onDeleted: () => cubit.toggleArtist(artist.id)),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
              onPressed: () => _ArtistsDialog.show(context: context, cubit: cubit),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tracks in album', style: theme.textTheme.titleMedium),
            TextButton.icon(
              onPressed: () => _AddTracksDialog.show(context: context, cubit: cubit),
              icon: const Icon(Icons.add),
              label: const Text('Add tracks'),
            ),
          ],
        ),
        if (selectedTracks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text('None yet', style: theme.textTheme.bodyMedium),
          ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: cubit.reorder,
          buildDefaultDragHandles: false,
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
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

/// Full artist selector: a searchable chip grid over the whole library.
/// Toggling updates the shared [AlbumEditCubit] live.
class _ArtistsDialog extends StatefulWidget {
  final AlbumEditCubit cubit;

  const _ArtistsDialog({required this.cubit});

  static Future<void> show({required BuildContext context, required AlbumEditCubit cubit}) => showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _ArtistsDialog(cubit: cubit),
    ),
  );

  @override
  State<_ArtistsDialog> createState() => _ArtistsDialogState();
}

class _ArtistsDialogState extends State<_ArtistsDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: BlocBuilder<AlbumEditCubit, AlbumEditState>(
        builder: (context, state) {
          final filtered = state.allArtists
              .where((a) => _query.isEmpty || a.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.xs),
                child: Text('Select artists', style: context.textTheme.titleLarge),
              ),
              TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search artists'),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSpacing.md),
              Flexible(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: filtered
                        .map(
                          (a) => FilterChip(
                            label: Text(a.name),
                            selected: state.selectedArtistIds.contains(a.id),
                            onSelected: (_) => widget.cubit.toggleArtist(a.id),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Done')),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Add-only track picker. Defaults to albumless tracks by this album's
/// artist(s); searching queries the whole library. Already-picked tracks are
/// excluded from both views.
class _AddTracksDialog extends StatefulWidget {
  final AlbumEditCubit cubit;

  const _AddTracksDialog({required this.cubit});

  static Future<void> show({required BuildContext context, required AlbumEditCubit cubit}) => showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _AddTracksDialog(cubit: cubit),
    ),
  );

  @override
  State<_AddTracksDialog> createState() => _AddTracksDialogState();
}

class _AddTracksDialogState extends State<_AddTracksDialog> {
  String _query = '';

  List<Track> _visibleTracks(AlbumEditState state) {
    final picked = state.orderedTrackIds.toSet();
    final available = state.allTracks.where((t) => !picked.contains(t.id));

    if (_query.isNotEmpty) {
      return available.where((t) => t.matchesQuery(_query)).toList();
    }

    // Default: albumless tracks whose artist matches one of the album's artists.
    final artistNames = state.allArtists
        .where((a) => state.selectedArtistIds.contains(a.id))
        .map((a) => a.name.toLowerCase())
        .toList();

    return available
        .where((t) => (t.albumId == null || t.albumId!.isEmpty))
        .where((t) => artistNames.any((name) => t.artist.toLowerCase().contains(name)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: BlocBuilder<AlbumEditCubit, AlbumEditState>(
        builder: (context, state) {
          final tracks = _visibleTracks(state);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.xs),
                child: Text('Add tracks', style: context.textTheme.titleLarge),
              ),
              TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search library'),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSpacing.sm),
              Flexible(
                child: tracks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          _query.isEmpty ? 'No unassigned tracks for these artists' : 'Nothing found',
                          style: context.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: tracks.length,
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            title: Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(track.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: const Icon(Icons.add_circle_outline),
                            onTap: () => widget.cubit.toggleTrack(track.id),
                          );
                        },
                      ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Done')),
              ),
            ],
          );
        },
      ),
    );
  }
}
