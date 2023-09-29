import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/navigation_cubit/navigation_cubit.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () => navigationCubit.navigateUploadTrackFromDevice(),
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Upload from device'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => navigationCubit.navigateUploadTrackFromYoutube(),
            icon: const Icon(Icons.smart_display_rounded),
            label: const Text('Extract from YouTube video'),
          ),
        ],
      ),
    );
  }
}
