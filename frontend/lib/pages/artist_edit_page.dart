import 'package:basement_music/bloc/artist_edit_cubit/artist_edit_cubit.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/utils/pick_and_crop_image.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/image_picker_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ArtistEditPage extends StatelessWidget {
  final String artistId;

  const ArtistEditPage({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ArtistEditCubit(artistsRepository: context.read<ArtistsRepository>(), artistId: artistId)..startEditing(),
      child: const _ArtistEdit(),
    );
  }
}

class _ArtistEdit extends StatelessWidget {
  const _ArtistEdit();

  Future<void> _pickImage(BuildContext context) async {
    final state = context.read<ArtistEditCubit>().state;
    final picked = await pickAndCropImage(
      context,
      currentImageUrl: state.currentImageUrl,
      currentBytes: state.pickedBytes,
    );
    if (picked == null || !context.mounted) return;
    context.read<ArtistEditCubit>().pickImage(picked.bytes, picked.name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArtistEditCubit, ArtistEditState>(
      listener: (context, state) {
        if (state.saved && context.mounted) context.pop();
        if (state.error && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
        }
      },
      builder: (context, state) {
        if (state.loading || state.saving) {
          return Scaffold(
            appBar: BasementAppBar(title: state.name),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: BasementAppBar(
            title: state.name,
            actions: [IconButton(icon: const Icon(Icons.save), onPressed: () => context.read<ArtistEditCubit>().save())],
          ),
          body: HorizontalSpaceReducer(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 164, maxHeight: 164),
                  child: ImagePickerBox(
                    currentImageUrl: state.currentImageUrl,
                    pickedBytes: state.pickedBytes,
                    onTap: () => _pickImage(context),
                    placeholderIcon: Icons.person,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(label: Text('Name')),
                  initialValue: state.name,
                  onChanged: context.read<ArtistEditCubit>().setName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(label: Text('Description'), border: OutlineInputBorder()),
                  initialValue: state.description,
                  maxLines: 6,
                  minLines: 3,
                  onChanged: context.read<ArtistEditCubit>().setDescription,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
