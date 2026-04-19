import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_params.dart';

class TextFieldHeightEstimator {
  static final Map<TextFieldHeightParams, double> _cache = {};

  static double estimate({
    required BuildContext context,
    InputDecoration? decoration,
    TextStyle? style,
    StrutStyle? strutStyle,
    int maxLines = 1,
    bool expands = false,
    bool? useMaterial3,
    double? textScaleFactor,
  }) {
    final TextFieldHeightParams params = TextFieldHeightParams.fromContext(
      context: context,
      decoration: decoration,
      style: style,
      strutStyle: strutStyle,
      maxLines: maxLines,
      expands: expands,
      useMaterial3: useMaterial3,
      textScaleFactor: textScaleFactor,
    );

    return estimateForParams(params);
  }

  static double estimateForParams(TextFieldHeightParams params) {
    final double? cachedValue = _cache[params];
    if (cachedValue != null) return cachedValue;

    final double estimatedValue = _estimateUncached(params);
    _cache[params] = estimatedValue;
    return estimatedValue;
  }

  static void clearCache() {
    _cache.clear();
  }

  static double _estimateUncached(TextFieldHeightParams params) {
    final bool collapsed = params.decoration.isCollapsed ?? false;

    if (collapsed) {
      return _collapsedHeight(params);
    }

    final bool dense = params.decoration.isDense ?? false;

    final EdgeInsets contentPadding = _effectiveContentPadding(
      decoration: params.decoration,
      isDense: dense,
      material3: params.material3,
    );

    final double textBlockHeight = _estimateTextBlockHeight(
      style: params.textStyle,
      strutStyle: params.strutStyle,
      maxLines: params.maxLines,
      expands: params.expands,
      textScaleFactor: params.textScaleFactor,
    );

    final double textAndPaddingHeight =
        textBlockHeight + contentPadding.top + contentPadding.bottom;

    final double prefixMinHeight = _minConstraintHeight(
      params.decoration.prefixIconConstraints,
      defaultValue: params.decoration.prefixIcon == null ? 0 : 48,
    );

    final double suffixMinHeight = _minConstraintHeight(
      params.decoration.suffixIconConstraints,
      defaultValue: params.decoration.suffixIcon == null ? 0 : 48,
    );

    final VisualDensity effectiveDensity =
        params.decoration.visualDensity ?? const VisualDensity();

    final double densityAdjustment = effectiveDensity.baseSizeAdjustment.dy;

    final double borderExtraHeight =
    _estimateBorderExtraHeight(params.decoration.border);

    final double baseMinContainerHeight =
        textAndPaddingHeight + borderExtraHeight;

    final double densityAdjustedMinHeight =
    math.max(0, baseMinContainerHeight + densityAdjustment);

    return math.max(
      densityAdjustedMinHeight,
      math.max(prefixMinHeight, suffixMinHeight),
    );
  }

  static double _collapsedHeight(TextFieldHeightParams params) {
    final double textHeight = _estimateTextBlockHeight(
      style: params.textStyle,
      strutStyle: params.strutStyle,
      maxLines: params.maxLines,
      expands: false,
      textScaleFactor: params.textScaleFactor,
    );

    final double prefixMinHeight = _minConstraintHeight(
      params.decoration.prefixIconConstraints,
      defaultValue: 0,
    );

    final double suffixMinHeight = _minConstraintHeight(
      params.decoration.suffixIconConstraints,
      defaultValue: 0,
    );

    return math.max(textHeight, math.max(prefixMinHeight, suffixMinHeight));
  }

  static EdgeInsets _effectiveContentPadding({
    required InputDecoration decoration,
    required bool isDense,
    required bool material3,
  }) {
    final EdgeInsetsGeometry? raw = decoration.contentPadding;
    if (raw != null) {
      return raw.resolve(TextDirection.ltr);
    }

    if (decoration.isCollapsed == true) {
      return EdgeInsets.zero;
    }

    final bool filled = decoration.filled ?? false;
    final bool isOutline = _isOutlineBorder(decoration.border);

    if (material3) {
      if (isOutline) {
        return isDense
            ? const EdgeInsets.fromLTRB(12, 16, 12, 8)
            : const EdgeInsets.fromLTRB(12, 20, 12, 12);
      }
      if (filled) {
        return isDense
            ? const EdgeInsets.fromLTRB(12, 4, 12, 4)
            : const EdgeInsets.fromLTRB(12, 8, 12, 8);
      }
      return isDense
          ? const EdgeInsets.fromLTRB(0, 4, 0, 4)
          : const EdgeInsets.fromLTRB(0, 8, 0, 8);
    }

    if (isOutline) {
      return isDense
          ? const EdgeInsets.fromLTRB(12, 20, 12, 12)
          : const EdgeInsets.fromLTRB(12, 24, 12, 16);
    }

    if (filled) {
      return isDense
          ? const EdgeInsets.fromLTRB(12, 8, 12, 8)
          : const EdgeInsets.fromLTRB(12, 12, 12, 12);
    }

    return isDense
        ? const EdgeInsets.fromLTRB(0, 8, 0, 8)
        : const EdgeInsets.fromLTRB(0, 12, 0, 12);
  }

  static bool _isOutlineBorder(InputBorder? border) {
    if (border == null) return false;
    return border.isOutline;
  }

  static double _estimateTextBlockHeight({
    required TextStyle style,
    StrutStyle? strutStyle,
    required int maxLines,
    required bool expands,
    required double textScaleFactor,
  }) {
    if (expands) return 0;

    final double fontSize = (style.fontSize ?? 16) * textScaleFactor;

    final double lineHeightMultiplier =
        style.height ?? strutStyle?.height ?? 1.2;

    final double leading =
    strutStyle?.leading == null ? 0 : fontSize * strutStyle!.leading!;

    final double lineHeight = fontSize * lineHeightMultiplier + leading;

    final int lines = math.max(1, maxLines);
    return lineHeight * lines;
  }

  static double _minConstraintHeight(
      BoxConstraints? constraints, {
        required double defaultValue,
      }) {
    if (constraints == null) return defaultValue;
    return constraints.minHeight > 0 ? constraints.minHeight : defaultValue;
  }

  static double _estimateBorderExtraHeight(InputBorder? border) {
    if (border == null || border == InputBorder.none) return 0;

    if (border is OutlineInputBorder) {
      final BorderSide side = border.borderSide;
      return math.max(2, side.width * 2);
    }

    if (border is UnderlineInputBorder) {
      return math.max(1, border.borderSide.width);
    }

    return 2;
  }
}