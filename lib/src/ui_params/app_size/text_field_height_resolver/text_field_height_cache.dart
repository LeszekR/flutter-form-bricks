import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache_key.dart';

class TextFieldHeightCache {
  static final Map<TextFieldHeightCacheKey, double> _cache = {};
  static final Set<TextFieldHeightCacheKey> _processedKeys = {};

  static double? getHeight(TextFieldHeightCacheKey key) {
    return _cache[key];
  }

  static void putHeight(TextFieldHeightCacheKey key, double height) {
    _cache[key] = height;
  }

  static void startMeasuring(TextFieldHeightCacheKey key) {
    _processedKeys.add(key);
  }

  static bool isMeasured(TextFieldHeightCacheKey key) {
    return _processedKeys.contains(key);
  }
}
