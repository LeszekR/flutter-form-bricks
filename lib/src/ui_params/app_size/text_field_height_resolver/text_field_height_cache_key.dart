import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_config.dart';

@immutable
class TextFieldHeightCacheKey {
  final InputDecoration decoration;
  final String? text;
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
    required this.text,
    required this.style,
    required this.expands,
    required this.textScaleFactor,
    required this.useMaterial3,
    this.strutStyle = null,
    this.width = null,
    this.minLines = null,
    this.maxLines = null,
  });

  static TextFieldHeightCacheKey create({
    required BuildContext context,
    required TextFieldConfig config,
    required InputDecoration decoration,
    required double width,
    required String? text,
  }) {
    // This reduces number of height measurements for fields with identical setup, single-lined and only different in width.
    double? effectiveWidth;
    String? effectiveText;
    if ((config.minLines != null && config.minLines! > 1) || (config.maxLines != null && config.maxLines! > 1)) {
      effectiveWidth = width;
      effectiveText = text;
    } else {
      effectiveWidth = 100;
      effectiveText = 'Ay';
    }

    return TextFieldHeightCacheKey._(
      decoration: decoration.withoutBottomWidgets(),
      text: effectiveText,
      style: config.style ?? UiParams.of(context).appTheme.textStyle(),
      strutStyle: config.strutStyle,
      width: effectiveWidth,
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
            decoration.hasSameInputDecoratorHeightAs(other.decoration) &&
            text == other.text &&
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
        decoration.inputDecoratorHeightHash,
        text,
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
