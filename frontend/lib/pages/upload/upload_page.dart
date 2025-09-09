import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import '../../widgets/app_bar.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasementAppBar(title: 'Upload new track'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.go(RouteName.uploadFromDevice),
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text('Upload from device'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.go(RouteName.uploadFromYoutube),
              icon: const Icon(Icons.smart_display_rounded),
              label: const Text('Extract from YouTube video'),
            ),
          ],
        ),
      ),
    );
  }
}
