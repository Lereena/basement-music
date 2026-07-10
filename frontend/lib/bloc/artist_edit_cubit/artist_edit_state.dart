part of 'artist_edit_cubit.dart';

@freezed
abstract class ArtistEditState with _$ArtistEditState {
  const factory ArtistEditState({
    @Default('') String name,
    @Default('') String description,
    String? currentImageUrl,
    Uint8List? pickedBytes,
    String? pickedFilename,
    @Default(false) bool loading,
    @Default(false) bool saving,
    @Default(false) bool saved,
    @Default(false) bool error,
  }) = _ArtistEditState;
}
