import 'package:basement_music/bloc/player_cubit/player_cubit.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/routing/breakpoints.dart';
import 'package:basement_music/widgets/current_track_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showCurrentTrackSheet(BuildContext context) {
  // The sheet's own MediaQuery has its top padding stripped by
  // showModalBottomSheet, so capture the real insets here, at the page
  // context, and pass them in.
  final safeInsets = MediaQuery.paddingOf(context);

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(),
    builder: (_) => _CurrentTrackSheetBody(safeInsets: safeInsets),
  );
}

class _CurrentTrackSheetBody extends StatelessWidget {
  final EdgeInsets safeInsets;

  const _CurrentTrackSheetBody({required this.safeInsets});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // On large screens the current track lives in the side panel instead —
    // dismiss the sheet if the window is resized past the breakpoint.
    if (size.width >= kLargeBreakpoint) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.of(context).pop();
      });
    }

    return BlocListener<PlayerCubit, PlayerState>(
      listenWhen: (previous, current) =>
          previous.currentTrack != Track.empty() && current.currentTrack == Track.empty(),
      listener: (context, _) => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.only(top: safeInsets.top, bottom: safeInsets.bottom),
        child: Column(
          children: [
            Expanded(
              child: CurrentTrackView(
                expanded: true,
                leading: IconButton(
                  icon: const Icon(Icons.expand_more, size: 36),
                  tooltip: 'Collapse',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
