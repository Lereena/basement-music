import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/video_info.dart';
import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_extractor_cubit.freezed.dart';
part 'youtube_extractor_state.dart';

class YoutubeExtractorCubit extends Cubit<YoutubeExtractorState> {
  final TracksRepository _tracksRepository;

  String currentUploadingLink = '';

  YoutubeExtractorCubit(this._tracksRepository) : super(const YoutubeExtractorState.linkInputInProgress());

  void start({String? url}) {
    emit(YoutubeExtractorState.linkInputInProgress(url: url));
    currentUploadingLink = url ?? '';
  }

  Future<void> enterLink(String link) async {
    if (link.isEmpty) {
      emit(const YoutubeExtractorState.linkInputError());
      return;
    }

    emit(const YoutubeExtractorState.loadInProgress());
    currentUploadingLink = link;

    late VideoInfo? videoInfo;
    try {
      videoInfo = await _tracksRepository.fetchYtVideoInfo(link);
    } catch (e) {
      emit(const YoutubeExtractorState.linkInputError());
      return;
    }

    emit(YoutubeExtractorState.infoObserve(url: link, artist: videoInfo?.artist ?? '', title: videoInfo?.title ?? ''));
  }

  Future<void> checkInfo(String url, String artist, String title) async {
    emit(const YoutubeExtractorState.extractInProgress());

    try {
      await _tracksRepository.uploadYtTrack(url, artist, title);

      if (currentUploadingLink != url) return;

      emit(const YoutubeExtractorState.extractSuccess());
      await _tracksRepository.getAllTracks();
    } catch (e) {
      emit(const YoutubeExtractorState.extractError());
      logger.e('Error extracting track from Youtube: $e');
    }
  }
}
