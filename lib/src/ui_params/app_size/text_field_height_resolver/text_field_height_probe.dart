import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_decoration_maker.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache_key.dart';

class TextFieldHeightProbe extends StatefulWidget {
  final TextFieldHeightProbeConfig heightProbeConfig;
  final ValueChanged<double> onMeasured;

  const TextFieldHeightProbe({
    super.key,
    required this.heightProbeConfig,
    required this.onMeasured,
  });

  @override
  State<TextFieldHeightProbe> createState() => _TextFieldHeightProbeState();
}

class _TextFieldHeightProbeState extends State<TextFieldHeightProbe> {
  final GlobalKey _probeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextFieldHeightProbeConfig cacheKey = widget.heightProbeConfig;

    if (TextFieldHeightCache.isBeingMeasured(cacheKey)) {
      return const OffstageDummy();
    }

    TextFieldHeightCache.startMeasuring(cacheKey);

    return Offstage(
      child: Material(
        child: SizedBox(
          key: _probeKey,
          width: cacheKey.width,
          child: TextField(
            controller: TextEditingController(text: cacheKey.text),
            decoration: cacheKey.decoration,
            style: cacheKey.style,
            expands: cacheKey.expands,
            strutStyle: cacheKey.strutStyle,
            minLines: cacheKey.minLines,
            maxLines: cacheKey.maxLines,
          ),
        ),
      ),
    );
  }

  void _measure() {
    // Check - another widget might have already finished the measure process
    double? height = TextFieldHeightCache.getHeight(widget.heightProbeConfig);

    // Not measured yet - do it now
    if (height == null) {
      height = _measureHeight();

      if (height == null) return;

      TextFieldHeightCache.putHeight(widget.heightProbeConfig, height);
    }

    // set the height in the widget waiting for the value
    widget.onMeasured(height);
  }

  double? _measureHeight() {
    final BuildContext? context = _probeKey.currentContext;
    if (context == null) return null;

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;

    return box.size.height;
  }
}

class OffstageDummy extends Offstage {
  const OffstageDummy() : super(child: const SizedBox(height: 1));
}
