import 'package:flutter/material.dart';

import '../interactors/playlist_interactor.dart';
import '../utils/input_field_with.dart';
import 'dialogs/status_dialog.dart';
import 'titled_field.dart';

class AddPlaylist extends StatefulWidget {
  const AddPlaylist({Key? key}) : super(key: key);

  @override
  State<AddPlaylist> createState() => _AddPlaylistState();
}

const _textStyle = const TextStyle(fontSize: 18);

class _AddPlaylistState extends State<AddPlaylist> {
  final titleController = TextEditingController();
  final fieldFocusNode = FocusNode();
  var loading = false;
  var error = '';

  @override
  void initState() {
    super.initState();

    fieldFocusNode.requestFocus();

    titleController.addListener(() {
      setState(() {
        error = '';
      });
    });
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
              Text(
                'Create new playlist',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TitledField(
                title: 'Title: ',
                controller: titleController,
                fieldWidth: inputFieldWidth(context),
                focusNode: fieldFocusNode,
                onSubmitted: (_) async => _onSubmitted(),
              ),
              const SizedBox(height: 20),
              if (error.isEmpty)
                const SizedBox(height: 20)
              else
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    'Create',
                    style: _textStyle,
                  ),
                  onPressed: () async => _onSubmitted(),
                ),
              ),
            ],
          );
  }

  bool _isValidInput(String title) {
    return title.isNotEmpty;
  }

  void _onSubmitted() async {
    if (!_isValidInput(titleController.text)) {
      setState(() {
        error = 'Title must not be empty';
        fieldFocusNode.requestFocus();
      });
      return;
    }

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
  }
}
