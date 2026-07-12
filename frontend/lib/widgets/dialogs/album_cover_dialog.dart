import 'package:basement_music/bloc/album_cover_cubit/album_cover_cubit.dart';
import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
import 'package:basement_music/widgets/dialogs/dialog_loading.dart';
import 'package:basement_music/widgets/icons/error_icon.dart';
import 'package:basement_music/widgets/icons/success_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlbumCoverDialog extends StatelessWidget {
  final Album album;
  final VoidCallback? onApplied;

  const AlbumCoverDialog._({required this.album, this.onApplied});

  static Future<void> show({required BuildContext context, required Album album, VoidCallback? onApplied}) =>
      showDialog(
        context: context,
        builder: (_) => BlocProvider(
          create: (_) =>
              AlbumCoverCubit(albumsRepository: context.read<AlbumsRepository>(), albumId: album.id)..search(),
          child: AlbumCoverDialog._(album: album, onApplied: onApplied),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: BlocConsumer<AlbumCoverCubit, AlbumCoverState>(
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
          initial: () => const DialogLoading(message: 'Searching covers…'),
          searching: () => const DialogLoading(message: 'Searching covers…'),
          candidates: (candidates) => _CandidatesGrid(candidates: candidates),
          applying: () => const DialogLoading(message: 'Applying…'),
          applied: () => const Column(
            mainAxisSize: MainAxisSize.min,
            children: [SuccessIcon(), SizedBox(height: AppSpacing.lg), Text('Cover updated')],
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

class _CandidatesGrid extends StatelessWidget {
  final List<ReleaseGroupCandidate> candidates;

  const _CandidatesGrid({required this.candidates});

  @override
  Widget build(BuildContext context) {
    if (candidates.isEmpty) {
      return const Padding(padding: EdgeInsets.all(AppSpacing.xl), child: Text('No covers found'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.xs),
          child: Text('Choose cover', style: context.textTheme.titleLarge),
        ),
        Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: candidates.length,
            itemBuilder: (context, index) {
              final candidate = candidates[index];
              return GestureDetector(
                onTap: () => context.read<AlbumCoverCubit>().apply(candidate.id),
                child: ClipRRect(
                  borderRadius: AppRadius.smAll,
                  child: candidate.coverUrl != null
                      ? CachedNetworkImage(
                          imageUrl: candidate.coverUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => const DialogImageLoading(),
                          errorWidget: (_, _, _) => _placeholder(context, candidate.title),
                        )
                      : _placeholder(context, candidate.title),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _placeholder(BuildContext context, String title) => Container(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(4),
    child: Text(title, textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis),
  );
}
