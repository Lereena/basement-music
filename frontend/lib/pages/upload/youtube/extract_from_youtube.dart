import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/track_uploading_bloc/track_uploading_bloc.dart';
import '../upload_is_in_progress_page.dart';
import 'error_page.dart';
import 'link_input_page.dart';
import 'result_page.dart';
import 'track_info_page.dart';

class ExtractFromYoutube extends StatelessWidget {
  final TrackUploadingBloc trackUploadingBloc;

  const ExtractFromYoutube({super.key, required this.trackUploadingBloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TrackUploadingBloc, TrackUploadingState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LinkInputState) {
              return LinkInputPage(
                onFetchPress: (link) =>
                    trackUploadingBloc.add(LinkEntered(link)),
                url: state.url,
              );
            }

            if (state is InfoState) {
              return TrackInfoPage(
                artist: state.artist,
                title: state.title,
                onUploadPress: (artist, title) => trackUploadingBloc
                    .add(InfoChecked(state.url, artist, title)),
                onCancel: () => trackUploadingBloc
                    .add(Start(url: trackUploadingBloc.currentUploadingLink)),
              );
            }

            if (state is UploadingStartedState) {
              return UploadIsInProgressPage(
                onUploadOtherTrack: () => trackUploadingBloc.add(const Start()),
              );
            }

            if (state is SuccessfulUploadState) {
              return ResultPage(
                result: true,
                onUploadOtherTrackPress: () =>
                    trackUploadingBloc.add(const Start()),
              );
            }

            return ErrorPage(
              onTryAgainPress: () => trackUploadingBloc.add(const Start()),
            );
          },
        ),
      ],
    );
  }
}
