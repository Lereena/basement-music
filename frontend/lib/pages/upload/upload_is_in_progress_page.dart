import 'package:flutter/material.dart';

class UploadIsInProgressPage extends StatelessWidget {
  final void Function() onUploadOtherTrack;

  const UploadIsInProgressPage({super.key, required this.onUploadOtherTrack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Text(
              'You can leave this page, the uploading will continue',
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          FilledButton(
            autofocus: true,
            onPressed: onUploadOtherTrack,
            child: const Text('Upload other track'),
          ),
        ],
      ),
    );
  }
}
