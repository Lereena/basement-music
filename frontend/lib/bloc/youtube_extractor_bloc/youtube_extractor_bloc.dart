import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../logger.dart';
import '../../models/video_info.dart';
import '../../repositories/tracks_repository.dart';

part 'youtube_extractor_event.dart';
part 'youtube_extractor_state.dart';

class YoutubeExtractorBloc
    extends Bloc<YoutubeExtractorEvent, YoutubeExtractorState> {
  final TracksRepository _tracksRepository;

  String currentUploadingLink = '';

  YoutubeExtractorBloc(this._tracksRepository)
      : super(const YoutubeExtractorLinkInputInProgress()) {
    on<YoutubeExtractorStarted>(_onYoutubeExtractorStarted);
    on<YoutubeExtractorLinkEntered>(_onYoutubeExtractorLinkEntered);
    on<YoutubeExtractorInfoChecked>(_onYoutubeExtractorInfoChecked);
  }

  FutureOr<void> _onYoutubeExtractorStarted(
    YoutubeExtractorStarted event,
    Emitter<YoutubeExtractorState> emit,
  ) {
    emit(YoutubeExtractorLinkInputInProgress(url: event.url));
    currentUploadingLink = event.url ?? '';
  }

  FutureOr<void> _onYoutubeExtractorLinkEntered(
    YoutubeExtractorLinkEntered event,
    Emitter<YoutubeExtractorState> emit,
  ) async {
    if (event.link.isEmpty) {
      emit(YoutubeExtractorLinkInputError());
      return;
    }

    emit(YoutubeExtractorLoadInProgress());

    currentUploadingLink = event.link;

    late VideoInfo? videoInfo;
    try {
      videoInfo = await _tracksRepository.fetchYtVideoInfo(event.link);
    } catch (e) {
      emit(YoutubeExtractorLinkInputError());
      return;
    }

    emit(
      YoutubeExtractorInfoObserve(
        event.link,
        videoInfo?.artist ?? '',
        videoInfo?.title ?? '',
      ),
    );
  }

  FutureOr<void> _onYoutubeExtractorInfoChecked(
    YoutubeExtractorInfoChecked event,
    Emitter<YoutubeExtractorState> emit,
  ) async {
    emit(YoutubeExtractorExtractInProgress());

    try {
      await _tracksRepository.uploadYtTrack(
        event.url,
        event.artist,
        event.title,
      );

      if (currentUploadingLink != event.url) {
        return; // when we are already uploading this track
      }

      emit(YoutubeExtractorExtractSuccess());

      await _tracksRepository.getAllTracks();
    } catch (e) {
      emit(YoutubeExtractorExtractError());
      logger.e('Error extracting track from Youtube: $e');
    }
  }
}
