import 'package:flutter/material.dart';

class TextFieldHeightParams implements Comparable<TextFieldHeightParams> {
  final InputDecoration decoration;
  final TextStyle textStyle;
  final StrutStyle? strutStyle;
  final int maxLines;
  final bool expands;
  final bool material3;
  final double textScaleFactor;

  const TextFieldHeightParams({
    required this.decoration,
    required this.textStyle,
    required this.strutStyle,
    required this.maxLines,
    required this.expands,
    required this.material3,
    required this.textScaleFactor,
  });

  factory TextFieldHeightParams.fromContext({
    required BuildContext context,
    InputDecoration? decoration,
    TextStyle? style,
    StrutStyle? strutStyle,
    int maxLines = 1,
    bool expands = false,
    bool? useMaterial3,
    double? textScaleFactor,
  }) {
    final ThemeData theme = Theme.of(context);
    final InputDecorationThemeData inputTheme = theme.inputDecorationTheme;

    return TextFieldHeightParams(
      decoration: (decoration ?? const InputDecoration()).applyDefaults(inputTheme),
      textStyle:
      style ??
          theme.textTheme.bodyLarge ??
          theme.textTheme.titleMedium ??
          const TextStyle(fontSize: 16),
      strutStyle: strutStyle,
      maxLines: maxLines,
      expands: expands,
      material3: useMaterial3 ?? theme.useMaterial3,
      textScaleFactor: textScaleFactor ?? MediaQuery.textScalerOf(context).scale(1.0),
    );
  }

  @override
  int compareTo(TextFieldHeightParams other) {
    int result = _compareInputDecoration(decoration, other.decoration);
    if (result != 0) return result;

    result = _compareTextStyle(textStyle, other.textStyle);
    if (result != 0) return result;

    result = _compareStrutStyle(strutStyle, other.strutStyle);
    if (result != 0) return result;

    result = maxLines.compareTo(other.maxLines);
    if (result != 0) return result;

    result = expands.toString().compareTo(other.expands.toString());
    if (result != 0) return result;

    result = material3.toString().compareTo(other.material3.toString());
    if (result != 0) return result;

    return textScaleFactor.compareTo(other.textScaleFactor);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TextFieldHeightParams &&
              decoration == other.decoration &&
              textStyle == other.textStyle &&
              strutStyle == other.strutStyle &&
              maxLines == other.maxLines &&
              expands == other.expands &&
              material3 == other.material3 &&
              textScaleFactor == other.textScaleFactor;

  @override
  int get hashCode => Object.hash(
    decoration,
    textStyle,
    strutStyle,
    maxLines,
    expands,
    material3,
    textScaleFactor,
  );

  static int _compareDouble(double? a, double? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    return a.compareTo(b);
  }

  static int _compareColor(Color? a, Color? b) {
    final int? av = a?.value;
    final int? bv = b?.value;
    if (av == null && bv == null) return 0;
    if (av == null) return -1;
    if (bv == null) return 1;
    return av.compareTo(bv);
  }

  static int _compareEdgeInsetsGeometry(
      EdgeInsetsGeometry? a,
      EdgeInsetsGeometry? b,
      ) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;

    final EdgeInsets ar = a.resolve(TextDirection.ltr);
    final EdgeInsets br = b.resolve(TextDirection.ltr);

    int result = ar.left.compareTo(br.left);
    if (result != 0) return result;
    result = ar.top.compareTo(br.top);
    if (result != 0) return result;
    result = ar.right.compareTo(br.right);
    if (result != 0) return result;
    return ar.bottom.compareTo(br.bottom);
  }

  static int _compareBoxConstraints(BoxConstraints? a, BoxConstraints? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;

    int result = a.minWidth.compareTo(b.minWidth);
    if (result != 0) return result;
    result = a.maxWidth.compareTo(b.maxWidth);
    if (result != 0) return result;
    result = a.minHeight.compareTo(b.minHeight);
    if (result != 0) return result;
    return a.maxHeight.compareTo(b.maxHeight);
  }

