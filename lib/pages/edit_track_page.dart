import 'package:flutter/material.dart';

import '../library.dart';
import '../models/track.dart';
import '../widgets/dialog.dart';

class EditTrackPage extends StatefulWidget {
  final Widget? titleText;
  final Track track;

  EditTrackPage({Key? key, this.titleText, required this.track}) : super(key: key);

  @override
  State<EditTrackPage> createState() => _EditTrackPageState();
}

const _textStyle = const TextStyle(fontSize: 18);

class _EditTrackPageState extends State<EditTrackPage> {
  final titleController = TextEditingController();
  final artistController = TextEditingController();
  var loading = false;
  var resultText = '';

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
        : resultText == ''
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    widget.titleText ?? Container(),
                    Text(
                      'Please check track info and edit if needed',
                      style: TextStyle(fontSize: 24),
                    ),
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
                          loading = true;

                          final title = titleController.text == widget.track.title ? '' : titleController.text;
                          final artist = artistController.text == widget.track.artist ? '' : artistController.text;
                          final result = await editTrack(widget.track.id, artist: artist, title: title);
                          setState(() => resultText = _resultText(result));

                          await showDialog(
                              context: context,
                              builder: (_) {
                                return CustomDialog(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        result
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 30,
                                              )
                                            : const Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                        SizedBox(height: 20),
                                        Text(
                                          resultText,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                          loading = false;
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Text(resultText);
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

  String _resultText(bool result) {
    if (result) {
      return "Track info successfully updated";
    } else {
      return "Track info was not updated, please try again later";
    }
  }
}
