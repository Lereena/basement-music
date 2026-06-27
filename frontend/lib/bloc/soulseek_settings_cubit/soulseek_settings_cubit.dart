import 'package:basement_music/logger.dart';
import 'package:basement_music/repositories/soulseek_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'soulseek_settings_cubit.freezed.dart';
part 'soulseek_settings_state.dart';

class SoulseekSettingsCubit extends Cubit<SoulseekSettingsState> {
  SoulseekSettingsCubit(this._repo) : super(const SoulseekSettingsState());

  final SoulseekRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    try {
      final settings = await _repo.getSettings();
      emit(state.copyWith(minutes: settings.disconnectAfterMinutes, loading: false));
    } catch (e) {
      logger.e('Soulseek settings load failed: $e');
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> save(int minutes) async {
    emit(state.copyWith(loading: true));
    try {
      await _repo.setDisconnectMinutes(minutes);
      emit(state.copyWith(minutes: minutes, loading: false));
    } catch (e) {
      logger.e('Soulseek settings save failed: $e');
      emit(state.copyWith(loading: false));
    }
  }
}
