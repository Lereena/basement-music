import 'package:basement_music/bloc/trackst_search_cubit/tracks_search_cubit.dart';
import 'package:basement_music/widgets/search_field.dart';
import 'package:basement_music/widgets/wrappers/content_narrower.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/track_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  late final TracksSearchCubit searchCubit;

  @override
  void initState() {
    super.initState();

    searchCubit = BlocProvider.of<TracksSearchCubit>(context);
    _controller.text = searchCubit.state.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kIsWeb ? const EdgeInsets.only(top: 60) : EdgeInsets.zero,
      child: ContentNarrower(
        child: Column(
          children: [
            SearchField(
              controller: _controller,
              onSearch: (query) => searchCubit.onSearch(query),
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
      ),
    );
  }
}
