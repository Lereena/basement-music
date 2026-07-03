import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

import 'package:basement_music/models/track.dart';

class TrackName extends StatelessWidget {
  final Track track;
  final bool moving;
  final double fontSize;

  const TrackName({super.key, required this.track, required this.moving, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(fontSize + 4),
      child: moving
          ? MarqueeText(
              text: TextSpan(text: track.title),
              style: TextStyle(fontSize: fontSize),
              speed: 10,
              textAlign: TextAlign.start,
            )
          : Text(
              track.title,
              style: TextStyle(fontSize: fontSize),
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
