part of 'admin_cubit.dart';

@freezed
abstract class AdminState with _$AdminState {
  const factory AdminState.initial() = _Initial;
  const factory AdminState.loadInProgress() = _LoadInProgress;
  const factory AdminState.loaded({required List<RegistrationCode> codes}) = _Loaded;
  const factory AdminState.error() = _Error;
}
