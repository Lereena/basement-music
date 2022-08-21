import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/track_uploading_bloc/track_uploading_bloc.dart';
import '../../../widgets/buttons/styled_button.dart';
import 'error_page.dart';
import 'link_input_page.dart';
import 'result_page.dart';
import 'track_info_page.dart';

class ExtractFromYoutube extends StatefulWidget {
  @override
  State<ExtractFromYoutube> createState() => _ExtractFromYoutubeState();
}

class _ExtractFromYoutubeState extends State<ExtractFromYoutube> {
  late final TrackUploadingBloc trackUploadingBloc;

  @override
  void initState() {
    super.initState();
    trackUploadingBloc = BlocProvider.of<TrackUploadingBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TrackUploadingBloc, TrackUploadingState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return CircularProgressIndicator();
          }

          if (state is LinkInputState) {
            return LinkInputPage(
              onFetchPress: (link) => trackUploadingBloc.add(LinkEntered(link)),
            );
          }

          if (state is InfoState) {
            return TrackInfoPage(
              artist: state.artist,
              title: state.title,
              onUploadPress: (artist, title) => trackUploadingBloc.add(InfoChecked(state.url, artist, title)),
            );
          }

          if (state is UploadingStartedState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                  child: Text(
                    'You can leave this page, the uploading will continue',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                StyledButton(
                  title: 'Upload other track',
                  onPressed: () => trackUploadingBloc.add(Start()),
                )
              ],
            );
          }

          if (state is SuccessfulUploadState) {
            return ResultPage(
              result: true,
              onUploadOtherTrackPress: () => trackUploadingBloc.add(Start()),
            );
          }

          return ErrorPage(
            onTryAgainPress: () => trackUploadingBloc.add(Start()),
          );
        },
      ),
    );
  }
}