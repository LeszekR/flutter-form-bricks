import 'package:flutter/material.dart';

abstract class AppColor {
  const AppColor(this.seedColor);

  // Base scheme
  ColorScheme get colorSchemeMain;

  // Base palette
  final Color seedColor;
  Color get white;
  Color get yellow;
  Color get red;
  Color get black;
  Color get greyLightest;
  Color get greyLight;
  Color get greyMedium;
  Color get greyDark;

  // Borders
  Color get borderEnabled;
  Color get borderDisabled;
  Color get borderError;

  // Forms
  Color get formWindowBackground;
  Color get formWorkAreaBackground;

  Color get formButtonBackground;
  Color get formButtonForeground;

  Color get formFieldFillOk;
  Color get formFieldFillHovered;
  Color get formFieldFillFocused;
  Color get formFieldFillPressed;
  Color get formFieldFillSelected;
  Color get formFieldFillDisabled;
  Color get formFieldFillError;

  // Buttons
  Color get buttonFontEnabled;
  Color get buttonFontDisabled;

  // Tabs
  Color get tabFontActive;
  Color get tabFontDisabled;
  Color get tabFontEnabled;
  Color get tabFontError;

  Color get tabEnabled;
  Color get tabDisabled;
  Color get tabError;

  // Inputs
  Color get inputBackgroundDefault;
  Color get inputBackgroundIncorrect;
  Color get inputBackgroundEmptyObligatory;

  // Misc
  Color get iconColor;
  Color get radioSelected;
  Color get radioUnselected;

  WidgetStateColor fillColor(Set<WidgetState> states) {
    final stateColor = makeColor(states);
    return WidgetStateColor.resolveWith((_) => stateColor);
  }

  Color makeColor(Set<WidgetState> states) {
    return switch (states) {
    _ when states.contains(WidgetState.disabled) => formFieldFillDisabled,
    _ when states.contains(WidgetState.error) => formFieldFillError,
    _ when states.contains(WidgetState.focused) => formFieldFillFocused,
    _ when states.contains(WidgetState.hovered) => formFieldFillHovered,
    _ when states.contains(WidgetState.pressed) => formFieldFillPressed,
    _ when states.contains(WidgetState.selected) => formFieldFillSelected,
    _ => formFieldFillOk,
    };
  }

  WidgetStateColor textColor(Set<WidgetState> states) {
    final stateColor = switch (states) {
    _ when states.contains(WidgetState.disabled) => tabFontDisabled,
    _ when states.contains(WidgetState.error) => colorSchemeMain.onError,
    _ => tabFontEnabled,
    };
    return WidgetStateColor.resolveWith((_) => stateColor);
  }
}


// import 'package:flutter/material.dart';
//
// import '../app_style/app_style.dart';
//
// abstract class AppColor {
//   const AppColor();
//
//   // TODO go through all, remove redundant, correct names
//
//   /// Base scheme
//   ColorScheme get colorSchemeMain;
//
//   /// Base palette
//   Color get seedColor;
//   Color get white;
//   Color get yellow;
//   Color get red;
//   Color get black;
//   Color get greyLightest;
//   Color get greyLight;
//   Color get greyMedium;
//   Color get greyDark;
//
//   /// Borders
//   Color get borderEnabled;
//   Color get borderDisabled;
//   Color get borderError;
//
//   /// Forms
//   Color get formWindowBackground;
//   Color get formWorkAreaBackground;
//
//   Color get formButtonBackground;
//   Color get formButtonForeground;
//
//   Color get formFieldFillOk;
//   Color get formFieldFillHovered;
//   Color get formFieldFillFocused;
//   Color get formFieldFillPressed;
//   Color get formFieldFillSelected;
//   Color get formFieldFillDisabled;
//   Color get formFieldFillError;
//
//   /// Buttons
//   Color get buttonFontEnabled;
//   Color get buttonFontDisabled;
//
//   /// Tabs
//   Color get tabFontActive;
//   Color get tabFontDisabled;
//   Color get tabFontEnabled;
//   Color get tabFontError;
//
//   Color get tabEnabled;
//   Color get tabDisabled;
//   Color get tabError;
//
//   /// Inputs
//   Color get inputBackgroundDefault;
//   Color get inputBackgroundIncorrect;
//   Color get inputBackgroundEmptyObligatory;
//
//   /// Misc
//   Color get iconColor;
//   Color get radioSelected;
//   Color get radioUnselected;
//
//   /// State ui_helpers
//   WidgetStateColor makeWidgetStateColor(Set<WidgetState> states) {
//     final stateColor = makeColor(states);
//     return WidgetStateColor.resolveWith((_) => stateColor);
//   }
//
//   Color makeColor(Set<WidgetState> states) {
//     return switch (states) {
//     _ when states.contains(WidgetState.disabled) => formFieldFillDisabled,
//     _ when states.contains(WidgetState.error) => formFieldFillError,
//     _ when states.contains(WidgetState.focused) => formFieldFillFocused,
//     _ when states.contains(WidgetState.hovered) => formFieldFillHovered,
//     _ when states.contains(WidgetState.pressed) => formFieldFillPressed,
//     _ when states.contains(WidgetState.selected) => formFieldFillSelected,
//     _ => formFieldFillOk,
//     };
//   }
//
//   WidgetStateColor textColor(Set<WidgetState> states) {
//     final stateColor = switch (states) {
//     _ when states.contains(WidgetState.disabled) => tabFontDisabled,
//     _ when states.contains(WidgetState.error) => colorSchemeMain.onError,
//     _ => tabFontEnabled,
//     };
//     return WidgetStateColor.resolveWith((_) => stateColor);
//   }
// }
