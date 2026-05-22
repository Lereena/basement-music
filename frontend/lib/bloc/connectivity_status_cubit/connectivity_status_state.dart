part of 'connectivity_status_cubit.dart';

@freezed
abstract class ConnectivityStatusState with _$ConnectivityStatusState {
  const factory ConnectivityStatusState.initial() = _Initial;
  const factory ConnectivityStatusState.hasConnection() = _HasConnection;
  const factory ConnectivityStatusState.noConnection() = _NoConnection;
}
