import 'package:basement_music/models/track.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class TrackName extends StatelessWidget {
  final Track track;
  final bool moving;
  final double fontSize;

  const TrackName({super.key, required this.track, required this.moving, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    // Inherit the ambient text style (TrackCard sets the title token + the
    // current-track color) and only override the size for the caller.
    final style = DefaultTextStyle.of(context).style.copyWith(fontSize: fontSize);

    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(fontSize * 1.25),
      child: moving
          ? MarqueeText(
              text: TextSpan(text: track.title),
              style: style,
              speed: 10,
              textAlign: TextAlign.start,
            )
          : Text(
              track.title,
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
