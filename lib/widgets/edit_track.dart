import 'package:basement_music/widgets/dialogs/status_dialog.dart';
import 'package:flutter/material.dart';

import '../interactors/track_interactor.dart';
import '../models/track.dart';
import '../utils/input_field_with.dart';

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
    return loading
        ? CircularProgressIndicator()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.titleText ?? Container(),
              SizedBox(height: 20),
              _titledField(
                'Title:',
                titleController,
                inputFieldWidth(context),
              ),
              SizedBox(height: 20),
              _titledField(
                'Artist:',
                artistController,
                inputFieldWidth(context),
              ),
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

                    await showDialog(
                      context: context,
                      builder: (_) => StatusDialog(
                        success: result,
                        text: result
                            ? 'Track info successfully updated'
                            : 'Track info was not updated, please try again later',
                      ),
                    );
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
