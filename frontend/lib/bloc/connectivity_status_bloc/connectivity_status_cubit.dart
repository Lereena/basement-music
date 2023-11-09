import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../repositories/connectivity_status_repository.dart';

part 'connectivity_status_state.dart';

class ConnectivityStatusCubit extends Cubit<ConnectivityStatusState> {
  final ConnectivityStatusRepository connectivityStatusRepository;

  ConnectivityStatusCubit({
    required this.connectivityStatusRepository,
  }) : super(ConnectivityStatusInitial()) {
    if (kIsWeb) {
      emit(ConnectivityStatusHasConnection());
    }

    connectivityStatusRepository.statusSubject.listen(_emitStatus);
  }

  void _emitStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      emit(ConnectivityStatusNoConnection());
    } else {
      emit(ConnectivityStatusHasConnection());
    }
  }
}
