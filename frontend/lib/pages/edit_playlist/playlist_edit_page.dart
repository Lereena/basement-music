import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/playlist_edit_bloc/playlist_edit_bloc.dart';
import '../../models/track.dart';
import '../../widgets/app_bar.dart';
import 'playlist_edit_result_page.dart';

class PlaylistEditPage extends StatefulWidget {
  final String playlistId;

  const PlaylistEditPage({super.key, required this.playlistId});

  @override
  State<PlaylistEditPage> createState() => _PlaylistEditPageState();
}

class _PlaylistEditPageState extends State<PlaylistEditPage> {
  late final PlaylistEditBloc _playlistEditBloc =
      context.read<PlaylistEditBloc>();

  late final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _playlistEditBloc.add(PlaylistEditingStartEvent(widget.playlistId));
  }

  late final _appBarActions = [
    IconButton(
      onPressed: () => _playlistEditBloc.add(
        PlaylistSaveEvent(
          playlistId: widget.playlistId,
          title: '', //titleLarge,
          tracksIds: const [], // tracks,
        ),
      ),
      icon: const Icon(Icons.save),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistEditBloc, PlaylistEditState>(
      builder: (context, state) {
        if (state is PlaylistSaving) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PlaylistEditing) {
          return Scaffold(
            appBar: BasementAppBar(
              title: 'Edit playlist',
              actions: _appBarActions,
            ),
            body: Column(
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(label: Text('Title')),
                  controller: _titleController,
                  validator: (value) =>
                      value?.isNotEmpty != true ? 'Field is required' : null,
                ),
                const SizedBox(height: 32),
                Expanded(child: TracksReorderingView(tracks: state.tracks)),
              ],
            ),
          );
        }

        if (state is PlaylistSavingSuccess) {
          return PlaylistEditResultPage(
            result: EditingResult.success,
            onTryAgain: () => context.pop(),
          );
        }

        if (state is PlaylistSavingFail) {
          return PlaylistEditResultPage(
            result: EditingResult.fail,
            onTryAgain: () => context.pop(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class TracksReorderingView extends StatefulWidget {
  final List<Track> tracks;

  const TracksReorderingView({super.key, required this.tracks});

  @override
  State<TracksReorderingView> createState() => _TracksReorderingViewState();
}

class _TracksReorderingViewState extends State<TracksReorderingView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ReorderableListView(
      proxyDecorator: (child, index, animation) => Material(
        color: Colors.transparent,
        child: child,
      ),
      children: widget.tracks
          .map(
            (track) => Card(
              key: Key(track.id),
              child: ListTile(
                title: Text(
                  track.title,
                  style: theme.textTheme.labelLarge,
                ),
                subtitle: Text(
                  track.artist,
                  style: theme.textTheme.labelMedium,
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    onPressed: () {},
                    splashRadius: 24,
                  ),
                ),
              ),
            ),
          )
          .toList(),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = widget.tracks.removeAt(oldIndex);
          widget.tracks.insert(newIndex, item);
        });
      },
    );
  }
}
