import 'package:basement_music/pages_enum.dart';
import 'package:basement_music/widgets/bottom_bar.dart';
import 'package:basement_music/bloc/player_bloc.dart';
import 'package:basement_music/widgets/side_navigation.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:basement_music/widgets/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'library.dart';
import 'models/track.dart';

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
  var selectedPage = PageNavigation.Favourites;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlayerBloc>(
      create: (context) => PlayerBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Row(
          children: [
            SideNavigation(
              onDestinationSelected: (index) => setState(() => selectedPage = PageNavigation.values[index]),
            ),
            VerticalDivider(width: 1),
            if (selectedPage == PageNavigation.Favourites)
              FutureBuilder<List<Track>>(
                future: fetchAllTracks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, _) => Divider(height: 1),
                        itemCount: tracks.length,
                        itemBuilder: (context, index) => TrackCard(track: tracks[index]),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            if (selectedPage == PageNavigation.Upload) UploadPage(),
          ],
        ),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
