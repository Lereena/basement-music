import 'package:basement_music/models/listen_stats.dart';
import 'package:basement_music/repositories/stats_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'listen_stats_cubit.freezed.dart';
part 'listen_stats_state.dart';

class ListenStatsCubit extends Cubit<ListenStatsState> {
  ListenStatsCubit(this._repo) : super(const ListenStatsState.initial());

  final StatsRepository _repo;

  Future<void> loadPage(int page) async {
    emit(const ListenStatsState.loading());

    try {
      final statsPage = await _repo.fetchListenStats(page);

      emit(ListenStatsState.loaded(page: statsPage));
    } catch (_) {
      emit(const ListenStatsState.error());
    }
  }
}
