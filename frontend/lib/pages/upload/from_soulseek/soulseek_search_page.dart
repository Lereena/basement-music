import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/bloc/soulseek_search_cubit/soulseek_search_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/soulseek_search_result.dart';
import 'package:basement_music/models/soulseek_temp_track.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/soulseek_repository.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/utils/track_data.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/dialogs/track_edit_dialog.dart';
import 'package:basement_music/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoulseekSearchPage extends StatelessWidget {
  const SoulseekSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SoulseekSearchCubit(context.read<SoulseekRepository>()),
      child: const _SoulseekSearchView(),
    );
  }
}

class _SoulseekSearchView extends StatefulWidget {
  const _SoulseekSearchView();

  @override
  State<_SoulseekSearchView> createState() => _SoulseekSearchViewState();
}

class _SoulseekSearchViewState extends State<_SoulseekSearchView> {
  // Cached in didChangeDependencies so dispose() doesn't do an unsafe
  // ancestor lookup on a deactivated element.
  late SoulseekSearchCubit _cubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<SoulseekSearchCubit>();
  }

  @override
  void dispose() {
    _cubit.cleanup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SoulseekSearchCubit>();

    return Scaffold(
      appBar: BasementAppBar(title: 'Search Soulseek', scrolledUnderElevation: 0),
      body: HorizontalSpaceReducer(
        child: Column(
          children: [
            SearchField(autofocus: true, onSearch: cubit.search),
            Expanded(
              child: BlocBuilder<SoulseekSearchCubit, SoulseekSearchState>(
                builder: (context, state) => state.when(
                  initial: () => const Center(child: Text('Search the Soulseek network')),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  connecting: () => const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [CircularProgressIndicator(), SizedBox(height: 12), Text('Connecting to Soulseek…')],
                    ),
                  ),
                  connectionFailed: (reason) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 40),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(reason, textAlign: TextAlign.center),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => cubit.retry(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  error: () => const Center(child: Text('Search failed. Try again.')),
                  loaded: (results, preloads, searching) =>
                      _LoadedView(results: results, preloads: preloads, searching: searching),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.results, required this.preloads, required this.searching});

  final List<SoulseekSearchResult> results;
  final Map<String, SoulseekPreload> preloads;
  final bool searching;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SoulseekSearchCubit>();

    if (results.isEmpty) {
      // Still collecting peer responses -- show a spinner instead of "No results".
      if (searching) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator(), SizedBox(height: 12), Text('Searching…')],
          ),
        );
      }
      return const Center(child: Text('No results'));
    }

    // While more peers may still respond, append a trailing progress row.
    final itemCount = results.length + (searching ? 1 : 0);

    return ListView.builder(
      padding: const EdgeInsets.only(top: 12),
      itemCount: itemCount,
      itemBuilder: (_, i) {
        if (i >= results.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          );
        }

        return _ResultCard(
          key: ValueKey(resultKey(results[i])),
          result: results[i],
          preload: preloads[resultKey(results[i])],
          onPreload: () => cubit.preload(results[i]),
          onSave: (temp, artist, title) => cubit.save(results[i], temp.id, artist, title),
        );
      },
    );
  }
}

class _ResultCard extends StatefulWidget {
  const _ResultCard({
    super.key,
    required this.result,
    required this.preload,
    required this.onPreload,
    required this.onSave,
  });

  final SoulseekSearchResult result;
  final SoulseekPreload? preload;
  final VoidCallback onPreload;
  final void Function(SoulseekTempTrack temp, String artist, String title) onSave;

  @override
  State<_ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<_ResultCard> {
  bool _expanded = false;

  String get _basename {
    final path = widget.result.filename;
    final idx = path.lastIndexOf(RegExp(r'[\\/]'));
    return idx >= 0 ? path.substring(idx + 1) : path;
  }

  String get _sizeLabel {
    final mb = widget.result.size / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  String get _formatLabel {
    final result = widget.result;
    final parts = [result.extension.toUpperCase(), if (result.bitrate > 0) '${result.bitrate} kbps'];

    return parts.join(' · ');
  }

  // Open the edit dialog pre-parsed from the displayed name (same parsing as
  // device uploads), then save with the chosen artist/title.
  void _onSavePressed(SoulseekTempTrack temp) {
    final (artist, title) = getArtistAndTitle(_basename);
    TrackEditDialog.show(
      context: context,
      artist: artist,
      title: title,
      onSubmit: (result) => widget.onSave(temp, result.artist, result.title),
    );
  }

  void _play(SoulseekTempTrack temp) {
    final playerCubit = context.read<PlayerCubit>();
    final baseUrl = playerCubit.audioHandler.appConfig.baseUrl;
    final track = Track(
      id: temp.id,
      title: temp.title.isEmpty ? 'Unknown title' : temp.title,
      artist: temp.artist,
      duration: temp.duration,
    );
    playerCubit.play(
      track: track,
      streamUrl: '$baseUrl/api/soulseek/temp/${temp.id}',
      playlist: Playlist.anonymous([track]),
    );
  }

  // In-place leading control: preload → loading → play / saved / retry.
  Widget _leading() {
    final preload = widget.preload;

    if (preload == null) {
      return IconButton(
        icon: const Icon(Icons.download_for_offline_outlined),
        tooltip: 'Preload',
        onPressed: widget.onPreload,
      );
    }

    return preload.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      ready: (temp) => BlocBuilder<PlayerCubit, PlayerState>(
        builder: (context, playerState) {
          final isCurrent = playerState.currentTrack.id == temp.id;

          if (isCurrent && playerState.isPlay) {
            return IconButton(
              icon: const Icon(Icons.pause),
              tooltip: 'Pause',
              onPressed: () => context.read<PlayerCubit>().pause(),
            );
          }

          return IconButton(icon: const Icon(Icons.play_arrow), tooltip: 'Play', onPressed: () => _play(temp));
        },
      ),
      saved: () => const Padding(
        padding: EdgeInsets.all(12),
        child: Icon(Icons.check_circle, color: Colors.green),
      ),
      error: (_) => IconButton(
        icon: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
        tooltip: 'Retry',
        onPressed: widget.onPreload,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ready = widget.preload?.mapOrNull(ready: (s) => s.temp);

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              _leading(),
              Expanded(
                child: Text(
                  _basename,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (ready != null)
                TextButton.icon(
                  icon: const Icon(Icons.library_add_outlined, size: 18),
                  label: const Text('Save'),
                  onPressed: () => _onSavePressed(ready),
                ),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 150),
                child: const Icon(Icons.expand_more),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Full name', value: widget.result.filename),
                _DetailRow(label: 'Uploader', value: widget.result.peerUsername),
                _DetailRow(label: 'Format', value: _formatLabel.isEmpty ? '—' : _formatLabel),
                _DetailRow(label: 'Size', value: _sizeLabel),
              ],
            ),
          ),
        Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.4)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
