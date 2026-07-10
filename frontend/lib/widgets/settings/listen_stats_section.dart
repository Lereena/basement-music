import 'package:basement_music/bloc/listen_stats_cubit/listen_stats_cubit.dart';
import 'package:basement_music/models/listen_stats.dart';
import 'package:basement_music/repositories/stats_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListenStatsSection extends StatelessWidget {
  const ListenStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Wrapped stats',
            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.equalizer_outlined),
          title: const Text('Listen events'),
          subtitle: const Text('Collected listens from all users'),
          onTap: () => showDialog<void>(
            context: context,
            builder: (_) => BlocProvider(
              create: (_) => ListenStatsCubit(context.read<StatsRepository>())..loadPage(1),
              child: const ListenStatsDialog(),
            ),
          ),
        ),
      ],
    );
  }
}

class ListenStatsDialog extends StatelessWidget {
  const ListenStatsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
              child: Row(
                children: [
                  Text('Listen events', style: theme.textTheme.titleLarge),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<ListenStatsCubit, ListenStatsState>(
                builder: (context, state) => state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: () => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Failed to load listen events'),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: () => context.read<ListenStatsCubit>().loadPage(1),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  loaded: (page) => page.listens.isEmpty
                      ? const Center(child: Text('No listen events yet'))
                      : ListView.separated(
                          itemCount: page.listens.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (_, index) => _ListenStatTile(listen: page.listens[index]),
                        ),
                ),
              ),
            ),
            const Divider(height: 1),
            BlocBuilder<ListenStatsCubit, ListenStatsState>(
              builder: (context, state) => state.maybeWhen(
                loaded: (page) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: page.page > 1
                            ? () => context.read<ListenStatsCubit>().loadPage(page.page - 1)
                            : null,
                      ),
                      Text('Page ${page.page} of ${page.totalPages}', style: theme.textTheme.bodyMedium),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: page.page < page.totalPages
                            ? () => context.read<ListenStatsCubit>().loadPage(page.page + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
                orElse: () => const SizedBox(height: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListenStatTile extends StatelessWidget {
  const _ListenStatTile({required this.listen});

  final ListenStat listen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = listen.trackTitle.isEmpty ? listen.trackId : listen.trackTitle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  listen.trackArtist.isEmpty ? title : '${listen.trackArtist} — $title',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(_formatDuration(listen.durationMs), style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  listen.userEmail,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(_formatTime(listen.startedAt.toLocal()), style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int ms) {
    final totalSeconds = ms ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)} ${two(t.hour)}:${two(t.minute)}';
  }
}
