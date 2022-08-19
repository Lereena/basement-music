import 'package:basement_music/bloc/player_bloc/player_state.dart';
import 'package:basement_music/cacher/cacher.dart';
import 'package:basement_music/widgets/buttons/more_button.dart';
import 'package:basement_music/widgets/controls/pause_button.dart';
import 'package:basement_music/widgets/track_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cacher/caching_state.dart';
import '../models/track.dart';
import '../bloc/player_bloc/player_bloc.dart';
import 'controls/play_button.dart';
import 'cover.dart';

class TrackCard extends StatefulWidget {
  final Track track;

  TrackCard({Key? key, required this.track}) : super(key: key);

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  late CachingState cachingState = CachingState.errorCaching;

  @override
  void initState() {
    super.initState();

    cacher.updateSubject.listen((event) {
      if (event.trackId != widget.track.id) return;

      cachingState = event.type;
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cached = cacher.isCached(widget.track.id);

      if (!cached) return;

      cachingState = CachingState.finishCaching;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return BlocBuilder<PlayerBloc, AudioPlayerState>(
      builder: (context, state) => Container(
        color: playerBloc.currentTrack == widget.track
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Container(
                width: 40,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Cover(cachingState: cachingState, cover: widget.track.cover),
                    Container(color: Colors.black.withOpacity(0.1)),
                    if (playerBloc.currentTrack == widget.track &&
                        (state is PlayingPlayerState || state is ResumedPlayerState))
                      PauseButton()
                    else
                      PlayButton(track: widget.track, state: state),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrackName(
                    track: widget.track,
                    moving: playerBloc.currentTrack == widget.track,
                  ),
                  Text(
                    widget.track.artist,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.track.durationStr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 15),
            MoreButton(track: widget.track),
            SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
