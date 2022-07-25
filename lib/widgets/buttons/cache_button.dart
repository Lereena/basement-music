import 'package:flutter/material.dart';

import '../../cacher/cacher.dart';
import '../../models/track.dart';

class CacheButton extends StatefulWidget {
  final List<Track> listToCache;

  const CacheButton({Key? key, required this.listToCache}) : super(key: key);

  @override
  State<CacheButton> createState() => _CacheButtonState();
}

class _CacheButtonState extends State<CacheButton> {
  var caching = false;

  late List<Track> notCachedTracks;
  late bool allCached;

  @override
  void initState() {
    super.initState();

    notCachedTracks = widget.listToCache.where((track) => !cacher.isCached(track.id)).toList();
    allCached = notCachedTracks.length == 0;
  }

  @override
  Widget build(BuildContext context) {
    final title = allCached
        ? 'Do you want to remove all playlist tracks from cache?'
        : 'Do you want to cache all playlist tracks?';

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: caching
            ? loadingInidcator
            : Icon(
                allCached ? Icons.file_download_off_rounded : Icons.download_outlined,
              ),
      ),
      onTap: caching
          ? null
          : () async {
              final result = await showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(title),
                  children: [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              );

              if (result) {
                setState(() => caching = true);

                notCachedTracks.forEach((track) async {
                  await cacher.startCaching(track.id);
                  notCachedTracks.remove(track);
                });

                setState(() => caching = false);
              }
            },
    );
  }

  Widget get loadingInidcator {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          allCached ? Icons.file_download_off_rounded : Icons.download_outlined,
        ),
        CircularProgressIndicator(
          color: Theme.of(context).shadowColor,
        )
      ],
    );
  }
}
