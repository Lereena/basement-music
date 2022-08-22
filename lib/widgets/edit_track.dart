import 'package:basement_music/widgets/buttons/styled_button.dart';
import 'package:basement_music/widgets/dialogs/status_dialog.dart';
import 'package:flutter/material.dart';

import '../interactors/track_interactor.dart';
import '../models/track.dart';
import '../utils/input_field_with.dart';
import 'titled_field.dart';

class EditTrack extends StatefulWidget {
  final Widget? titleText;
  final Track track;

  const EditTrack({
    Key? key,
    this.titleText,
    required this.track,
  }) : super(key: key);

  @override
  State<EditTrack> createState() => _EditTrackState();
}

class _EditTrackState extends State<EditTrack> {
  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final titleFocusNode = FocusNode();
  final artistFocusNode = FocusNode();

  var _loading = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.track.title;
    artistController.text = widget.track.artist;
    artistFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.titleText ?? Container(),
              const SizedBox(height: 20),
              TitledField(
                title: 'Artist:',
                focusNode: artistFocusNode,
                controller: artistController,
                fieldWidth: inputFieldWidth(context),
                onSubmitted: (_) => titleFocusNode.requestFocus(),
              ),
              const SizedBox(height: 20),
              TitledField(
                title: 'Title:',
                focusNode: titleFocusNode,
                controller: titleController,
                fieldWidth: inputFieldWidth(context),
                onSubmitted: (_) => _onSubmit(),
              ),
              const SizedBox(height: 40),
              StyledButton(title: 'Submit', onPressed: _onSubmit),
            ],
          );
  }

  Future<void> _onSubmit() async {
    setState(() {
      _loading = true;
    });

    final title = titleController.text == widget.track.title ? '' : titleController.text;
    final artist = artistController.text == widget.track.artist ? '' : artistController.text;
    final result = await editTrack(widget.track.id, artist: artist, title: title);
    setState(() {
      _loading = false;
    });

    await showDialog(
      context: context,
      builder: (_) => StatusDialog(
        success: result,
        text: result ? 'Track info successfully updated' : 'Track info was not updated, please try again later',
      ),
    );
  }
}
