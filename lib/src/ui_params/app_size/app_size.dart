import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

abstract class AppSize {
  AppSize({required this.zoom});

  /// Base scaling factor (from AppScale, or const 1.0 if no scaling)
  double zoom;

  double? get verticalVisualDensity;

  double? get horizontalVisualDensity;

  static double getVerticalVisualDensity({
    double? visualDensity,
    BuildContext? context,
    InputDecoration? inputDecoration,
  }) {
    return visualDensity ??
        inputDecoration?.visualDensity?.vertical ??
        (context == null ? null : UiParams.of(context).appTheme.inputDecorationThemeData.visualDensity?.vertical) ??
        (context == null ? null : UiParams.of(context).appSize.verticalVisualDensity) ??
        0;
  }

  static double getHorizontalVisualDensity({
    double? visualDensity,
    BuildContext? context,
    InputDecoration? inputDecoration,
  }) {
    return visualDensity ??
        inputDecoration?.visualDensity?.horizontal ??
        (context == null ? null : UiParams.of(context).appTheme.inputDecorationThemeData.visualDensity?.horizontal) ??
        (context == null ? null : UiParams.of(context).appSize.horizontalVisualDensity) ??
        0;
  }

  static double textFieldButtonWidth({
    double? visualDensity,
    BuildContext? context,
    InputDecoration? inputDecoration,
  }) {
    double visualDensityValue = getHorizontalVisualDensity(
      visualDensity: visualDensity,
      context: context,
      inputDecoration: inputDecoration,
    );
    assert(visualDensityValue >= -4 && visualDensityValue <= 4, 'horizontalVisualDensity must be between -4 and 4');
    return max(20, 32 + 4 * visualDensityValue);
  }

  static double textFieldButtonHeight({
    double? visualDensity,
    BuildContext? context,
    InputDecoration? inputDecoration,
  }) {
    double visualDensityValue = getVerticalVisualDensity(
      visualDensity: visualDensity,
      context: context,
      inputDecoration: inputDecoration,
    );
    assert(visualDensityValue >= -4 && visualDensityValue <= 4, 'verticalVisualDensity must be between -4 and 4');
    return 28 + 4 * visualDensityValue;
  }

  // fonts
  double calculateFontSize(double size) => zoom * (fontSmallest + fontIncrement * size);

  double get fontSmallest;

  double get fontIncrement;

  double get fontSize1;

  double get fontSize2;

  double get fontSize3;

  double get fontSize4;

  double get fontSize5;

  double get fontSize6;

  double get fontSize7;

  double get fontSize8;

  double get fontSize9;

  // dimensions
  double get cornerRadius;

  double get appBarHeight;

  double get formBarHeight;

  double get menuBarHeight;

  double get menuButtonWidth;

  double get tabHeight;

  double get tabWidth;

  double get borderWidth;

  BorderRadiusGeometry get borderRadius;

  double get tabBorderWidth;

  double get bottomPanelHeight;

  double get labelHeight;

  double get inputLabelHeight;

  double get textFieldWidth;

  double get dateFieldWidth;

  double get timeFieldWidth;

  double get numberFieldWidth;

  double get inputLabelWidth;

  double get inputTextLineHeight;

  double get iconSize;

  double get checkboxScaleSquare;

  double get checkboxScaleRound;

  double get radioScale;

  double get popupFormSpacing;

  double get tabMinWidth;

  double get buttonWidth;

  double get buttonHeight;

  double get buttonFontSize;

  double get buttonScaleWidth;

  double get buttonSpacingHorizontal;

  double get buttonScaleHeight;

  double get tableRowHeight;

  double get scrollBarWidth;

  // insets, padding
  double get paddingTabsConstant;

  double get paddingTabsVertical;

  double get paddingButton;

  double get paddingTableCell;

  double get paddingForm;

  double get paddingInputText;

  double get paddingInputLabel;

  double get dialogContentInsetTop;

  double get dialogContentInsetBottom;

  double get dialogContentInsetSide;

  double get scaffoldInsetsHorizontal;

  double get scaffoldInsetsVertical;

  double get dashboardTileInsets;

  double get dashboardTileShadowOffset;

  double get spinnerInsets;

  // spacers
  double get spacerVerticalSmallest;

  double get spacerVerticalSmall;

  double get spacerVerticalMedium;

  double get spacerHorizontalSmallest;

  double get spacerHorizontalSmall;

  double get spacerHorizontalMedium;
}
