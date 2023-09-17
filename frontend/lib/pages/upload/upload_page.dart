import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/local_track_uploading_bloc/local_track_uploading_bloc.dart';
import '../../bloc/track_uploading_bloc/track_uploading_bloc.dart';
import 'upload_from_device.dart';
import 'youtube/extract_from_youtube.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localTrackUploadingBloc =
        BlocProvider.of<LocalTrackUploadingBloc>(context);

    return UploadFromDevice(
      trackUploadingBloc: localTrackUploadingBloc,
      onCancelPressed: () {},
    );

    final trackUploadingBloc = BlocProvider.of<TrackUploadingBloc>(context);
    return ExtractFromYoutube(trackUploadingBloc: trackUploadingBloc);
  }
}
