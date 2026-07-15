import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/height_cache_resolver.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/widget_height_cache.dart';

/// Object of this class measures height of rendered widget which it be builds with `measuredWidgetBuilder`.
///
/// The measurement allows for pixel-perfect layouts wherever Flutter does not expose API for the height.
/// Works by building the widget in `Offstage` and measuring its height.
///
/// Important:
/// 1. Be careful with global zoom (as in `AppSize` of FlutterFormBricks) - `WidgetHeightProbe`
/// measures the height without zoom. Zoom must be then applied where the height is used to
/// control any other widgets.
/// 2. Always invalidate measurement in `didChangeDependencies` when any of the factors
/// controlling the measured widget's height changes.
/// 3. The measured widget must be inserted into the widget tree. Offstage prevents painting
/// but still performs layout, allowing the widget's size to be measured.
///
/// Example use: see `LabelledBox`.
class WidgetHeightProbe extends StatefulWidget {
  /// Builds the widget to be measured.
  final Widget Function(BuildContext) measuredWidgetBuilder;

  /// Callback in the class that needs the height measured. It should set the `someHeight` param or field in that class.
  /// Called when the height becomes available.
  /// The measurement may have been performed by this probe or by another probe using the same cacheKey -
  /// then cached value will be used.
  final ValueChanged<double> onMeasured;

  final HeightCacheResolver? cacheKey;

  const WidgetHeightProbe({
    super.key,
    required this.measuredWidgetBuilder,
    required this.onMeasured,
    this.cacheKey,
  });

  @override
  State<WidgetHeightProbe> createState() => _WidgetHeightProbeState();
}

class _WidgetHeightProbeState extends State<WidgetHeightProbe> {
  final GlobalKey _probeGlobalKey = GlobalKey();

  bool get _shouldCacheTheResult => widget.cacheKey != null && widget.cacheKey!.isCacheable();

  @override
  void initState() {
    super.initState();
    if (!_shouldCacheTheResult || !WidgetHeightCache.isMeasured(widget.cacheKey!)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _measure();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldCacheTheResult && WidgetHeightCache.isMeasured(widget.cacheKey!)) {
      return const _OffstageDummy();
    }

    if (_shouldCacheTheResult) WidgetHeightCache.registerAsMeasured(widget.cacheKey!);

    return Offstage(
      child: Material(
        key: _probeGlobalKey,
        child: widget.measuredWidgetBuilder(context),
      ),
    );
  }

  void _measure() {
    // Check - another widget might have already finished the measure process
    double? height = WidgetHeightCache.getHeight(widget.cacheKey);

    // Not measured yet - do it now
    if (height == null) {
      height = _measureHeight();

      if (height == null) return;

      if (_shouldCacheTheResult) WidgetHeightCache.putHeight(widget.cacheKey!, height);
    }

    // set the height in the widget waiting for the value
    widget.onMeasured(height);
  }

  double? _measureHeight() {
    final BuildContext? context = _probeGlobalKey.currentContext;
    if (context == null) return null;

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;

    return renderObject.size.height;
  }
}

class _OffstageDummy extends Offstage {
  const _OffstageDummy() : super(child: const SizedBox());
}
