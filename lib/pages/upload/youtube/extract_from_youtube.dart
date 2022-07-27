import 'package:basement_music/pages/upload/youtube/error_page.dart';
import 'package:basement_music/pages/upload/youtube/link_input_page.dart';
import 'package:basement_music/pages/upload/youtube/result_page.dart';
import 'package:basement_music/pages/upload/youtube/track_info_page.dart';
import 'package:flutter/material.dart';
import 'package:youtube_metadata/youtube_metadata.dart';

import '../../../interactors/track_interactor.dart';
import 'extraction_stage.dart';

class ExtractFromYoutube extends StatefulWidget {
  ExtractFromYoutube() : super();

  @override
  State<ExtractFromYoutube> createState() => _ExtractFromYoutubeState();
}

class _ExtractFromYoutubeState extends State<ExtractFromYoutube> {
  final linkController = TextEditingController();
  final titleController = TextEditingController();
  final artistController = TextEditingController();

  var stage = ExtractingStage.link;
  var fetchingInfo = false;
  var result = true;

  @override
  Widget build(BuildContext context) {
    if (fetchingInfo) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You can leave this page, the uploading will continue'),
            SizedBox(height: 40),
            CircularProgressIndicator(),
          ],
        ),
      );
    }

    if (stage == ExtractingStage.link) {
      return LinkInputPage(
        linkController: linkController,
        onFetchPress: _fetchTrackInfo,
      );
    }

    if (stage == ExtractingStage.info) {
      return TrackInfoPage(
        titleController: titleController,
        artistController: artistController,
        onUploadPress: _uploadTrack,
      );
    }

    if (stage == ExtractingStage.error) {
      return ErrorPage(
        onTryAgainPress: () => setState(() => stage = ExtractingStage.link),
      );
    }

    return ResultPage(
      result: result,
      onUploadOtherTrackPress: () => setState(() => stage = ExtractingStage.link),
    );
  }

  void _fetchTrackInfo() async {
    setState(() => fetchingInfo = true);

    late MetaDataModel metadata;
    try {
      metadata = await YoutubeMetaData.getData(linkController.text);
    } catch (e) {
      setState(() {
        stage = ExtractingStage.error;
        fetchingInfo = false;
      });
      return;
    }

    if (metadata.title == null) return;

    final splitTitle = metadata.title!.split(RegExp('[−‐‑-ー一-]'));
    if (splitTitle.length < 2) {
      artistController.text = metadata.authorName?.trim() ?? '';
      titleController.text = splitTitle[0].trim();
    } else {
      artistController.text = splitTitle[0].trim();
      titleController.text = splitTitle[1].trim();
    }

    setState(() {
      stage = ExtractingStage.info;
      fetchingInfo = false;
    });
  }

  void _uploadTrack() async {
    setState(() => fetchingInfo = true);

    result = await uploadYtTrack(linkController.text, artistController.text, titleController.text);

    setState(() {
      _clearControllers();
      stage = ExtractingStage.result;
      fetchingInfo = false;
    });
  }

  void _clearControllers() {
    linkController.text = "";
    artistController.text = "";
    titleController.text = "";
  }
}
