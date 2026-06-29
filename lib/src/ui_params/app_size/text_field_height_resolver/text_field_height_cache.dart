import 'package:equatable/equatable.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache_key.dart';

class TextFieldHeightCache {
  static final Map<Equatable, double> _cache = {};
  static final Set<Equatable> _processedKeys = {};

  static double? getHeight(Equatable key) {
    return _cache[key];
  }

  static void putHeight(Equatable key, double height) {
    _cache[key] = height;
  }

  static void startMeasuring(Equatable key) {
    _processedKeys.add(key);
  }

  static bool isBeingMeasured(Equatable key) {
    return _processedKeys.contains(key);
  }
}
