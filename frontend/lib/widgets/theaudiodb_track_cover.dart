import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/track.dart';
import '../repositories/theaudiodb_repository.dart';

/// Loads a [TheAudioDB](https://www.theaudiodb.com/free_music_api) track thumb when the
/// search result approximately matches [track] title and artist; otherwise shows [fallbackAsset].
class TheAudioDbTrackCover extends StatefulWidget {
  const TheAudioDbTrackCover({
    super.key,
    required this.track,
    required this.width,
    required this.height,
    required this.imageSize,
    this.fallbackAsset,
    this.overlay,
  });

  final Track track;
  final double width;
  final double height;
  final TheAudioDbImageSize imageSize;
  final String? fallbackAsset;
  final Widget? overlay;

  @override
  State<TheAudioDbTrackCover> createState() => _TheAudioDbTrackCoverState();
}

class _TheAudioDbTrackCoverState extends State<TheAudioDbTrackCover> {
  Future<String?>? _urlFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _urlFuture ??= context.read<TheAudioDbRepository>().resolveSizedCoverUrl(
          widget.track,
          size: widget.imageSize,
        );
  }

  @override
  Widget build(BuildContext context) {
    final fallback = widget.fallbackAsset ?? widget.track.cover;

    return FutureBuilder<String?>(
      future: _urlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final url = snapshot.data;
        final Widget image = url != null && url.isNotEmpty
            ? Image.network(
                url,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  fallback,
                  width: widget.width,
                  height: widget.height,
                  fit: BoxFit.cover,
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              )
            : Image.asset(
                fallback,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.cover,
              );

        if (widget.overlay == null) {
          return image;
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            image,
            Container(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              width: widget.width,
              height: widget.height,
            ),
            widget.overlay!,
          ],
        );
      },
    );
  }
}
