import 'package:basement_music/cacher/cacher.dart';
import 'package:basement_music/library.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../dialog.dart';
import '../edit_track.dart';
import '../track_card.dart';

class TrackContextMenu extends StatefulWidget {
  final TrackCard trackCard;

  const TrackContextMenu({Key? key, required this.trackCard}) : super(key: key);

  @override
  State<TrackContextMenu> createState() => _TrackContextMenuState();
}

class _TrackContextMenuState extends State<TrackContextMenu> {
  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      child: widget.trackCard,
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
                    track: widget.trackCard.track),
              ),
            ),
          ),
          if (!kIsWeb && !cachedTracks.contains(widget.trackCard.track.id))
            ContextMenuButtonConfig('Cache track', onPressed: () async {
              await cacher.startCaching(widget.trackCard.track.id);
            })
        ],
      ),
    );
  }
}
