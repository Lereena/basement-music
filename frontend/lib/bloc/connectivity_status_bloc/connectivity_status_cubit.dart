import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../playlists_bloc/playlists_bloc.dart';
import '../playlists_bloc/playlists_event.dart';
import '../tracks_bloc/tracks_bloc.dart';
import '../tracks_bloc/tracks_event.dart';

part 'connectivity_status_state.dart';

class ConnectivityStatusCubit extends Cubit<ConnectivityStatusState> {
  final TracksBloc tracksBloc;
  final PlaylistsBloc playlistsBloc;

  final _connectivity = Connectivity();

  ConnectivityStatusCubit({
    required this.tracksBloc,
    required this.playlistsBloc,
  }) : super(ConnectivityStatusInitial()) {
    _checkInitialStatus().then(
      (_) => _connectivity.onConnectivityChanged.listen(_emitState),
    );
  }

  Future<void> _checkInitialStatus() async {
    final connectivityResult = await _connectivity.checkConnectivity();

    _emitState(connectivityResult);
  }

  void _emitState(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      emit(NoConnectionState());
    } else {
      emit(HasConnectionState());
      _updateAll();
    }
  }

  void _updateAll() {
    tracksBloc.add(TracksLoadEvent());
    playlistsBloc.add(PlaylistsLoadEvent());
  }
}
