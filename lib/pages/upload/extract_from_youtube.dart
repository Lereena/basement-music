import 'dart:math';

import 'package:basement_music/widgets/buttons/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:youtube_metadata/youtube_metadata.dart';

import '../../interactors/track_interactor.dart';

class ExtractFromYoutube extends StatefulWidget {
  ExtractFromYoutube() : super();

  @override
  State<ExtractFromYoutube> createState() => _ExtractFromYoutubeState();
}

enum ExtractingStage { link, info, result }

class _ExtractFromYoutubeState extends State<ExtractFromYoutube> {
  final linkController = TextEditingController();
  final titleController = TextEditingController();
  final artistController = TextEditingController();

  var thumbnail = '';
  var stage = ExtractingStage.link;
  var fetchingInfo = false;
  var result = true;

  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = min(MediaQuery.of(context).size.width / 1.5, 400).toDouble();

    if (fetchingInfo) {
      return Center(child: CircularProgressIndicator());
    }

    if (stage == ExtractingStage.link) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Insert YouTube link to extract audio',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            width: inputFieldWidth,
            child: TextField(
              controller: linkController,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(height: 40),
          StyledButton(
            title: 'Extract',
            onPressed: _fetchTrackInfo,
          ),
        ],
      );
    }

    if (stage == ExtractingStage.info) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Please check track info and change if incorrect'),
          const SizedBox(height: 20),
          _titledField('Artist', artistController, inputFieldWidth),
          const SizedBox(height: 20),
          _titledField('Title', titleController, inputFieldWidth),
          const SizedBox(height: 20),
          if (thumbnail.isNotEmpty) Image.network(thumbnail),
          StyledButton(title: 'Upload', onPressed: _uploadTrack),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        result
            ? Text('Track uploading is successfully started')
            : Text('Track uploading is failed, please try again later'),
        const SizedBox(height: 20),
        StyledButton(
            title: 'Upload other track',
            onPressed: () {
              setState(() => stage = ExtractingStage.link);
            }),
      ],
    );
  }

  void _fetchTrackInfo() async {
    setState(() => fetchingInfo = true);

    final metadata = await YoutubeMetaData.getData(linkController.text);
    if (metadata.title == null) return;

    final splitTitle = metadata.title!.split(RegExp('[−‐‑-ー一-]'));
    if (splitTitle.length < 2) {
      artistController.text = metadata.authorName ?? '';
      titleController.text = splitTitle[0];
    } else {
      artistController.text = splitTitle[0];
      titleController.text = splitTitle[1];
    }

    thumbnail = metadata.thumbnailUrl ?? '';

    setState(() {
      stage = ExtractingStage.info;
      fetchingInfo = false;
    });
  }

  void _uploadTrack() async {
    setState(() => fetchingInfo = true);

    result = await uploadTrack(linkController.text);

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

  Widget _titledField(String title, TextEditingController controller, double fieldWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
        ),
        SizedBox(width: 10),
        Container(
          width: fieldWidth,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
