abstract class RouteName {
  static String get initial => '/';
  static String get login => '/login';
  static String get registerCode => '/register-code';
  static String get tracks => '/tracks';
  static String get library => '/library';
  static String playlist(String id) => '/library/playlist/$id';
  static String playlistEdit(String id) => '/library/playlist/$id/edit';
  static String artist(String id) => '/library/artist/$id';
  static String artistTracks(String id) => '/library/artist/$id/tracks';
  static String artistEdit(String id) => '/library/artist/$id/edit';
  static String lyricsTiming(String id, String source) => '/track/$id/lyricsTiming?source=$source';
  static String album(String id) => '/library/album/$id';
  static String albumEdit(String id) => '/library/album/$id/edit';
  static String get search => '/search';
  static String get settings => '/settings';
  static String get upload => '/upload';
  static String get uploadFromDevice => '/upload/fromDevice';
  static String get uploadFromYoutube => '/upload/fromYoutube';
  static String get uploadFromSoulseek => '/upload/fromSoulseek';
}
