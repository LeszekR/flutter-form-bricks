import 'package:equatable/equatable.dart';

class WidgetHeightCache {
  static final Map<Equatable, double> _cache = {};
  static final Set<Equatable> _processedKeys = {};

  static double? getHeight(Equatable? key) {
    if (key == null) return null;
    return _cache[key];
  }

  static void putHeight(Equatable key, double height) {
    _cache[key] = height;
  }

  static void registerAsMeasured(Equatable key) {
    _processedKeys.add(key);
  }

  static bool isMeasured(Equatable key) {
    return _processedKeys.contains(key);
  }
}
