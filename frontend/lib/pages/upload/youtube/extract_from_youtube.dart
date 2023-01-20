import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/track_uploading_bloc/track_uploading_bloc.dart';
import '../../../widgets/buttons/styled_button.dart';
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
                onFetchPress: (link) => trackUploadingBloc.add(LinkEntered(link)),
                url: state.url,
              );
            }

            if (state is InfoState) {
              return TrackInfoPage(
                artist: state.artist,
                title: state.title,
                onUploadPress: (artist, title) => trackUploadingBloc.add(InfoChecked(state.url, artist, title)),
                onCancel: () => trackUploadingBloc.add(Start(url: trackUploadingBloc.link)),
              );
            }

            if (state is UploadingStartedState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                    child: Text(
                      'You can leave this page, the uploading will continue',
                      style: Theme.of(context).textTheme.headline6,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  StyledButton(
                    title: 'Upload other track',
                    autofocus: true,
                    onPressed: () => trackUploadingBloc.add(const Start()),
                  )
                ],
              );
            }

            if (state is SuccessfulUploadState) {
              return ResultPage(
                result: true,
                onUploadOtherTrackPress: () => trackUploadingBloc.add(const Start()),
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
