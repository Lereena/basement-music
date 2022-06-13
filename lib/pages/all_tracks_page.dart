import 'package:flutter/material.dart';

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
        return Expanded(
          child: ListView.separated(
            separatorBuilder: (context, _) => Divider(height: 1),
            itemCount: tracks.length,
            itemBuilder: (context, index) => TrackCard(track: tracks[index]),
          ),
        );
      },
    );
  }
}
