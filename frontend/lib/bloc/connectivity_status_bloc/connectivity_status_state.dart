part of 'connectivity_status_cubit.dart';

@immutable
sealed class ConnectivityStatusState {}

final class ConnectivityStatusInitial extends ConnectivityStatusState {}

final class ConnectivityStatusHasConnection extends ConnectivityStatusState {}

final class ConnectivityStatusNoConnection extends ConnectivityStatusState {}
