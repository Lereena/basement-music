import 'package:basement_music/bloc/youtube_extractor_cubit/youtube_extractor_cubit.dart';
import 'package:basement_music/pages/upload/from_youtube/link_input_page.dart';
import 'package:basement_music/pages/upload/from_youtube/track_info_page.dart';
import 'package:basement_music/pages/upload/result_page.dart';
import 'package:basement_music/pages/upload/upload_is_in_progress_page.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExtractFromYoutubePage extends StatelessWidget {
  const ExtractFromYoutubePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => YoutubeExtractorCubit(context.read<TracksRepository>()),
      child: const _ExtractFromYoutube(),
    );
  }
}

class _ExtractFromYoutube extends StatelessWidget {
  const _ExtractFromYoutube();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<YoutubeExtractorCubit>();

    return Scaffold(
      appBar: BasementAppBar(title: 'Extract from YouTube'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<YoutubeExtractorCubit, YoutubeExtractorState>(
            builder: (context, state) => state.when(
              loadInProgress: () => const Center(child: CircularProgressIndicator()),
              linkInputInProgress: (url) =>
                  LinkInputPage(onFetchPress: (link) => cubit.enterLink(link), url: url, onCancel: () => context.pop()),
              linkInputError: () =>
                  LinkInputPage(onFetchPress: (link) => cubit.enterLink(link), onCancel: () => context.pop()),
              infoObserve: (url, artist, title) => TrackInfoPage(
                artist: artist,
                title: title,
                onUpload: (a, t) => cubit.checkInfo(url, a, t),
                onCancel: () => cubit.start(url: cubit.currentUploadingLink),
              ),
              extractInProgress: () => UploadIsInProgressPage(onUploadOtherTrack: () => _onUploadOtherTrack(context)),
              extractSuccess: () => ResultPage(
                result: Result.success,
                successMessage: 'Track was successfully uploaded',
                failMessage: 'Track uploading is failed, please try again later',
                buttonText: 'OK',
                onLeavePage: () => _onUploadOtherTrack(context),
              ),
              extractError: () => ResultPage(
                result: Result.fail,
                successMessage: 'Track was successfully uploaded',
                failMessage: 'Track uploading is failed, please try again later',
                buttonText: 'OK',
                onLeavePage: () => _onUploadOtherTrack(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onUploadOtherTrack(BuildContext context) {
    context.read<YoutubeExtractorCubit>().start();
    context.go(RouteName.upload);
  }
}
