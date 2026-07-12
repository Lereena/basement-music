import 'package:basement_music/theme/theme.dart';
import 'package:flutter/material.dart';

/// App-bar title for pushed sub-pages (album, playlist, settings, edit flows).
///
/// Top-level nav destinations (All tracks, Search) render no title and rely on
/// the bottom nav / rail labels instead.
class PageTitle extends StatelessWidget {
  final String text;

  const PageTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.textTheme.titleLarge);
  }
}
