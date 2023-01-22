import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

import '../models/track.dart';

class TrackName extends StatelessWidget {
  final Track track;
  final bool moving;

  const TrackName({
    super.key,
    required this.track,
    required this.moving,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22 * MediaQuery.of(context).textScaleFactor,
      child: moving
          ? MarqueeText(
              text: TextSpan(text: track.title),
              style: const TextStyle(fontSize: 18),
              speed: 10,
              textAlign: TextAlign.start,
            )
          : Text(
              track.title,
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
