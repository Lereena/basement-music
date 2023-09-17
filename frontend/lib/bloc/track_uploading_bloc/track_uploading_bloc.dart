import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youtube_metadata/youtube_metadata.dart';

import '../../repositories/tracks_repository.dart';
import '../../utils/track_data.dart';

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

    late MetaDataModel metadata;
    try {
      metadata = await YoutubeMetaData.getData(event.link);
    } catch (e) {
      emit(LinkInputErrorState());
      return;
    }

    var (artist, title) = getArtistAndTitle(metadata.title);

    artist ??= metadata.authorName?.trim() ?? '';

    emit(InfoState(event.link, artist, title));
  }

  FutureOr<void> _onInfoChecked(
    InfoChecked event,
    Emitter<TrackUploadingState> emit,
  ) async {
    if (event.artist.isEmpty) {
      emit(InfoInputErrorState()); // TODO: propagate error text
      return;
    }
    if (event.title.isEmpty) {
      emit(InfoInputErrorState()); // TODO: propagate error text
      return;
    }

    emit(UploadingStartedState());

    final result = await _tracksRepository.uploadYtTrack(
      event.url,
      event.artist,
      event.title,
    );

    if (currentUploadingLink != event.url) {
      return; // when we are already uploading other track
    }

    if (result) {
      emit(SuccessfulUploadState());
    } else {
      emit(ErrorState());
    }
  }
}
