import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/playlists_bloc/playlists_bloc.dart';
import '../bloc/trackst_search_cubit/tracks_search_cubit.dart';
import '../models/playlist.dart';
import '../widgets/search_field.dart';
import '../widgets/track_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  late final TracksSearchCubit _searchCubit;
  late final PlaylistsBloc _playlistsBloc;

  @override
  void initState() {
    super.initState();

    _focusNode.requestFocus();
    _searchCubit = BlocProvider.of<TracksSearchCubit>(context);
    _playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    _controller.text = _searchCubit.state.searchQuery;
    _playlistsBloc.openedPlaylist = _searchCubit.searchResultsPlaylist;
  }

  @override
  void dispose() {
    super.dispose();
    _playlistsBloc.openedPlaylist = Playlist.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kIsWeb ? const EdgeInsets.only(top: 60) : EdgeInsets.zero,
      child: Column(
        children: [
          SearchField(
            controller: _controller,
            focusNode: _focusNode,
            onSearch: (query) => _searchCubit.onSearch(query),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: BlocBuilder<TracksSearchCubit, TracksSearchState>(
              builder: (context, state) {
                if (state is TracksSearchLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TracksSearchEmptyState) {
                  return const Center(child: Text('No tracks found', style: TextStyle(fontSize: 24)));
                }

                if (state is TracksSearchLoadedState) {
                  return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, _) => const Divider(height: 1),
                    itemCount: state.tracks.length,
                    itemBuilder: (context, index) => TrackCard(
                      track: state.tracks[index],
                      openedPlaylist: _playlistsBloc.openedPlaylist,
                    ),
                  );
                }

                if (state is TracksSearchErrorState) {
                  return const Center(child: Text('Error searching tracks'));
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
