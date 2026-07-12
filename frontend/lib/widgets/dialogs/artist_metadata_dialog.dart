import 'package:basement_music/bloc/artist_metadata_cubit/artist_metadata_cubit.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
import 'package:basement_music/widgets/dialogs/dialog_loading.dart';
import 'package:basement_music/widgets/icons/error_icon.dart';
import 'package:basement_music/widgets/icons/success_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                // Only pop if this dialog is still the top route — otherwise the
                // pop would remove the page underneath and empty the stack.
                if (context.mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
                  Navigator.of(context).pop();
                }
              });
            },
            orElse: () {},
          );
        },
        builder: (context, state) => state.when(
          initial: () => const DialogLoading(message: 'Searching…'),
          searching: () => const DialogLoading(message: 'Searching…'),
          candidates: (candidates) => _Candidates(candidates: candidates, initialQuery: artistName),
          previewLoading: () => const DialogLoading(message: 'Loading preview…'),
          preview: (preview) => _Preview(preview: preview),
          applying: () => const DialogLoading(message: 'Applying…'),
          applied: () => const Column(
            mainAxisSize: MainAxisSize.min,
            children: [SuccessIcon(), SizedBox(height: AppSpacing.lg), Text('Artist info updated')],
          ),
          error: (message) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [ErrorIcon(), const SizedBox(height: AppSpacing.lg), Text(message)],
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
        Text('Choose artist', style: context.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
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
        const SizedBox(height: AppSpacing.sm),
        if (widget.candidates.isEmpty)
          const Padding(padding: EdgeInsets.all(AppSpacing.lg), child: Text('No matches'))
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
          Text('Preview', style: context.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: AppRadius.smAll,
              child: SizedBox(
                width: 160,
                height: 160,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const DialogImageLoading(),
                  errorWidget: (_, _, _) => const DialogImageError(),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            maxLines: 6,
            minLines: 3,
            decoration: const InputDecoration(label: Text('Description'), border: OutlineInputBorder()),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () =>
                  context.read<ArtistMetadataCubit>().apply(description: _controller.text, imageUrl: imageUrl ?? ''),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
