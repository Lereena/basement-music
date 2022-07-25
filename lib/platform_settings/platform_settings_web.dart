// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

void preventDefault() {
  document.onContextMenu.listen((event) => event.preventDefault());
}
