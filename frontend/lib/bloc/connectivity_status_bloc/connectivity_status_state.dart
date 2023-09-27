part of 'connectivity_status_cubit.dart';

sealed class ConnectivityStatusState {}

final class ConnectivityStatusInitial extends ConnectivityStatusState {}

final class HasConnectionState extends ConnectivityStatusState {}

final class NoConnectionState extends ConnectivityStatusState {}
