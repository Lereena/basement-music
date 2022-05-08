import 'package:basement_music/bottom_bar.dart';
import 'package:basement_music/bloc/player_bloc.dart';
import 'package:basement_music/track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'library.dart';

void main() {
  runApp(BasementMusic());
}

class BasementMusic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlayerBloc>(
      create: (context) => PlayerBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.separated(
          separatorBuilder: (context, _) => Divider(),
          itemCount: tracks.length,
          itemBuilder: (context, index) => TrackCard(track: tracks[index]),
        ),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
