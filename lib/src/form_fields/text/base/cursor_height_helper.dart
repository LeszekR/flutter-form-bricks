import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

class CursorHeightHelper {
  static const double _baseFieldHeight = 44.0;
  static const double _densityStepPx = 4.0;

  /// Computes a cursor height that fits a compact Material text field.
  ///
  /// [visualDensityVertical]
  ///   Between -4 and 4.
  ///
  /// [verticalInsets]
  ///   Total vertical space not available to the cursor.
  ///   In practice this is commonly:
  ///   contentPadding.top + contentPadding.bottom
  ///
  /// [safetyMargin]
  ///   Extra pixels subtracted to avoid touching borders.
  ///
  /// [minCursorHeight]
  ///   Lower clamp so the cursor never becomes absurdly small.
  static double compute({
    required double visualDensityVertical,
    required double verticalInsets,
    double safetyMargin = 4.0,
    double minCursorHeight = 8.0,
  }) {
    final double fieldHeight = _baseFieldHeight + visualDensityVertical * _densityStepPx;

    final double cursorHeight = fieldHeight - verticalInsets - safetyMargin;

    return math.max(minCursorHeight, cursorHeight);
  }

  /// Convenience helper when you already have [InputDecoration].
  static double? computeFromDecoration({
    required BuildContext context,
    required InputDecoration? decoration,
    double safetyMargin = 2.0,
    double minCursorHeight = 8.0,
    double defaultVisualDensityVertical = 0.0,
    double defaultVerticalInsets = 0.0,
    EdgeInsetsGeometry defaultPaddingGeometry = const EdgeInsets.all(6.0),
  }) {
    var uiParams = UiParams.of(context);
    final double visualDensityVertical = decoration?.visualDensity?.vertical ??
        uiParams.appTheme.inputDecorationThemeData.visualDensity?.vertical ??
        defaultVisualDensityVertical;

    if (visualDensityVertical >= -1) return null;

    final EdgeInsetsGeometry? paddingGeometry = decoration?.contentPadding ??
        uiParams.appTheme.inputDecorationThemeData.contentPadding ??
        defaultPaddingGeometry;

    final EdgeInsets padding = paddingGeometry is EdgeInsets ? paddingGeometry : EdgeInsets.all(6.0);

    final double verticalInsets = padding.top + padding.bottom + defaultVerticalInsets;

    return compute(
      visualDensityVertical: visualDensityVertical,
      verticalInsets: verticalInsets,
      safetyMargin: safetyMargin,
      minCursorHeight: minCursorHeight,
    );
  }
}
