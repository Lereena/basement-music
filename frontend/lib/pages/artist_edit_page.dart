import 'dart:typed_data';

import 'package:basement_music/models/artist.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ArtistEditPage extends StatefulWidget {
  final String artistId;

  const ArtistEditPage({super.key, required this.artistId});

  @override
  State<ArtistEditPage> createState() => _ArtistEditPageState();
}

class _ArtistEditPageState extends State<ArtistEditPage> {
  Artist? _artist;
  Uint8List? _imageBytes;
  String? _imageFilename;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadArtist();
  }

  Future<void> _loadArtist() async {
    final artist = await context.read<ArtistsRepository>().getArtist(widget.artistId);
    setState(() {
      _artist = artist;
      _loading = false;
    });
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image, withData: true);
    if (result == null || result.files.isEmpty || result.files.first.bytes == null) return;
    setState(() {
      _imageBytes = result.files.first.bytes;
      _imageFilename = result.files.first.name;
    });
  }

  Future<void> _save() async {
    if (_imageBytes == null) return;
    setState(() => _saving = true);
    final repo = context.read<ArtistsRepository>();
    await repo.updateArtistImage(widget.artistId, _imageBytes!, _imageFilename!);
    await repo.getAllArtists();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _saving) {
      return Scaffold(
        appBar: BasementAppBar(title: _artist?.name ?? ''),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: BasementAppBar(
        title: _artist?.name ?? '',
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _imageBytes != null ? _save : null)],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 164, maxHeight: 164),
          child: _ImagePicker(currentImageUrl: _artist?.image, pickedBytes: _imageBytes, onTap: _pickImage),
        ),
      ),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  final String? currentImageUrl;
  final Uint8List? pickedBytes;
  final VoidCallback onTap;

  const _ImagePicker({required this.currentImageUrl, required this.pickedBytes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (pickedBytes != null)
                Image.memory(pickedBytes!, fit: BoxFit.cover)
              else if (currentImageUrl != null)
                Image.network(currentImageUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => _placeholder(theme))
              else
                _placeholder(theme),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.image_outlined, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) =>
      Container(color: theme.colorScheme.surfaceContainerHighest, child: const Icon(Icons.person, size: 64));
}
