import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import '../bloc/trackst_search_cubit/tracks_search_cubit.dart';
import '../widgets/app_bar.dart';
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

  late final _searchCubit = context.read<TracksSearchCubit>();

  @override
  void initState() {
    super.initState();

    _focusNode.requestFocus();
    _controller.text = _searchCubit.state.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasementAppBar(title: 'Search tracks'),
      body: Column(
        children: [
          SearchField(
            controller: _controller,
            focusNode: _focusNode,
            onSearch: (query) => _searchCubit.onSearch(query),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: BlocBuilder<TracksSearchCubit, TracksSearchState>(
              builder: (_, state) {
                if (state is TracksSearchLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TracksSearchEmptyState) {
                  return const Center(child: Text('No tracks found'));
                }

                if (state is TracksSearchLoadedState) {
                  return BlocBuilder<ConnectivityStatusCubit,
                      ConnectivityStatusState>(
                    builder: (_, connectivityState) {
                      return ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemCount: state.tracks.length,
                        itemBuilder: (_, index) => TrackCard(
                          track: state.tracks[index],
                          openedPlaylist: _searchCubit.openedPlaylist,
                          active: connectivityState
                              is ConnectivityStatusHasConnection,
                        ),
                      );
                    },
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
