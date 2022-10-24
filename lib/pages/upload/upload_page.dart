import 'package:basement_music/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/track_uploading_bloc/track_uploading_bloc.dart';
import 'youtube/extract_from_youtube.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

enum UploadSource { local, youtube, unknown }

class _UploadPageState extends State<UploadPage> {
  late final TrackUploadingBloc trackUploadingBloc;

  @override
  void initState() {
    super.initState();
    trackUploadingBloc = BlocProvider.of<TrackUploadingBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload track'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            trackUploadingBloc.add(Start());
            Navigator.pop(context);
          },
        ),
      ),
      body: ExtractFromYoutube(trackUploadingBloc: trackUploadingBloc),
      bottomNavigationBar: BottomBar(),
    );
  }
}
