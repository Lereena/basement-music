import 'package:flutter/material.dart';

class LyricsToggle extends StatelessWidget {
  final bool active;
  final VoidCallback onToggle;
  final double size;

  const LyricsToggle({super.key, required this.active, required this.onToggle, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Translucent backdrop so the icon stays readable over cover art.
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(active ? Icons.lyrics : Icons.lyrics_outlined, size: size),
        ),
      ),
    );
  }
}
