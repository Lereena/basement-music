import 'dart:html';

void preventDefault() {
  document.onContextMenu.listen((event) => event.preventDefault());
}
