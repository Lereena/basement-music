import 'package:basement_music/widgets/current_track_view.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SecondaryBodyContent extends StatelessWidget {
  const SecondaryBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey, width: 0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: CurrentTrackView(coverSize: 27.w),
      ),
    );
  }
}
