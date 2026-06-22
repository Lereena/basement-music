part of 'soulseek_login_cubit.dart';

@freezed
abstract class SoulseekLoginState with _$SoulseekLoginState {
  const factory SoulseekLoginState.initial() = _Initial;
  const factory SoulseekLoginState.loading() = _Loading;
  const factory SoulseekLoginState.connected({required String username}) = _Connected;
  const factory SoulseekLoginState.error({required String message}) = _Error;
}
