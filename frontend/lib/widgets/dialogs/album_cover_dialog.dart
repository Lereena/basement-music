import 'package:basement_music/bloc/album_cover_cubit/album_cover_cubit.dart';
import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/metadata_candidates.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
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
          initial: () => const Center(child: CircularProgressIndicator()),
          searching: () => const Center(child: CircularProgressIndicator()),
          candidates: (candidates) => _CandidatesGrid(candidates: candidates),
          applying: () => const Center(child: CircularProgressIndicator()),
          applied: () => Column(
            mainAxisSize: MainAxisSize.min,
            children: const [SuccessIcon(), SizedBox(height: 20), Text('Cover updated')],
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

class _CandidatesGrid extends StatelessWidget {
  final List<ReleaseGroupCandidate> candidates;

  const _CandidatesGrid({required this.candidates});

  @override
  Widget build(BuildContext context) {
    if (candidates.isEmpty) {
      return const Padding(padding: EdgeInsets.all(24), child: Text('No covers found'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 4),
          child: Text('Choose cover', style: Theme.of(context).textTheme.titleLarge),
        ),
        Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: candidates.length,
            itemBuilder: (context, index) {
              final candidate = candidates[index];
              return GestureDetector(
                onTap: () => context.read<AlbumCoverCubit>().apply(candidate.id),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: candidate.coverUrl != null
                      ? CachedNetworkImage(
                          imageUrl: candidate.coverUrl!,
                          fit: BoxFit.cover,
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
