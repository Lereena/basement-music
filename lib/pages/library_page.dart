import 'package:basement_music/interactors/playlist_interactor.dart';
import 'package:basement_music/library.dart';
import 'package:flutter/material.dart';

import '../widgets/playlist_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  var loading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchAllPlaylists();
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Expanded(child: Center(child: CircularProgressIndicator()));

    if (playlists.isEmpty)
      return Expanded(
        child: Center(
          child: Text(
            'No playlists',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );

    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) => PlaylistCard(playlist: playlists[index]),
          separatorBuilder: (context, _) => Divider(height: 1),
          itemCount: playlists.length),
    );
  }
}
