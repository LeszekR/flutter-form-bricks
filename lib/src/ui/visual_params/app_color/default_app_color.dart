import 'package:flutter/material.dart';

import '../app_style/app_style.dart';
import 'app_color.dart';

class DefaultAppColor extends AppColor {
  const DefaultAppColor();

  @override
  Color get seedColor => const Color.fromARGB(255, 101, 224, 190);

  @override
  ColorScheme get colorSchemeMain =>
      ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light);

  // Base palette
  @override
  Color get white => Colors.white;
  @override
  Color get yellow => Colors.yellow;
  @override
  Color get red => Colors.red;
  @override
  Color get black => Colors.black;
  @override
  Color get greyLightest => const Color.fromARGB(255, 245, 245, 245);
  @override
  Color get greyLight => const Color.fromARGB(255, 236, 236, 236);
  @override
  Color get greyMedium => const Color.fromARGB(255, 222, 222, 222);
  @override
  Color get greyDark => const Color.fromARGB(255, 140, 140, 140);

  // Borders
  @override
  Color get borderEnabled => colorSchemeMain.outline;
  @override
  Color get borderDisabled => greyMedium;
  @override
  Color get borderError => red;

  // Forms
  @override
  Color get formWindowBackground => colorSchemeMain.surfaceContainerLow;
  @override
  Color get formWorkAreaBackground => greyLightest;

  @override
  Color get formButtonBackground => colorSchemeMain.surfaceContainerHigh;
  @override
  Color get formButtonForeground => colorSchemeMain.onSecondaryFixed;

  @override
  Color get formFieldFillOk => white;
  @override
  Color get formFieldFillHovered => colorSchemeMain.surfaceContainerLow;
  @override
  Color get formFieldFillFocused => colorSchemeMain.surfaceContainerLow;
  @override
  Color get formFieldFillPressed => colorSchemeMain.surfaceContainerHigh;
  @override
  Color get formFieldFillSelected => colorSchemeMain.surfaceContainerHighest;
  @override
  Color get formFieldFillDisabled => greyLight;
  @override
  Color get formFieldFillError => colorSchemeMain.errorContainer;

  // Buttons
  @override
  Color get buttonFontEnabled => black;
  @override
  Color get buttonFontDisabled => greyDark;

  // Tabs
  @override
  Color get tabFontActive => greyDark;
  @override
  Color get tabFontDisabled => greyDark;
  @override
  Color get tabFontEnabled => black;
  @override
  Color get tabFontError => black;

  @override
  Color get tabEnabled => colorSchemeMain.surfaceContainerHigh;
  @override
  Color get tabDisabled => greyLight;
  @override
  Color get tabError => colorSchemeMain.errorContainer;

  // Inputs
  @override
  Color get inputBackgroundDefault => white;
  @override
  Color get inputBackgroundIncorrect => yellow;
  @override
  Color get inputBackgroundEmptyObligatory => red;

  // Misc
  @override
  Color get iconColor => Colors.black.withOpacity(1);
  @override
  Color get radioSelected => colorSchemeMain.surfaceContainerHighest;
  @override
  Color get radioUnselected => formFieldFillOk;
}
