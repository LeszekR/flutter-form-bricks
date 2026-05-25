import 'package:flutter/material.dart';

extension InputDecorationExtension on InputDecoration {
  InputDecoration? fillGapsFrom(InputDecoration? other) {
    if (other == null) return this;

    return copyWith(
      icon: icon ?? other.icon,
      iconColor: iconColor ?? other.iconColor,

      // label: label ?? other.label,
      // labelText: labelText ?? other.labelText,
      labelStyle: labelStyle ?? other.labelStyle,
      floatingLabelStyle: floatingLabelStyle ?? other.floatingLabelStyle,
      floatingLabelBehavior: floatingLabelBehavior ?? other.floatingLabelBehavior,
      floatingLabelAlignment: floatingLabelAlignment ?? other.floatingLabelAlignment,

      // helper: helper ?? other.helper,
      // helperText: helperText ?? other.helperText,
      helperStyle: helperStyle ?? other.helperStyle,
      helperMaxLines: helperMaxLines ?? other.helperMaxLines,

      // hint: hint ?? other.hint,
      // hintText: hintText ?? other.hintText,
      hintStyle: hintStyle ?? other.hintStyle,
      hintTextDirection: hintTextDirection ?? other.hintTextDirection,
      hintMaxLines: hintMaxLines ?? other.hintMaxLines,

      semanticCounterText: semanticCounterText ?? other.semanticCounterText,

      // error: error ?? other.error,
      // errorText: errorText ?? other.errorText,
      errorStyle: errorStyle ?? other.errorStyle,
      errorMaxLines: errorMaxLines ?? other.errorMaxLines,

      prefix: prefix ?? other.prefix,
      prefixText: prefixText ?? other.prefixText,
      prefixStyle: prefixStyle ?? other.prefixStyle,
      prefixIcon: prefixIcon ?? other.prefixIcon,
      prefixIconColor: prefixIconColor ?? other.prefixIconColor,
      prefixIconConstraints: prefixIconConstraints ?? other.prefixIconConstraints,

      suffix: suffix ?? other.suffix,
      suffixText: suffixText ?? other.suffixText,
      suffixStyle: suffixStyle ?? other.suffixStyle,
      suffixIcon: suffixIcon ?? other.suffixIcon,
      suffixIconColor: suffixIconColor ?? other.suffixIconColor,
      suffixIconConstraints: suffixIconConstraints ?? other.suffixIconConstraints,

      counter: counter ?? other.counter,
      counterText: counterText ?? other.counterText,
      counterStyle: counterStyle ?? other.counterStyle,

      filled: filled ?? other.filled,
      fillColor: fillColor ?? other.fillColor,
      focusColor: focusColor ?? other.focusColor,
      hoverColor: hoverColor ?? other.hoverColor,

      errorBorder: errorBorder ?? other.errorBorder,
      focusedBorder: focusedBorder ?? other.focusedBorder,
      focusedErrorBorder: focusedErrorBorder ?? other.focusedErrorBorder,
      disabledBorder: disabledBorder ?? other.disabledBorder,
      enabledBorder: enabledBorder ?? other.enabledBorder,
      border: border ?? other.border,

      // enabled: enabled ?? other.enabled,

      alignLabelWithHint: alignLabelWithHint ?? other.alignLabelWithHint,
      constraints: constraints ?? other.constraints,

      contentPadding: contentPadding ?? other.contentPadding,
      isCollapsed: isCollapsed ?? other.isCollapsed,
      isDense: isDense ?? other.isDense,

      visualDensity: visualDensity ?? other.visualDensity,
    );
  }

  InputDecoration withoutBottomWidgets() {
    return InputDecoration(
      icon: icon,
      iconColor: iconColor,

      label: label,
      labelText: labelText,
      labelStyle: labelStyle,
      floatingLabelStyle: floatingLabelStyle,
      floatingLabelBehavior: floatingLabelBehavior,
      floatingLabelAlignment: floatingLabelAlignment,

      hintText: hintText,
      hint: hint,
      hintStyle: hintStyle,
      hintTextDirection: hintTextDirection,
      hintMaxLines: hintMaxLines,
      hintFadeDuration: hintFadeDuration,

      // removed:
      // helper: null,
      // helperText: null,
      // error: null,
      // errorText: null,
      // counter: null,
      // counterText: null,

      // TODO upgrade Flutter and uncomment floatingLabelHeight setting
      // floatingLabelHeight: floatingLabelHeight,
      isCollapsed: isCollapsed,
      isDense: isDense,
      contentPadding: contentPadding,

      prefixIcon: prefixIcon,
      prefixIconConstraints: prefixIconConstraints,
      prefix: prefix,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      prefixIconColor: prefixIconColor,

      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIconConstraints,
      suffix: suffix,
      suffixText: suffixText,
      suffixStyle: suffixStyle,
      suffixIconColor: suffixIconColor,

      filled: filled,
      fillColor: fillColor,
      focusColor: focusColor,
      hoverColor: hoverColor,

      border: border,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      disabledBorder: disabledBorder,
      errorBorder: null,
      focusedErrorBorder: null,

      enabled: enabled,
      semanticCounterText: semanticCounterText,
      alignLabelWithHint: alignLabelWithHint,
      constraints: constraints,
      visualDensity: visualDensity,
    );
  }

