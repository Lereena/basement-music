import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/bloc/soulseek_search_cubit/soulseek_search_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/soulseek_search_result.dart';
import 'package:basement_music/models/soulseek_temp_track.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/soulseek_repository.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/app_bar.dart';
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
  @override
  void dispose() {
    context.read<SoulseekSearchCubit>().cleanup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SoulseekSearchCubit>();

    return Scaffold(
      appBar: BasementAppBar(title: 'Search Soulseek'),
      body: HorizontalSpaceReducer(
        child: Column(
          children: [
            SearchField(autofocus: true, onSearch: cubit.search),
            Expanded(
              child: BlocConsumer<SoulseekSearchCubit, SoulseekSearchState>(
                listenWhen: (prev, curr) =>
                    curr.maybeWhen(loaded: (_, _, _, error) => error != null, orElse: () => false),
                listener: (context, state) {
                  state.maybeWhen(
                    loaded: (_, _, _, error) {
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                      }
                    },
                    orElse: () {},
                  );
                },
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
                  loaded: (results, preloaded, preloadInProgress, _) =>
                      _LoadedView(results: results, preloaded: preloaded, preloadInProgress: preloadInProgress),
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
  const _LoadedView({required this.results, required this.preloaded, required this.preloadInProgress});

  final List<SoulseekSearchResult> results;
  final List<SoulseekTempTrack> preloaded;
  final bool preloadInProgress;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SoulseekSearchCubit>();

    return Column(
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('No results'))
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, i) => _ResultCard(result: results[i], onPreview: () => cubit.preload(results[i])),
                ),
        ),
        if (preloaded.isNotEmpty) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Preloaded', style: Theme.of(context).textTheme.titleSmall),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: preloaded.length,
              itemBuilder: (_, i) => _PreloadedCard(temp: preloaded[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _ResultCard extends StatefulWidget {
  const _ResultCard({required this.result, required this.onPreview});

  final SoulseekSearchResult result;
  final VoidCallback onPreview;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.download_for_offline_outlined),
                tooltip: 'Preload',
                onPressed: widget.onPreview,
              ),
              Expanded(
                child: Text(
                  _basename,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
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

class _PreloadedCard extends StatelessWidget {
  const _PreloadedCard({required this.temp});

  final SoulseekTempTrack temp;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SoulseekSearchCubit>();
    final playerCubit = context.read<PlayerCubit>();
    final baseUrl = playerCubit.audioHandler.appConfig.baseUrl;

    final track = Track(
      id: temp.id,
      title: temp.title.isEmpty ? 'Unknown title' : temp.title,
      artist: temp.artist,
      duration: temp.duration,
    );

    return ListTile(
      dense: true,
      leading: IconButton(
        icon: const Icon(Icons.play_arrow),
        tooltip: 'Play',
        onPressed: () => playerCubit.play(
          track: track,
          streamUrl: '$baseUrl/api/soulseek/temp/${temp.id}',
          playlist: Playlist.anonymous([track]),
        ),
      ),
      title: Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(temp.artist),
      trailing: TextButton.icon(
        icon: const Icon(Icons.library_add_outlined, size: 18),
        label: const Text('Save'),
        onPressed: () => cubit.save(temp.id),
      ),
    );
  }
}
