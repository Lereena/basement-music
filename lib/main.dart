import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';

import 'models/track.dart';

void main() {
  runApp(BasementMusic());
}

class BasementMusic extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // audioManager.
    return MaterialApp(
      title: 'Basement music',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Basement music'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Track> tracks = [
    Track(url: '', title: "Track 1", artist: "Artist 1"),
    Track(url: '', title: "Track 2", artist: "Artist 2"),
    Track(url: '', title: "Track 3", artist: "Artist 3"),
  ];
  final audioManager = AudioManager.instance;

  @override
  void initState() {
    super.initState();
    audioManager.start(
      "file://assets/AnotherMedium.mp3",
      "Another Medium",
      desc: "",
      cover: "",
    );
    AudioManager.instance.playOrPause();
    AudioManager.instance.onEvents((events, args) {
      print("$events, $args");
    });
  }

  void setupAudio() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            return Container(
              child: Text(tracks[index].title),
            );
          },
        ),
      ),
    );
  }
}
