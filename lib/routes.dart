enum NavigationRoute { initial, settings, playlist, upload }

extension Name on NavigationRoute {
  String get name {
    switch (this) {
      case NavigationRoute.initial:
        return '/';
      case NavigationRoute.settings:
        return '/settings';
      case NavigationRoute.playlist:
        return '/playlist';
      case NavigationRoute.upload:
        return '/upload';
    }
  }
}
