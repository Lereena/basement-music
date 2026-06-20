import 'package:basement_music/models/registration_code.dart';
import 'package:basement_music/repositories/admin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_cubit.freezed.dart';
part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._repo) : super(const AdminState.initial());

  final AdminRepository _repo;

  Future<void> loadCodes() async {
    emit(const AdminState.loadInProgress());
    try {
      final codes = await _repo.getCodes();
      emit(AdminState.loaded(codes: codes));
    } catch (_) {
      emit(const AdminState.error());
    }
  }

  Future<void> generateCode() async {
    try {
      await _repo.generateCode();
      await loadCodes();
    } catch (_) {
      emit(const AdminState.error());
    }
  }
}
