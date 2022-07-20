import 'package:basement_music/stub/stub.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../api.dart';
import '../bloc/player_bloc.dart';
import '../pages_enum.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/main_content.dart';
import '../widgets/navigations/side_navigation_drawer.dart';
import '../widgets/navigations/side_navigation_rail.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedPage = PageNavigation.AllTracks;
  var channel = WebSocketChannel.connect(Uri.parse(wshost));

  @override
  void initState() {
    super.initState();

    if (kIsWeb) preventDefault();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlayerBloc>(
      create: (context) => PlayerBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: kIsWeb
            ? Row(
                children: [
                  SideNavigationRail(
                    onDestinationSelected: (index) => setState(
                      () => selectedPage = PageNavigation.values[index],
                    ),
                  ),
                  VerticalDivider(width: 1),
                  MainContent(selectedPage: selectedPage),
                ],
              )
            : Column(
                children: [
                  MainContent(selectedPage: selectedPage),
                ],
              ),
        drawer: kIsWeb
            ? null
            : SideNavigationDrawer(
                selected: PageNavigation.values.indexOf(selectedPage),
                onDestinationSelected: (index) {
                  setState(() => selectedPage = PageNavigation.values[index]);
                  Navigator.of(context).pop();
                },
              ),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }

  void _sendMessage() {
    channel.sink.add('hello');
  }
}
