import 'package:basement_music/repositories/soulseek_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'soulseek_login_cubit.freezed.dart';
part 'soulseek_login_state.dart';

class SoulseekLoginCubit extends Cubit<SoulseekLoginState> {
  SoulseekLoginCubit(this._repo) : super(const SoulseekLoginState.initial());

  final SoulseekRepository _repo;

  Future<void> loadStatus() async {
    try {
      final status = await _repo.getStatus();
      if (status.connected) {
        emit(SoulseekLoginState.connected(username: status.username));
      } else {
        emit(const SoulseekLoginState.initial());
      }
    } catch (_) {
      emit(const SoulseekLoginState.initial());
    }
  }

  Future<void> setCredentials(String username, String password) async {
    emit(const SoulseekLoginState.loading());
    try {
      await _repo.setCredentials(username, password);
      emit(SoulseekLoginState.connected(username: username));
    } catch (e) {
      emit(SoulseekLoginState.error(message: e.toString()));
    }
  }

  Future<void> disconnect() async {
    try {
      await _repo.disconnect();
    } catch (_) {}
    emit(const SoulseekLoginState.initial());
  }
}
