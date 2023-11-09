import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/youtube_extractor_bloc/youtube_extractor_bloc.dart';
import '../../../repositories/tracks_repository.dart';
import '../../../routing/routes.dart';
import '../../../widgets/app_bar.dart';
import '../result_page.dart';
import '../upload_is_in_progress_page.dart';
import 'link_input_page.dart';
import 'track_info_page.dart';

class ExtractFromYoutubePage extends StatelessWidget {
  const ExtractFromYoutubePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          YoutubeExtractorBloc(context.read<TracksRepository>()),
      child: const _ExtractFromYoutube(),
    );
  }
}

class _ExtractFromYoutube extends StatelessWidget {
  const _ExtractFromYoutube();

  @override
  Widget build(BuildContext context) {
    final trackUploadingBloc = context.read<YoutubeExtractorBloc>();

    return Scaffold(
      appBar: BasementAppBar(title: 'Extract from YouTube'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<YoutubeExtractorBloc, YoutubeExtractorState>(
            builder: (context, state) {
              if (state is YoutubeExtractorLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is YoutubeExtractorLinkInputInProgress) {
                return LinkInputPage(
                  onFetchPress: (link) =>
                      trackUploadingBloc.add(YoutubeExtractorLinkEntered(link)),
                  url: state.url,
                  onCancel: () => context.pop(),
                );
              }

              if (state is YoutubeExtractorInfoObserve) {
                return TrackInfoPage(
                  artist: state.artist,
                  title: state.title,
                  onUpload: (artist, title) => trackUploadingBloc.add(
                    YoutubeExtractorInfoChecked(state.url, artist, title),
                  ),
                  onCancel: () => trackUploadingBloc.add(
                    YoutubeExtractorStarted(
                      url: trackUploadingBloc.currentUploadingLink,
                    ),
                  ),
                );
              }

              if (state is YoutubeExtractorExtractInProgress) {
                return UploadIsInProgressPage(
                  onUploadOtherTrack: () => _onUploadOtherTrack(context),
                );
              }

              if (state is YoutubeExtractorExtractSuccess ||
                  state is YoutubeExtractorExtractError) {
                return ResultPage(
                  result: state is YoutubeExtractorExtractSuccess
                      ? Result.success
                      : Result.fail,
                  successMessage: 'Track was successfully uploaded',
                  failMessage:
                      'Track uploading is failed, please try again later',
                  buttonText: 'OK',
                  onLeavePage: () => _onUploadOtherTrack(context),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _onUploadOtherTrack(BuildContext context) {
    context.read<YoutubeExtractorBloc>().add(const YoutubeExtractorStarted());
    context.go(RouteName.upload);
  }
}
