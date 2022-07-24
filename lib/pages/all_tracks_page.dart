import 'package:basement_music/widgets/wrappers/track_context_menu.dart';
import 'package:flutter/material.dart';

import '../interactors/track_interactor.dart';
import '../library.dart';
import '../models/track.dart';
import '../widgets/track_card.dart';

class AllTracksPage extends StatelessWidget {
  const AllTracksPage() : super();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Track>>(
      future: fetchAllTracks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data!.isEmpty) {
          return Expanded(child: Center(child: Text('No tracks')));
        }
        return Expanded(
          child: ListView.separated(
            separatorBuilder: (context, _) => Divider(height: 1),
            itemCount: tracks.length,
            itemBuilder: (context, index) => TrackContextMenu(
              trackCard: TrackCard(track: tracks[index]),
            ),
          ),
        );
      },
    );
  }
}
