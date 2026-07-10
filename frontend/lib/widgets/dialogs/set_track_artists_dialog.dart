import 'package:basement_music/bloc/track_artists_setter_cubit/track_artists_setter_cubit.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/widgets/dialogs/base_dialog.dart';
import 'package:basement_music/widgets/icons/error_icon.dart';
import 'package:basement_music/widgets/icons/success_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetTrackArtistsDialog extends StatelessWidget {
  final Track track;

  const SetTrackArtistsDialog._({required this.track});

  static Future<void> show({required BuildContext context, required Track track}) => showDialog(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => TrackArtistsSetterCubit(
        artistsRepository: context.read<ArtistsRepository>(),
        tracksRepository: context.read<TracksRepository>(),
        trackId: track.id,
      )..loadArtists(),
      child: SetTrackArtistsDialog._(track: track),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: BlocConsumer<TrackArtistsSetterCubit, TrackArtistsSetterState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () => Future.delayed(const Duration(milliseconds: 900), () {
              // Only pop if this dialog is still the top route — otherwise the
              // pop would remove the page underneath and empty the stack.
              if (context.mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
                Navigator.of(context).pop();
              }
            }),
            orElse: () {},
          );
        },
        builder: (context, state) => state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (artists) => _Selector(artists: artists, track: track),
          saving: () => const Center(child: CircularProgressIndicator()),
          success: () => Column(
            mainAxisSize: MainAxisSize.min,
            children: const [SuccessIcon(), SizedBox(height: 20), Text('Artists updated')],
          ),
          error: () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [ErrorIcon(), const SizedBox(height: 20), const Text('Error updating artists')],
          ),
        ),
      ),
    );
  }
}

class _Selector extends StatefulWidget {
  final List<Artist> artists;
  final Track track;

  const _Selector({required this.artists, required this.track});

  @override
  State<_Selector> createState() => _SelectorState();
}

class _SelectorState extends State<_Selector> {
  late final Set<String> _selected;
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Preselect the artists whose name appears in the track's current artist string.
    final currentNames = widget.track.artist.split(',').map((n) => n.trim().toLowerCase()).toSet();
    _selected = widget.artists.where((a) => currentNames.contains(a.name.toLowerCase())).map((a) => a.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.artists
        .where((a) => _query.isEmpty || a.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 4),
          child: Text('Change artist', style: Theme.of(context).textTheme.titleLarge),
        ),
        TextField(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search artists'),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final artist = filtered[index];
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _selected.contains(artist.id),
                title: Text(artist.name),
                onChanged: (checked) => setState(() {
                  checked == true ? _selected.add(artist.id) : _selected.remove(artist.id);
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: _selected.isEmpty
                ? null
                : () => context.read<TrackArtistsSetterCubit>().save(_selected.toList()),
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}
