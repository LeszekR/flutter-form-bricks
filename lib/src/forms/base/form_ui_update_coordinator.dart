import 'package:flutter/widgets.dart';

class FormUiUpdateCoordinator extends ChangeNotifier {
  bool _scheduled = false;

  void requestRefresh() {
    if (_scheduled) return;
    _scheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      notifyListeners();
    });
  }
}