  bool hasSameInputDecoratorHeightAs(InputDecoration other) {
    return _edgeInsetsGeometryEquals(contentPadding, other.contentPadding) &&
        isDense == other.isDense &&
        isCollapsed == other.isCollapsed &&
        visualDensity == other.visualDensity &&
        constraints == other.constraints &&

        // Border type/width can affect InputDecorator geometry.
        _inputBorderHeightEquals(border, other.border) &&
        _inputBorderHeightEquals(enabledBorder, other.enabledBorder) &&
        _inputBorderHeightEquals(focusedBorder, other.focusedBorder) &&
        _inputBorderHeightEquals(disabledBorder, other.disabledBorder) &&
        _inputBorderHeightEquals(errorBorder, other.errorBorder) &&
        _inputBorderHeightEquals(focusedErrorBorder, other.focusedErrorBorder) &&

        // These can add vertical subtext area.
        helperText == other.helperText &&
        errorText == other.errorText &&
        counterText == other.counterText &&
        helper == other.helper &&
        error == other.error &&
        counter == other.counter &&

        // Label/floating label affects vertical layout.
        labelText == other.labelText &&
        label == other.label &&
        floatingLabelBehavior == other.floatingLabelBehavior &&
        floatingLabelAlignment == other.floatingLabelAlignment &&
        alignLabelWithHint == other.alignLabelWithHint &&

        // Prefix/suffix widgets can affect height.
        prefix == other.prefix &&
        suffix == other.suffix &&
        prefixText == other.prefixText &&
        suffixText == other.suffixText &&
        prefixIcon == other.prefixIcon &&
        suffixIcon == other.suffixIcon &&
        prefixIconConstraints == other.prefixIconConstraints &&
        suffixIconConstraints == other.suffixIconConstraints &&

        // Hint can affect height in some configurations.
        hintText == other.hintText &&
        hint == other.hint &&
        hintMaxLines == other.hintMaxLines;
  }

  int get inputDecoratorHeightHash {
    return Object.hashAll([
      _edgeInsetsGeometryHash(contentPadding),
      isDense,
      isCollapsed,
      visualDensity,
      constraints,
      _inputBorderHeightHash(border),
      _inputBorderHeightHash(enabledBorder),
      _inputBorderHeightHash(focusedBorder),
      _inputBorderHeightHash(disabledBorder),
      _inputBorderHeightHash(errorBorder),
      _inputBorderHeightHash(focusedErrorBorder),
      helperText,
      errorText,
      counterText,
      helper,
      error,
      counter,
      labelText,
      label,
      floatingLabelBehavior,
      floatingLabelAlignment,
      alignLabelWithHint,
      prefix,
      suffix,
      prefixText,
      suffixText,
      prefixIcon,
      suffixIcon,
      prefixIconConstraints,
      suffixIconConstraints,
      hintText,
      hint,
      hintMaxLines,
    ]);
  }

  static bool _edgeInsetsGeometryEquals(
      EdgeInsetsGeometry? a,
      EdgeInsetsGeometry? b,
      ) {
    if (a == null || b == null) return a == b;

    return a.resolve(TextDirection.ltr) == b.resolve(TextDirection.ltr);
  }

  static int _edgeInsetsGeometryHash(EdgeInsetsGeometry? value) {
    if (value == null) return 0;

    return value.resolve(TextDirection.ltr).hashCode;
  }

  static bool _inputBorderHeightEquals(
      InputBorder? a,
      InputBorder? b,
      ) {
    if (a == null || b == null) return a == b;

    return a.runtimeType == b.runtimeType &&
        a.isOutline == b.isOutline &&
        a.dimensions == b.dimensions &&
        a.borderSide.width == b.borderSide.width &&
        a.borderSide.style == b.borderSide.style;
  }

  static int _inputBorderHeightHash(InputBorder? border) {
    if (border == null) return 0;

    return Object.hash(
      border.runtimeType,
      border.isOutline,
      border.dimensions,
      border.borderSide.width,
      border.borderSide.style,
    );
  }
}