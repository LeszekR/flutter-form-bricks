import 'package:flutter/material.dart';

@immutable
class TextFieldHeightCacheKey {
  final InputDecoration decoration;
  final TextStyle style;
  final StrutStyle? strutStyle;
  final double width;
  final int? minLines;
  final int? maxLines;
  final bool expands;
  final double textScaleFactor;
  final bool useMaterial3;

  const TextFieldHeightCacheKey({
    required this.decoration,
    required this.style,
    required this.strutStyle,
    required this.width,
    required this.minLines,
    required this.maxLines,
    required this.expands,
    required this.textScaleFactor,
    required this.useMaterial3,
  });

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