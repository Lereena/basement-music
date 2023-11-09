import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../logger.dart';
import '../../models/video_info.dart';
import '../../repositories/tracks_repository.dart';

part 'track_uploading_event.dart';
part 'track_uploading_state.dart';

class TrackUploadingBloc
    extends Bloc<TrackUploadingEvent, TrackUploadingState> {
  final TracksRepository _tracksRepository;

  String currentUploadingLink = '';

  TrackUploadingBloc(this._tracksRepository) : super(const LinkInputState()) {
    on<Start>(_onStart);
    on<LinkEntered>(_onLinkEntered);
    on<InfoChecked>(_onInfoChecked);
  }

  FutureOr<void> _onStart(Start event, Emitter<TrackUploadingState> emit) {
    emit(LinkInputState(url: event.url));
    currentUploadingLink = event.url ?? '';
  }

  FutureOr<void> _onLinkEntered(
    LinkEntered event,
    Emitter<TrackUploadingState> emit,
  ) async {
    if (event.link.isEmpty) {
      emit(LinkInputErrorState());
      return;
    }

    emit(LoadingState());

    currentUploadingLink = event.link;

    late VideoInfo? videoInfo;
    try {
      videoInfo = await _tracksRepository.fetchYtVideoInfo(event.link);
    } catch (e) {
      emit(LinkInputErrorState());
      return;
    }

    emit(
      InfoState(event.link, videoInfo?.artist ?? '', videoInfo?.title ?? ''),
    );
  }

  FutureOr<void> _onInfoChecked(
    InfoChecked event,
    Emitter<TrackUploadingState> emit,
  ) async {
    emit(UploadingStartedState());

    try {
      await _tracksRepository.uploadYtTrack(
        event.url,
        event.artist,
        event.title,
      );

      if (currentUploadingLink != event.url) {
        return; // when we are already uploading this track
      }

      emit(SuccessfulUploadState());

      await _tracksRepository.getAllTracks();
    } catch (e) {
      emit(ErrorState());
      logger.e('Error uploading track: $e');
    }
  }
}
