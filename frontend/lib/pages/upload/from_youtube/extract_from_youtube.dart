import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/track_uploading_bloc/track_uploading_bloc.dart';
import '../../../routing/routes.dart';
import '../../../widgets/app_bar.dart';
import '../error_page.dart';
import '../result_page.dart';
import '../upload_is_in_progress_page.dart';
import 'link_input_page.dart';
import 'track_info_page.dart';

class ExtractFromYoutube extends StatelessWidget {
  const ExtractFromYoutube({super.key});

  @override
  Widget build(BuildContext context) {
    final trackUploadingBloc = context.read<TrackUploadingBloc>();

    return Scaffold(
      appBar: BasementAppBar(title: 'Extract from YouTube'),
      body: Column(
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
                  onCancel: () => context.pop(),
                );
              }

              if (state is InfoState) {
                return TrackInfoPage(
                  artist: state.artist,
                  title: state.title,
                  onUpload: (artist, title) => trackUploadingBloc
                      .add(InfoChecked(state.url, artist, title)),
                  onCancel: () => trackUploadingBloc
                      .add(Start(url: trackUploadingBloc.currentUploadingLink)),
                );
              }

              if (state is UploadingStartedState) {
                return UploadIsInProgressPage(
                  onUploadOtherTrack: () => _onUploadOtherTrack(context),
                );
              }

              if (state is SuccessfulUploadState) {
                return ResultPage(
                  result: true,
                  onUploadOtherTrackPress: () => _onUploadOtherTrack(context),
                );
              }

              return ErrorPage(
                errorText:
                    "Couldn't fetch YouTube video. Please check the link and try again.",
                onTryAgain: () => _onUploadOtherTrack(context),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onUploadOtherTrack(BuildContext context) {
    context.go(RouteName.upload);
    context.read<TrackUploadingBloc>().add(const Start());
  }
}
