import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache.dart';

class WidgetHeightProbe extends StatefulWidget {
  final Equatable cacheKey;
  final Widget Function(BuildContext) measuredWidgetBuilder;
  final ValueChanged<double> onMeasured;

  const WidgetHeightProbe({
    super.key,
    required this.cacheKey,
    required this.measuredWidgetBuilder,
    required this.onMeasured,
  });

  @override
  State<WidgetHeightProbe> createState() => _WidgetHeightProbeState();
}

class _WidgetHeightProbeState extends State<WidgetHeightProbe> {
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
    if (TextFieldHeightCache.isBeingMeasured(widget.cacheKey)) {
      return const _OffstageDummy();
    }

    TextFieldHeightCache.startMeasuring(widget.cacheKey);

    return Offstage(
      child: Material(
        key: _probeKey,
        child: widget.measuredWidgetBuilder(context),
      ),
    );
  }

  void _measure() {
    // Check - another widget might have already finished the measure process
    double? height = TextFieldHeightCache.getHeight(widget.cacheKey);

    // Not measured yet - do it now
    if (height == null) {
      height = _measureHeight();

      if (height == null) return;

      TextFieldHeightCache.putHeight(widget.cacheKey, height);
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

class _OffstageDummy extends Offstage {
  const _OffstageDummy({super.key}) : super(child: const SizedBox());
}
