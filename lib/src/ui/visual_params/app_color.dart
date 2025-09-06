import 'package:flutter/material.dart';

import 'app_style.dart';

class AppColor {
  AppColor._();

  static var colorSchemeMain = ColorScheme.fromSeed(
    seedColor: AppColor.seedColor,
    brightness: Brightness.light,
  );

  // Colors
  static const Color _white = Colors.white;
  static const Color _yellow = Colors.yellow;
  static const Color _red = Colors.red;
  static const Color _black = Colors.black;
  static const Color _greyLightest = Color.fromARGB(255, 245, 245, 245);
  static const Color _greyLight = Color.fromARGB(255, 236, 236, 236);
  static const Color _greyMedium = Color.fromARGB(255, 222, 222, 222);
  static const Color _greyDark = Color.fromARGB(255, 140, 140, 140);

  static const seedColor = Color.fromARGB(255, 101, 224, 190);

  // static const seedColor =  Color.fromARGB(255, 86, 148, 59);

  static var borderEnabled = colorSchemeMain.outline;
  static var borderDisabled = _greyMedium;
  static var borderError = _red; //colorSchemeMain.error;

  static var formWindowBackground = colorSchemeMain.surfaceContainerLow;
  static var formWorkAreaBackground = _greyLightest;

  static var formButtonBackground = colorSchemeMain.surfaceContainerHigh;
  static var formButtonForeground = colorSchemeMain.onSecondaryFixed;

  static var formFieldFillOk = _white;
  static var formFieldFillHovered = AppColor.colorSchemeMain.surfaceContainerLow;
  static var formFieldFillFocused = AppColor.colorSchemeMain.surfaceContainerLow;
  static var formFieldFillPressed = AppColor.colorSchemeMain.surfaceContainerHigh;
  static var formFieldFillSelected = AppColor.colorSchemeMain.surfaceContainerHighest;
  static var formFieldFillDisabled = _greyLight;
  static var formFieldFillError = AppColor.colorSchemeMain.errorContainer;

  static const Color buttonFontEnabled = _black;
  static const Color buttonFontDisabled = _greyDark;

  static const Color tabFontActive = _greyDark;
  static const Color tabFontDisabled = _greyDark;
  static const Color tabFontEnabled = _black;
  static const Color tabFontError = _black;

  static var tabEnabled = colorSchemeMain.surfaceContainerHigh;
  static var tabDisabled = _greyLight;

  // static var tabDisabled = colorSchemeMain.surfaceContainerHighest;
  static var tabError = AppStyle.mainTheme().colorScheme.errorContainer;

  static var inputBackgroundDefault = _white;
  static var inputBackgroundIncorrect = _yellow;

  static var inputBackgroundEmptyObligatory = _red;

  static var iconColor = Colors.black.withOpacity(1);

  static var radioSelected = colorSchemeMain.surfaceContainerHighest;
  static var radioUnselected = formFieldFillOk;

  static WidgetStateColor makeWidgetStateColor(Set<WidgetState> states) {
    Color stateColor = makeColor(states);
    return WidgetStateColor.resolveWith((states) => stateColor);
  }

  static Color makeColor(Set<WidgetState> states) {
    // print('AppColor: ${states.toString()}');
    return switch (states) {
      _ when states.contains(WidgetState.disabled) => AppColor.formFieldFillDisabled,
      _ when states.contains(WidgetState.error) => AppColor.formFieldFillError,
      _ when states.contains(WidgetState.focused) => AppColor.formFieldFillFocused,
      _ when states.contains(WidgetState.hovered) => AppColor.formFieldFillHovered,
      _ when states.contains(WidgetState.pressed) => AppColor.formFieldFillPressed,
      _ when states.contains(WidgetState.selected) => AppColor.formFieldFillSelected,
      _ => AppColor.formFieldFillOk,
    };
  }

  static WidgetStateColor textColor(Set<WidgetState> states) {
    Color stateColor;
    stateColor = switch (states) {
      _ when states.contains(WidgetState.disabled) => AppColor.tabFontDisabled,
      _ when states.contains(WidgetState.error) => AppColor.colorSchemeMain.onError,
      _ => AppColor.tabFontEnabled,
    };
    return WidgetStateColor.resolveWith((states) => stateColor);
  }
}