  static int _compareBorderSide(BorderSide a, BorderSide b) {
    int result = _compareColor(a.color, b.color);
    if (result != 0) return result;

    result = a.width.compareTo(b.width);
    if (result != 0) return result;

    result = a.style.toString().compareTo(b.style.toString());
    if (result != 0) return result;

    return a.strokeAlign.compareTo(b.strokeAlign);
  }

  static int _compareInputBorder(InputBorder? a, InputBorder? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;

    int result = a.runtimeType.toString().compareTo(b.runtimeType.toString());
    if (result != 0) return result;

    if (a is OutlineInputBorder && b is OutlineInputBorder) {
      result = _compareBorderSide(a.borderSide, b.borderSide);
      if (result != 0) return result;

      result = a.gapPadding.compareTo(b.gapPadding);
      if (result != 0) return result;

      return a.borderRadius.toString().compareTo(b.borderRadius.toString());
    }

    if (a is UnderlineInputBorder && b is UnderlineInputBorder) {
      result = _compareBorderSide(a.borderSide, b.borderSide);
      if (result != 0) return result;

      return a.borderRadius.toString().compareTo(b.borderRadius.toString());
    }

    return _compareBorderSide(a.borderSide, b.borderSide);
  }

  static int _compareTextStyle(TextStyle a, TextStyle b) {
    int result = _compareColor(a.color, b.color);
    if (result != 0) return result;

    result = _compareDouble(a.fontSize, b.fontSize);
    if (result != 0) return result;

    result = _compareDouble(a.height, b.height);
    if (result != 0) return result;

    result = (a.fontFamily ?? '').compareTo(b.fontFamily ?? '');
    if (result != 0) return result;

    result = a.fontWeight.toString().compareTo(b.fontWeight.toString());
    if (result != 0) return result;

    result = a.fontStyle.toString().compareTo(b.fontStyle.toString());
    if (result != 0) return result;

    result = (a.letterSpacing ?? 0).compareTo(b.letterSpacing ?? 0);
    if (result != 0) return result;

    return (a.wordSpacing ?? 0).compareTo(b.wordSpacing ?? 0);
  }

  static int _compareStrutStyle(StrutStyle? a, StrutStyle? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;

    int result = _compareDouble(a.fontSize, b.fontSize);
    if (result != 0) return result;

    result = _compareDouble(a.height, b.height);
    if (result != 0) return result;

    result = _compareDouble(a.leading, b.leading);
    if (result != 0) return result;

    result = (a.fontFamily ?? '').compareTo(b.fontFamily ?? '');
    if (result != 0) return result;

    result = a.fontWeight.toString().compareTo(b.fontWeight.toString());
    if (result != 0) return result;

    result = a.fontStyle.toString().compareTo(b.fontStyle.toString());
    if (result != 0) return result;

    return a.forceStrutHeight.toString().compareTo(b.forceStrutHeight.toString());
  }

  static int _compareInputDecoration(InputDecoration a, InputDecoration b) {
    int result = _compareEdgeInsetsGeometry(a.contentPadding, b.contentPadding);
    if (result != 0) return result;

    result = (a.isDense ?? false).toString().compareTo((b.isDense ?? false).toString());
    if (result != 0) return result;

    result = (a.isCollapsed ?? false).toString().compareTo((b.isCollapsed ?? false).toString());
    if (result != 0) return result;

    result = (a.filled ?? false).toString().compareTo((b.filled ?? false).toString());
    if (result != 0) return result;

    result = _compareInputBorder(a.border, b.border);
    if (result != 0) return result;

    result = _compareBoxConstraints(a.prefixIconConstraints, b.prefixIconConstraints);
    if (result != 0) return result;

    result = _compareBoxConstraints(a.suffixIconConstraints, b.suffixIconConstraints);
    if (result != 0) return result;

    result = (a.prefixIcon == null).toString().compareTo((b.prefixIcon == null).toString());
    if (result != 0) return result;

    result = (a.suffixIcon == null).toString().compareTo((b.suffixIcon == null).toString());
    if (result != 0) return result;

    result = (a.visualDensity?.horizontal ?? 0).compareTo(b.visualDensity?.horizontal ?? 0);
    if (result != 0) return result;

    return (a.visualDensity?.vertical ?? 0).compareTo(b.visualDensity?.vertical ?? 0);
  }
}