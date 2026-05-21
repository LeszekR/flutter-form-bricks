import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache_key.dart';

class TextFieldHeightProbe extends StatefulWidget {
  final TextFieldHeightCacheKey cacheKey;
  final ValueChanged<double> onMeasured;

  const TextFieldHeightProbe({
    super.key,
    required this.cacheKey,
    required this.onMeasured,
  });

  @override
  State<TextFieldHeightProbe> createState() =>
      _TextFieldHeightProbeState();
}

class _TextFieldHeightProbeState
    extends State<TextFieldHeightProbe> {
  final GlobalKey _measureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
    });
  }

  void _measure() {
    final BuildContext? context =
        _measureKey.currentContext;

    if (context == null) return;

    final RenderBox? box =
    context.findRenderObject() as RenderBox?;

    if (box == null || !box.hasSize) return;

    final double height = box.size.height;

    TextFieldHeightCache.put(
      widget.cacheKey,
      height,
    );

    widget.onMeasured(height);
  }

  @override
  Widget build(BuildContext context) {
    final key = widget.cacheKey;

    return Offstage(
      child: Material(
        child: SizedBox(
          key: _measureKey,
          width: key.width,
          child: TextField(
            style: key.style,
            strutStyle: key.strutStyle,
            minLines: key.minLines,
            maxLines: key.maxLines,
            expands: key.expands,
            decoration: key.decoration.copyWith(
              errorText: null,
              helperText: null,
              counterText: '',
            ),
          ),
        ),
      ),
    );
  }
}