class RouteName {
  static String get initial => '/';
  static String get tracks => '/tracks';
  static String get library => '/library';
  static String playlist(String id) => '/library/$id';
  static String get search => '/search';
  static String get settings => '/settings';
  static String get upload => '/upload';
  static String get uploadFromDevice => '/upload/fromDevice';
  static String get uploadFromYoutube => '/upload/fromYoutube';
}
