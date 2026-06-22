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
            Padding(
              padding: const EdgeInsets.all(8),
              child: SearchField(autofocus: true, onSearch: cubit.search),
            ),
            Expanded(
              child: BlocConsumer<SoulseekSearchCubit, SoulseekSearchState>(
                listenWhen: (prev, curr) => curr.maybeWhen(
                  loaded: (_, _, _, error) => error != null,
                  orElse: () => false,
                ),
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
                  error: () => const Center(child: Text('Search failed. Try again.')),
                  loaded: (results, preloaded, preloadInProgress, _) => _LoadedView(
                    results: results,
                    preloaded: preloaded,
                    preloadInProgress: preloadInProgress,
                  ),
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
        if (preloadInProgress) const LinearProgressIndicator(),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('No results'))
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, i) => _ResultCard(
                    result: results[i],
                    onPreview: () => cubit.preload(results[i]),
                  ),
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

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.onPreview});

  final SoulseekSearchResult result;
  final VoidCallback onPreview;

  String get _sizeLabel {
    final mb = result.size / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      result.peerUsername,
      result.extension.toUpperCase(),
      if (result.bitrate > 0) '${result.bitrate} kbps',
      _sizeLabel,
    ].join(' · ');

    return ListTile(
      dense: true,
      title: Text(result.filename, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.download_for_offline_outlined),
        tooltip: 'Preview',
        onPressed: onPreview,
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
