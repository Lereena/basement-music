import 'package:basement_music/widgets/edit_track.dart';
import 'package:basement_music/widgets/dialog.dart';
import 'package:context_menus/context_menus.dart';
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
        return Expanded(
          child: ListView.separated(
            separatorBuilder: (context, _) => Divider(height: 1),
            itemCount: tracks.length,
            itemBuilder: (context, index) => ContextMenuRegion(
              child: TrackCard(track: tracks[index]),
              contextMenu: GenericContextMenu(
                buttonConfigs: [
                  ContextMenuButtonConfig(
                    'Edit track info',
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        child: EditTrack(
                            titleText: Text(
                              'Edit track info',
                              style: TextStyle(fontSize: 24),
                            ),
                            track: tracks[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
