import 'package:flutter/material.dart';

import 'app_color.dart';

class DefaultAppColor extends AppColor {
  DefaultAppColor(super.seedColor);

  @override
  late final ColorScheme colorSchemeMain = ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light);

  // ========== Base palette ==========
  @override late final Color white = Colors.white;
  @override late final Color yellow = Colors.yellow;
  @override late final Color red = Colors.red;
  @override late final Color black = Colors.black;
  @override late final Color greyLightest = const Color.fromARGB(255, 245, 245, 245);
  @override late final Color greyLight = const Color.fromARGB(255, 236, 236, 236);
  @override late final Color greyMedium = const Color.fromARGB(255, 222, 222, 222);
  @override late final Color greyDark = const Color.fromARGB(255, 140, 140, 140);

  // ========== Borders ==========
  @override late final Color borderEnabled = colorSchemeMain.outline;
  @override late final Color borderDisabled = greyMedium;
  @override late final Color borderError = red;

  // ========== Forms ==========
  @override late final Color formWindowBackground = colorSchemeMain.surfaceContainerLow;
  @override late final Color formWorkAreaBackground = greyLightest;
  @override late final Color formButtonBackground = colorSchemeMain.surfaceContainerHigh;
  @override late final Color formButtonForeground = colorSchemeMain.onSecondaryFixed;
  @override late final Color formFieldFillOk = white;
  @override late final Color formFieldFillHovered = colorSchemeMain.surfaceContainerLow;
  @override late final Color formFieldFillFocused = colorSchemeMain.surfaceContainerLow;
  @override late final Color formFieldFillPressed = colorSchemeMain.surfaceContainerHigh;
  @override late final Color formFieldFillSelected = colorSchemeMain.surfaceContainerHighest;
  @override late final Color formFieldFillDisabled = greyLight;
  @override late final Color formFieldFillError = colorSchemeMain.errorContainer;

  // ========== Buttons ==========
  @override late final Color buttonFontEnabled = black;
  @override late final Color buttonFontDisabled = greyDark;

  // ========== Tabs ==========
  @override late final Color tabFontActive = greyDark;
  @override late final Color tabFontDisabled = greyDark;
  @override late final Color tabFontEnabled = black;
  @override late final Color tabFontError = black;
  @override late final Color tabEnabled = colorSchemeMain.surfaceContainerHigh;
  @override late final Color tabDisabled = greyLight;
  @override late final Color tabError = colorSchemeMain.errorContainer;

  // ========== Inputs ==========
  @override late final Color inputBackgroundDefault = white;
  @override late final Color inputBackgroundIncorrect = yellow;
  @override late final Color inputBackgroundEmptyObligatory = red;

  // ========== Misc ==========
  @override late final Color iconColor = Colors.black;
  @override late final Color radioSelected = colorSchemeMain.surfaceContainerHighest;
  @override late final Color radioUnselected = formFieldFillOk;
}