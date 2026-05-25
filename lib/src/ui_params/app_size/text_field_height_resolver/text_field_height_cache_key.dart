import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_config.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

@immutable
class TextFieldHeightCacheKey {
  final InputDecoration decoration;
  final TextStyle style;
  final bool expands;
  final double textScaleFactor;
  final bool useMaterial3;
  final StrutStyle? strutStyle;
  final double? width;
  final int? minLines;
  final int? maxLines;

  TextFieldHeightCacheKey._({
    required this.decoration,
    required this.style,
    required this.expands,
    required this.textScaleFactor,
    required this.useMaterial3,
    this.strutStyle = null,
    this.width = null,
    this.minLines = null,
    this.maxLines = null,
  });

  static TextFieldHeightCacheKey fromConfig({
    required BuildContext context,
    required TextFieldConfig config,
    required InputDecoration decoration,
    required double width,
  }) {
    // This reduces number of height measurements for fields with identical setup, single-lined and only different in width.
    double? widthOrNull;
    if ((config.minLines != null && config.minLines! > 1) || (config.maxLines != null && config.maxLines! > 1)) {
      widthOrNull = width;
    } else {
      widthOrNull = null;
    }

    return TextFieldHeightCacheKey._(
      decoration: decoration.withoutBottomWidgets(),
      style: config.style ?? UiParams.of(context).appTheme.textStyle(),
      strutStyle: config.strutStyle,
      width: widthOrNull,
      minLines: config.minLines,
      maxLines: config.maxLines,
      expands: config.expands,
      textScaleFactor: MediaQuery.textScalerOf(context).scale(1.0),
      useMaterial3: Theme.of(context).useMaterial3,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TextFieldHeightCacheKey &&
            decoration == other.decoration &&
            style == other.style &&
            strutStyle == other.strutStyle &&
            width == other.width &&
            minLines == other.minLines &&
            maxLines == other.maxLines &&
            expands == other.expands &&
            textScaleFactor == other.textScaleFactor &&
            useMaterial3 == other.useMaterial3;
  }

  @override
  int get hashCode => Object.hash(
        decoration,
        style,
        strutStyle,
        width,
        minLines,
        maxLines,
        expands,
        textScaleFactor,
        useMaterial3,
      );
}
