import 'package:flutter/material.dart';

class AppScale with ChangeNotifier {
  static AppScale? _singleton;

  factory AppScale() {
    _singleton ??= AppScale._();
    return _singleton!;
  }

  AppScale._();


  // double _currentScale = CacheService().cache.getDouble(_scaleKey) ?? 1.0;
  double _currentScale = 1.0;

  // TODO create app scaling
  void setScale(final double newVal) {
    // CacheService().cache.setDouble(_scaleKey, newVal);
    // _currentScale = newVal;
    //
    // if (_use3rdPartyLib) {
    //   ScaledWidgetsFlutterBinding.instance.scaleFactor = (deviceSize) {
    //     return AppScale().getScale();
    //   };
    // } else {
    //   notifyListeners();
    // }
  }

  double getScale() => _currentScale;
}
