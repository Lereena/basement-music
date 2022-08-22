import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../api.dart';
import '../enums/pages_enum.dart';
import '../routes.dart';
import '../widgets/add_playlist.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/dialog.dart';
import '../widgets/main_content.dart';
import '../widgets/navigations/side_navigation_drawer.dart';
import '../widgets/navigations/side_navigation_rail.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageNavigation selectedPage = PageNavigation.allTracks;
  WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(wshost));

  final pagesWithFAB = [PageNavigation.allTracks, PageNavigation.library];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: kIsWeb
          ? Row(
              children: [
                SideNavigationRail(
                  onDestinationSelected: (index) => setState(
                    () => selectedPage = PageNavigation.values[index],
                  ),
                ),
                const VerticalDivider(width: 1),
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
      floatingActionButton: pagesWithFAB.contains(selectedPage)
          ? FloatingActionButton(
              onPressed: () => _fabActionByPage(selectedPage)(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Function _fabActionByPage(PageNavigation page) {
    switch (page) {
      case PageNavigation.allTracks:
        return () => Navigator.pushNamed(context, NavigationRoute.upload.name);
      case PageNavigation.library:
        return () => showDialog(
              context: context,
              builder: (context) => const CustomDialog(child: AddPlaylist()),
            );
      default:
        throw Exception('No action for $page');
    }
  }
}
