import 'package:basement_music/theme/config.dart';
import 'package:basement_music/theme/custom_theme.dart';
import 'package:basement_music/widgets/navigations/side_navigation_drawer.dart';

import 'pages/settings_page.dart';
import 'stub/stub.dart' if (dart.library.io) 'stub/stub_io.dart' if (dart.library.html) 'stub/stub_web.dart';

import 'package:basement_music/api.dart';
import 'package:basement_music/pages_enum.dart';
import 'package:basement_music/widgets/bottom_bar.dart';
import 'package:basement_music/bloc/player_bloc.dart';
import 'package:basement_music/widgets/main_content.dart';
import 'package:basement_music/widgets/navigations/side_navigation_rail.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(BasementMusic());
}

class BasementMusic extends StatefulWidget {
  @override
  State<BasementMusic> createState() => _BasementMusicState();
}

class _BasementMusicState extends State<BasementMusic> {
  @override
  void initState() {
    super.initState();

    currentTheme.initTheme();

    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basement music',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentThemeMode,
      initialRoute: '/',
      routes: {
        '/settings': (context) => SettingsPage(),
      },
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
