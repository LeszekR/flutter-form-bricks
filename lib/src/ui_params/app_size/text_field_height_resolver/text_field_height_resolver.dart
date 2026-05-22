import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache_key.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_heigth_probe.dart';

class TextFieldHeightResolver extends StatefulWidget {
  final TextFieldHeightCacheKey cacheKey;
  final Widget Function(double measuredHeight) builder;

  const TextFieldHeightResolver({
    super.key,
    required this.cacheKey,
    required this.builder,
  });

  @override
  State<TextFieldHeightResolver> createState() =>
      _TextFieldHeightResolverState();
}

class _TextFieldHeightResolverState extends State<TextFieldHeightResolver> {
  double? _height;

  @override
  void initState() {
    super.initState();
    _height = TextFieldHeightCache.getHeight(widget.cacheKey);
  }

  void _onMeasured(double height) {
    if (_height == height) return;

    setState(() {
      _height = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = _height;

    if (height == null) {
      return TextFieldHeightProbe(
        cacheKey: widget.cacheKey,
        onMeasured: _onMeasured,
      );
    }

    return widget.builder(height);
  }
}