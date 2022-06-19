import 'stub/stub.dart' if (dart.library.io) 'stub/stub_io.dart' if (dart.library.html) 'stub/stub_web.dart';

import 'package:basement_music/api.dart';
import 'package:basement_music/pages_enum.dart';
import 'package:basement_music/widgets/bottom_bar.dart';
import 'package:basement_music/bloc/player_bloc.dart';
import 'package:basement_music/widgets/main_content.dart';
import 'package:basement_music/widgets/side_navigation.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
      home: ContextMenuOverlay(
        child: MyHomePage(title: 'Basement music'),
      ),
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
  var channel = WebSocketChannel.connect(Uri.parse(wshost));

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      preventDefault();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlayerBloc>(
      create: (context) => PlayerBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          // title: StreamBuilder(
          // stream: channel.stream,
          // builder: (context, snapshot) {
          // return Text('${snapshot.data}');
          // }),
        ),
        body: kIsWeb
            ? Row(
                children: [
                  SideNavigation(
                    onDestinationSelected: (index) => setState(() => selectedPage = PageNavigation.values[index]),
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
        bottomNavigationBar: BottomBar(),
      ),
    );
  }

  void _sendMessage() {
    channel.sink.add('hello');
  }
}
