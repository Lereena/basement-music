import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cacher_bloc/bloc/cacher_bloc.dart';
import '../../models/track.dart';
import '../../pages/add_to_playlist_page.dart';
import '../dialog.dart';
import '../edit_track.dart';

class MoreButton extends StatelessWidget {
  final Track track;

  const MoreButton({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cacherBloc = BlocProvider.of<CacherBloc>(context);

    return InkWell(
      child: Icon(Icons.more_vert),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text('Edit track info'),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    child: EditTrack(
                      titleText: Text(
                        'Edit track info',
                        style: TextStyle(fontSize: 24),
                      ),
                      track: track,
                    ),
                  ),
                ),
              ),
              Divider(),
              SimpleDialogOption(
                  child: Text('Add to playlist'),
                  onPressed: () async {
                    Navigator.pop(context);
                    await showDialog(
                      context: context,
                      builder: (context) => AddToPlaylistDialog(trackId: track.id),
                    );
                  }),
              Divider(),
              SimpleDialogOption(
                child: Text('Cache track'),
                onPressed: () {
                  _cacherBloc.add(CacheTrackEvent(track.id));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
