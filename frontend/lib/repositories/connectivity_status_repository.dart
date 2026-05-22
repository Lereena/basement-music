import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityStatusRepository {
  BehaviorSubject<List<ConnectivityResult>> statusSubject =
      BehaviorSubject.seeded([ConnectivityResult.wifi]);

  ConnectivityStatusRepository() {
    Connectivity().onConnectivityChanged.listen(_checkStatus);
  }

  void _checkStatus(List<ConnectivityResult> results) {
    statusSubject.add(results);
  }
}
