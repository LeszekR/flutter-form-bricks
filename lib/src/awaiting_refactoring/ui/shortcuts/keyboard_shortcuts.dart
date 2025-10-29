import 'package:flutter/services.dart';

class KeyboardEvents {
  static final KeyboardEvents _instance = KeyboardEvents._internal();
  static bool _onEditCompleteCalled = false;

  final List<Function(RawKeyEvent)> _listener = [];
  Function(RawKeyEvent)? _menuListener;

  KeyboardEvents._internal();

  factory KeyboardEvents() {
    return _instance;
  }

  static KeyboardEvents instance() => _instance;

  int countListeners() => _listener.length;

  static void onEditTriggered() {
    _onEditCompleteCalled = true;
  }

  void subscribeMenu(Function(RawKeyEvent) listener) {
    _menuListener ??= listener;
  }

  void subscribe(Function(RawKeyEvent) listener) {
    _listener.add(listener);
  }

  void unSubscribe(Function(RawKeyEvent) listener) {
    _listener.remove(listener);
  }

  void unSubscribeAll() {
    _listener.clear();
  }

  void handleKey(RawKeyEvent event) {
    // not happy with the workaround but it works fine
    if (_onEditCompleteCalled) {
      _onEditCompleteCalled = false;
      return;
    }

    if (event.repeat || event is! RawKeyDownEvent) return;

    if (_listener.isEmpty) {
      _menuListener!.call(event);
    } else {
      _listener.last.call(event);
    }
  }
}
