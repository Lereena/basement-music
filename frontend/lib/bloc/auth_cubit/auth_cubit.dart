import 'dart:async';

import 'package:basement_music/models/app_user.dart';
import 'package:basement_music/repositories/auth_repository.dart';
import 'package:basement_music/repositories/stats_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository, this._statsRepository) : super(const AuthState.loading()) {
    _subscription = _authRepository.authStateChanges.listen(_onAuthStateChanged);
  }

  final AuthRepository _authRepository;
  final StatsRepository _statsRepository;
  late final StreamSubscription<User?> _subscription;

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      emit(const AuthState.unauthenticated());
      return;
    }
    try {
      final user = await _authRepository.getMe();
      emit(AuthState.authenticated(user: user));
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        emit(const AuthState.pendingRegistration());
      } else {
        emit(AuthState.error(message: e.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthState.loading());
    try {
      await _authRepository.signInWithGoogle();
      // _onAuthStateChanged fires automatically
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> register(String code) async {
    emit(const AuthState.loading());
    try {
      final user = await _authRepository.register(code);
      emit(AuthState.authenticated(user: user));
    } on DioException catch (e) {
      emit(AuthState.error(message: e.response?.data?['error'] ?? e.message ?? 'Registration failed'));
    } catch (e) {
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    await _statsRepository.flushAndClearForSignOut();
    await _authRepository.signOut();
    // authStateChanges fires → unauthenticated
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
