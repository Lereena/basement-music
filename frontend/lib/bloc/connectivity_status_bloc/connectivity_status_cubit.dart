import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'connectivity_status_state.dart';

class ConnectivityStatusCubit extends Cubit<ConnectivityStatusState> {
  final _connectivity = Connectivity();

  ConnectivityStatusCubit() : super(ConnectivityStatusInitial()) {
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
    }
  }
}
