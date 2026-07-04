import 'package:flutter/material.dart';

class TrackSeekBar extends StatefulWidget {
  final double percentProgress;
  final bool enabled;
  final ValueChanged<double> onSeek;

  const TrackSeekBar({super.key, required this.percentProgress, required this.enabled, required this.onSeek});

  @override
  State<TrackSeekBar> createState() => _TrackSeekBarState();
}

class _TrackSeekBarState extends State<TrackSeekBar> {
  // Non-null while the user is dragging: the thumb follows the finger
  // instead of the position stream.
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        inactiveTrackColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Slider(
        value: _dragValue ?? widget.percentProgress.clamp(0.0, 1.0),
        onChangeStart: widget.enabled ? (value) => setState(() => _dragValue = value) : null,
        onChanged: widget.enabled ? (value) => setState(() => _dragValue = value) : null,
        onChangeEnd: widget.enabled
            ? (value) {
                widget.onSeek(value);
                setState(() => _dragValue = null);
              }
            : null,
      ),
    );
  }
}
