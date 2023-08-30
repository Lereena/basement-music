import 'package:flutter/material.dart';

import '../../../widgets/buttons/styled_button.dart';
import '../../../widgets/icons/error_icon.dart';
import '../../../widgets/icons/success_icon.dart';

class ResultPage extends StatelessWidget {
  final bool result;
  final Function() onUploadOtherTrackPress;

  const ResultPage({
    super.key,
    required this.result,
    required this.onUploadOtherTrackPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (result) SuccessIcon() else ErrorIcon(),
        const SizedBox(height: 20),
        if (result)
          Text(
            'Track was successfully uploaded',
            style: Theme.of(context).textTheme.titleLarge,
          )
        else
          Text(
            'Track uploading is failed, please try again later',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        const SizedBox(height: 20),
        StyledButton(
          title: 'Upload other track',
          onPressed: onUploadOtherTrackPress,
          autofocus: true,
        ),
      ],
    );
  }
}
