part of 'auth_cubit.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Firebase user exists but not yet registered in our DB
  const factory AuthState.pendingRegistration() = _PendingRegistration;

  const factory AuthState.authenticated({required AppUser user}) = _Authenticated;
  const factory AuthState.error({required String message}) = _Error;
}
