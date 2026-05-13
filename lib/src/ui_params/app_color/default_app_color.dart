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
  @override late final Color formFieldFillFocused = colorSchemeMain.surfaceContainerHighest; //colorSchemeMain.surfaceContainerLow;
  @override late final Color formFieldFillPressed = colorSchemeMain.surfaceContainerHighest; //colorSchemeMain.surfaceContainerHigh;
  @override late final Color formFieldFillSelected = white; //colorSchemeMain.surfaceContainerHighest;
  @override late final Color formFieldFillDisabled = greyLight;
  @override late final Color formFieldFillError = colorSchemeMain.errorContainer;

  // @override Color getFormFieldHovered() => Color.lerp(formFieldFillHovered, Colors.white, 0.95)!;
  // @override Color getFormFieldFocused() => Color.lerp(formFieldFillFocused, Colors.white, 0.95)!;
  // @override Color getFormFieldSelected() => Color.lerp(formFieldFillSelected, Colors.white, 0.95)!;
  // @override Color getFormFieldPressed() => Color.lerp(formFieldFillPressed, Colors.white, 0.95)!;

  @override Color getFormFieldHovered() => _lerp('formFieldFillHovered',formFieldFillHovered, Colors.white, 0.10);
  @override Color getFormFieldFocused() => _lerp('formFieldFillFocused', formFieldFillFocused, Colors.white, 0.80);
  @override Color getFormFieldSelected() => _lerp('formFieldFillSelected', formFieldFillSelected, formFieldFillSelected, 0.70);
  @override Color getFormFieldPressed() => _lerp('formFieldFillPressed', formFieldFillPressed, formFieldFillPressed, 0.70);
  // @override Color getFormFieldHovered() => _lerp('formFieldFillHovered',formFieldFillHovered, Colors.white, 0.20);
  // @override Color getFormFieldFocused() => _lerp('formFieldFillFocused', formFieldFillFocused, Colors.white, 0.20);
  // @override Color getFormFieldSelected() => _lerp('formFieldFillSelected', formFieldFillSelected, Colors.white, 0.20);
  // @override Color getFormFieldPressed() => _lerp('formFieldFillPressed', formFieldFillPressed, Colors.white, 0.20);

  Color _lerp(String name, Color from, Color to, double factor) {
    Color? color = _lerpMap[name];
    if (color == null) {
      color = Color.lerp(from,to, factor)!;
    }
    _lerpMap[name] = color;
    return color;
  }

  Map<String, Color> _lerpMap = {};

  @override late final Color formFieldBorderOk = Colors.black;
  @override late final Color formFieldBorderHovered = Colors.black;
  @override late final Color formFieldBorderFocused = Colors.black;
  @override late final Color formFieldBorderPressed = Colors.black;
  @override late final Color formFieldBorderSelected = Colors.black;
  @override late final Color formFieldBorderDisabled = Colors.black;
  @override late final Color formFieldBorderError = Colors.red;

  // ========== Buttons =========
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
  @override late final Color dialogBarrier = colorSchemeMain.onPrimaryContainer.withValues(alpha: 0.2);

  // ========== Text ==========
  @override late final Color textError = red;
}
