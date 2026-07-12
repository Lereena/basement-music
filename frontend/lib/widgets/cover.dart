import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/utils/image_url.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _placeholderAsset = 'assets/cover_placeholder.png';

/// Renders a track cover: server paths ('/api/track/{id}/cover',
/// '/api/album/{id}/image') are fetched over the network, asset paths and
/// empty covers fall back to the bundled placeholder.
class Cover extends StatelessWidget {
  final String cover;

  /// Track's updatedAt — appended as a version query to bust image caches
  /// when the cover bytes change on the server.
  final String? version;
  final Widget? overlay;
  final double size;

  const Cover({super.key, required this.cover, this.version, this.overlay, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _image(context),
        if (overlay != null)
          Container(color: Theme.of(context).shadowColor.withValues(alpha: 0.2), width: size, height: size),
        overlay ?? const SizedBox.shrink(),
      ],
    );
  }

  Widget _image(BuildContext context) {
    if (cover.isEmpty || cover.startsWith('assets/')) {
      return Image.asset(cover.isEmpty ? _placeholderAsset : cover, width: size, height: size);
    }

    final baseUrl = context.read<AudioPlayerHandler>().appConfig.baseUrl;
    return CachedNetworkImage(
      imageUrl: imageUrlWithVersion(cover, baseUrl, version)!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorWidget: (_, _, _) => Image.asset(_placeholderAsset, width: size, height: size),
    );
  }
}
