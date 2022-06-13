import 'package:basement_music/widgets/dialogs/track_update_status_dialog.dart';
import 'package:flutter/material.dart';

import '../library.dart';
import '../models/track.dart';

class EditTrack extends StatefulWidget {
  final Widget? titleText;
  final Track track;

  EditTrack({
    Key? key,
    this.titleText,
    required this.track,
  }) : super(key: key);

  @override
  State<EditTrack> createState() => _EditTrackState();
}

const _textStyle = const TextStyle(fontSize: 18);

class _EditTrackState extends State<EditTrack> {
  final titleController = TextEditingController();
  final artistController = TextEditingController();
  var loading = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.track.title;
    artistController.text = widget.track.artist;
  }

  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = MediaQuery.of(context).size.width / 2;

    return loading
        ? CircularProgressIndicator()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.titleText ?? Container(),
              SizedBox(height: 20),
              _titledField('Title:', titleController, inputFieldWidth),
              SizedBox(height: 20),
              _titledField('Artist:', artistController, inputFieldWidth),
              SizedBox(height: 40),
              Container(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    'Submit',
                    style: _textStyle,
                  ),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });

                    final title = titleController.text == widget.track.title ? '' : titleController.text;
                    final artist = artistController.text == widget.track.artist ? '' : artistController.text;
                    final result = await editTrack(widget.track.id, artist: artist, title: title);
                    setState(() {
                      loading = false;
                    });

                    await showDialog(context: context, builder: (_) => TrackUpdateStatusDialog(success: result));

                    // await Future.delayed(Duration(seconds: 2));
                  },
                ),
              ),
            ],
          );
  }

  Widget _titledField(String title, TextEditingController controller, double fieldWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: _textStyle,
        ),
        SizedBox(width: 5),
        Container(
          width: fieldWidth,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.start,
            style: _textStyle,
          ),
        ),
      ],
    );
  }
}
