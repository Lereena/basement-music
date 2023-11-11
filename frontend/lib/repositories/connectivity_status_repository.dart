import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityStatusRepository {
  BehaviorSubject<ConnectivityResult> statusSubject =
      BehaviorSubject.seeded(ConnectivityResult.wifi);

  ConnectivityStatusRepository() {
    Connectivity().onConnectivityChanged.listen(_checkStatus);
  }

  void _checkStatus(ConnectivityResult connectivityResult) {
    statusSubject.add(connectivityResult);
  }
}
