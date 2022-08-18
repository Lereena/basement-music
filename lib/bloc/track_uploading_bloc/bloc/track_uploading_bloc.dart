import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youtube_metadata/youtube_metadata.dart';

import '../../../interactors/track_interactor.dart';

part 'track_uploading_event.dart';
part 'track_uploading_state.dart';

class TrackUploadingBloc extends Bloc<TrackUploadingEvent, TrackUploadingState> {
  TrackUploadingBloc() : super(LinkInputState()) {
    on<Start>(_onStart);
    on<LinkEntered>(_onLinkEntered);
    on<InfoChecked>(_onInfoChecked);
  }

  FutureOr<void> _onStart(Start event, Emitter<TrackUploadingState> emit) {
    emit(LinkInputState());
  }

  FutureOr<void> _onLinkEntered(LinkEntered event, Emitter<TrackUploadingState> emit) async {
    if (event.link.isEmpty) {
      emit(LinkInputErrorState());
      return;
    }

    emit(LoadingState());

    late MetaDataModel metadata;
    try {
      metadata = await YoutubeMetaData.getData(event.link);
    } catch (e) {
      emit(LinkInputErrorState());
      return;
    }

    final splitTitle = metadata.title!.split(RegExp('[−‐‑-ー一-]'));
    var artist = '';
    var title = '';
    if (splitTitle.length < 2) {
      artist = metadata.authorName?.trim() ?? '';
      title = splitTitle[0].trim();
    } else {
      artist = splitTitle[0].trim();
      title = splitTitle[1].trim();
    }

    emit(InfoState(event.link, artist, title));
  }

  FutureOr<void> _onInfoChecked(InfoChecked event, Emitter<TrackUploadingState> emit) async {
    if (event.artist.isEmpty) {
      emit(InfoInputErrorState()); // TODO: propagate error text
      return;
    }
    if (event.title.isEmpty) {
      emit(InfoInputErrorState()); // TODO: propagate error text
      return;
    }

    emit(UploadingStartedState());

    final result = await uploadYtTrack(event.url, event.artist, event.title);

    if (result) {
      emit(SuccessfulUploadState());
    } else {
      emit(ErrorState());
    }
  }
}
