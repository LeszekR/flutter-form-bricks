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
}