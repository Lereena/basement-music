import 'package:flutter/material.dart';

import '../interactors/playlist_interactor.dart';
import 'dialogs/status_dialog.dart';

class AddPlaylist extends StatefulWidget {
  const AddPlaylist({Key? key}) : super(key: key);

  @override
  State<AddPlaylist> createState() => _AddPlaylistState();
}

const _textStyle = const TextStyle(fontSize: 18);

class _AddPlaylistState extends State<AddPlaylist> {
  final titleController = TextEditingController();
  var loading = false;

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
              Text(
                'Create new playlist',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              _titledField('Title: ', titleController, inputFieldWidth),
              SizedBox(height: 20),
              Container(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    'Create',
                    style: _textStyle,
                  ),
                  onPressed: () async {
                    if (!_isValidInput(titleController.text)) return;

                    setState(() => loading = true);

                    final requestResult = await createPlaylist(titleController.text);
                    setState(() => loading = false);
                    Navigator.pop(context);

                    await showDialog(
                      context: context,
                      builder: (_) => StatusDialog(
                        success: requestResult.result,
                        text: requestResult.result
                            ? 'Playlist was successfully created'
                            : 'Playlist was not created, please try again later',
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }

  bool _isValidInput(String title) {
    return title.isNotEmpty;
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
