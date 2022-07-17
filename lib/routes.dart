enum NavigationRoute { initial, settings }

extension Name on NavigationRoute {
  String get name {
    switch (this) {
      case NavigationRoute.initial:
        return '/';
      case NavigationRoute.settings:
        return '/settings';
    }
  }
}
