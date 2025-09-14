import 'package:flutter/material.dart';

import 'app_scale.dart';
import '../app_style/app_style.dart';

abstract class AppSize {
  const AppSize();

  /// Base scaling factor (from AppScale, or const 1.0 if no scaling)
  double get s;

  // dimensions
  double get cornerRadius;

  double get appBarHeight;
  double get formBarHeight;
  double get menuBarHeight;
  double get menuButtonWidth;
  double get tabHeight;
  double get tabWidth;

  double get borderWidth;
  double get tabBorderWidth;
  double get bottomPanelHeight;

  double get labelHeight;

  double get inputTextWidth;
  double get inputDateWidth;
  double get inputTimeWidth;
  double get inputNumberWidth;
  double get inputLabelWidth;
  double get inputLabelHeight;
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

  // fonts
  double get fontSize1;
  double get fontSize2;
  double get fontSize3;
  double get fontSize4;
  double get fontSize5;
  double get fontSize6;
  double get fontSize7;
  double get fontSize8;
  double get fontSize9;

  // spacers
  SizedBox get spacerBoxVerticalSmallest;
  SizedBox get spacerBoxVerticalSmall;
  SizedBox get spacerBoxVerticalMedium;
  SizedBox get spacerBoxHorizontalSmallest;
  SizedBox get spacerBoxHorizontalSmall;
  SizedBox get spacerBoxHorizontalMedium;
}
