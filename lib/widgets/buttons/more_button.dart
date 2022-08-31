import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cacher_bloc/bloc/cacher_bloc.dart';
import '../../models/track.dart';
import '../../pages/add_to_playlist_page.dart';
import '../dialog.dart';
import '../edit_track.dart';

class MoreButton extends StatelessWidget {
  final Track track;

  const MoreButton({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final cacherBloc = BlocProvider.of<CacherBloc>(context);

    return InkWell(
      child: const Icon(Icons.more_vert),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            children: [
              SimpleDialogOption(
                child: const Text('Edit track info'),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    child: EditTrack(
                      titleText: const Text(
                        'Edit track info',
                        style: TextStyle(fontSize: 24),
                      ),
                      track: track,
                    ),
                  ),
                ),
              ),
              const Divider(),
              SimpleDialogOption(
                child: const Text('Add to playlist'),
                onPressed: () async {
                  Navigator.pop(context);
                  await showDialog(
                    context: context,
                    builder: (context) => AddToPlaylistDialog(trackId: track.id),
                  );
                },
              ),
              if (!kIsWeb) ...[
                const Divider(),
                SimpleDialogOption(
                  child: const Text('Cache track'),
                  onPressed: () {
                    cacherBloc.add(CacheTrackEvent(track.id));
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
