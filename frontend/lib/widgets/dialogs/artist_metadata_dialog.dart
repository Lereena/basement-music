import 'package:basement_music/bloc/artist_metadata_cubit/artist_metadata_cubit.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
import 'package:basement_music/widgets/icons/error_icon.dart';
import 'package:basement_music/widgets/icons/success_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtistMetadataDialog extends StatelessWidget {
  final String artistId;
  final String artistName;
  final VoidCallback? onApplied;

  const ArtistMetadataDialog._({required this.artistId, required this.artistName, this.onApplied});

  static Future<void> show({
    required BuildContext context,
    required String artistId,
    required String artistName,
    VoidCallback? onApplied,
  }) => showDialog(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) =>
          ArtistMetadataCubit(artistsRepository: context.read<ArtistsRepository>(), artistId: artistId)
            ..search(query: artistName),
      child: ArtistMetadataDialog._(artistId: artistId, artistName: artistName, onApplied: onApplied),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: BlocConsumer<ArtistMetadataCubit, ArtistMetadataState>(
        listener: (context, state) {
          state.maybeWhen(
            applied: () {
              onApplied?.call();
              Future.delayed(const Duration(milliseconds: 900), () {
                if (context.mounted) Navigator.of(context).pop();
              });
            },
            orElse: () {},
          );
        },
        builder: (context, state) => state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          searching: () => const Center(child: CircularProgressIndicator()),
          candidates: (candidates) => _Candidates(candidates: candidates, initialQuery: artistName),
          previewLoading: () => const Center(child: CircularProgressIndicator()),
          preview: (preview) => _Preview(preview: preview),
          applying: () => const Center(child: CircularProgressIndicator()),
          applied: () => Column(
            mainAxisSize: MainAxisSize.min,
            children: const [SuccessIcon(), SizedBox(height: 20), Text('Artist info updated')],
          ),
          error: (message) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [ErrorIcon(), const SizedBox(height: 20), Text(message)],
          ),
        ),
      ),
    );
  }
}

class _Candidates extends StatefulWidget {
  final List<ArtistCandidate> candidates;
  final String initialQuery;

  const _Candidates({required this.candidates, required this.initialQuery});

  @override
  State<_Candidates> createState() => _CandidatesState();
}

class _CandidatesState extends State<_Candidates> {
  late final TextEditingController _controller = TextEditingController(text: widget.initialQuery);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Choose artist', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Search'),
                onSubmitted: (value) => context.read<ArtistMetadataCubit>().search(query: value),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.read<ArtistMetadataCubit>().search(query: _controller.text),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.candidates.isEmpty)
          const Padding(padding: EdgeInsets.all(16), child: Text('No matches'))
        else
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.candidates.length,
              separatorBuilder: (context, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final candidate = widget.candidates[index];
                final subtitleParts = [
                  if (candidate.disambiguation.isNotEmpty) candidate.disambiguation,
                  if (candidate.country.isNotEmpty) candidate.country,
                  if (candidate.begin.isNotEmpty) candidate.begin,
                ];
                return ListTile(
                  title: Text(candidate.name),
                  subtitle: subtitleParts.isEmpty ? null : Text(subtitleParts.join(' · ')),
                  onTap: () => context.read<ArtistMetadataCubit>().preview(candidate.id),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _Preview extends StatefulWidget {
  final ArtistMetadataPreview preview;

  const _Preview({required this.preview});

  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  late final TextEditingController _controller = TextEditingController(text: widget.preview.description ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.preview.imageUrl;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Preview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (imageUrl != null && imageUrl.isNotEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160, maxHeight: 160),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox.shrink()),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 6,
            minLines: 3,
            decoration: const InputDecoration(label: Text('Description'), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () => context.read<ArtistMetadataCubit>().apply(
                description: _controller.text,
                imageUrl: imageUrl ?? '',
              ),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
