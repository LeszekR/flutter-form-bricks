import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache_key.dart';

class TextFieldHeightCache {
  static final Map<TextFieldHeightCacheKey, double> _cache = {};

  static double? get(TextFieldHeightCacheKey key) {
    return _cache[key];
  }

  static void put(
      TextFieldHeightCacheKey key,
      double height,
      ) {
    _cache[key] = height;
  }

  static bool contains(TextFieldHeightCacheKey key) {
    return _cache.containsKey(key);
  }

  static void clear() {
    _cache.clear();
  }
}