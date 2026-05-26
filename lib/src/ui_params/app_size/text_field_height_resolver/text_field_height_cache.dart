import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache_key.dart';

class TextFieldHeightCache {
  static final Map<TextFieldHeightProbeConfig, double> _cache = {};
  static final Set<TextFieldHeightProbeConfig> _processedKeys = {};

  static double? getHeight(TextFieldHeightProbeConfig key) {
    return _cache[key];
  }

  static void putHeight(TextFieldHeightProbeConfig key, double height) {
    _cache[key] = height;
  }

  static void startMeasuring(TextFieldHeightProbeConfig key) {
    _processedKeys.add(key);
  }

  static bool isMeasured(TextFieldHeightProbeConfig key) {
    return _processedKeys.contains(key);
  }
}
