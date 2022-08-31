import 'package:auto_size_text/auto_size_text.dart';
import 'package:basement_music/models/track.dart';
import 'package:flutter/material.dart';

import 'wrappers/overflow_sensitive_marqee.dart';

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
          ? OverflowSensitiveMarquee(
              track.title,
              style: const TextStyle(fontSize: 18),
            )
          : AutoSizeText(
              track.title,
              overflow: TextOverflow.ellipsis,
              minFontSize: 18,
              maxFontSize: 18,
              style: const TextStyle(fontSize: 18),
            ),
    );
  }
}
