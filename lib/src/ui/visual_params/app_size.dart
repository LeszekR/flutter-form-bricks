import 'package:flutter/material.dart';

import 'app_scale.dart';
import 'app_style.dart';

class AppSize {
  AppSize._();

  // dimensions
  // TODO inject AppScale
  static var s = AppScale().getScale() * 1;
  static const fontSmallest = 7;
  static const fontIncrement = 1.5;

  static double cornerRadius = 0;

  // static BorderRadius borderRadius = BorderRadius.zero;

  static final double _barHeight = s * 34;
  static double appBarHeight = _barHeight;
  static double formBarHeight = _barHeight;
  static double menuBarHeight = _barHeight;
  static double menuButtonWidth = s * 110;
  static double tabHeight = s * 28;
  static double tabWidth = s * 70;

  static double borderWidth = s * 0.5;
  static double tabBorderWidth = s * 1.5;
  static double bottomPanelHeight = s * 120;

  static double labelHeight = s * 20;

  static double inputTextWidth = s * 200;
  static double inputDateWidth = s * 105;
  static double inputTimeWidth = s * 65;
  static double inputNumberWidth = s * 50;
  static double inputLabelWidth = s * 180;
  static double inputLabelHeight = AppStyle.inputLabelStyle().fontSize! + AppSize.paddingInputLabel * 2;
  static double inputTextLineHeight = s * 25;
  static double iconSize = inputTextLineHeight * 0.7;
  static double checkboxScaleSquare = 0.7;
  static double checkboxScaleRound = 0.8;
  static double radioScale = 0.8;

  static double popupFormSpacing = s * 10;

  static double tabMinWidth = s * 90;

  static double buttonWidth = s * 120;
  static double buttonHeight = s * 35;
  static double buttonFontSize = s * 14;
  static double buttonScaleWidth = s * 90;
  static double buttonSpacingHorizontal = s * 10;

  static double buttonScaleHeight = s * 60;

  static double tableRowHeight = s * 30;

  static double scrollBarWidth = s * 15;

  // insets, padding
  static double paddingTabsConstant = s * 5;
  static double paddingTabsVertical = s * 8;
  static double paddingButton = s * 7;
  static double paddingTableCell = s * 2;
  static double paddingForm = s * 10;
  static double paddingInputText = s * 4;
  static double paddingInputLabel = s * 4;

  static double dialogContentInsetTop = s * 30;
  static double dialogContentInsetBottom = s * 22;
  static double dialogContentInsetSide = s * 27;

  static double scaffoldInsetsHorizontal = s * 10;
  static double scaffoldInsetsVertical = s * 10;

  static double dashboardTileInsets = s * 10;
  static double dashboardTileShadowOffset = s * 2;

  static double spinnerInsets = s * 20;

  static SizedBox spacerBoxVerticalSmallest = SizedBox(height: s * 3.0);
  static SizedBox spacerBoxVerticalSmall = SizedBox(height: s * 10.0);
  static SizedBox spacerBoxVerticalMedium = SizedBox(height: s * 20);
  static SizedBox spacerBoxHorizontalSmallest = SizedBox(width: s * 3.0);
  static SizedBox spacerBoxHorizontalSmall = SizedBox(width: s * 10.0);
  static SizedBox spacerBoxHorizontalMedium = SizedBox(width: s * 20);

  // fonts
  static double fontSize_1 = s * (fontSmallest + fontIncrement * 1);
  static double fontSize_2 = s * (fontSmallest + fontIncrement * 2);
  static double fontSize_3 = s * (fontSmallest + fontIncrement * 3);
  static double fontSize_4 = s * (fontSmallest + fontIncrement * 4);
  static double fontSize_5 = s * (fontSmallest + fontIncrement * 5);
  static double fontSize_6 = s * (fontSmallest + fontIncrement * 6);
  static double fontSize_7 = s * (fontSmallest + fontIncrement * 7);
  static double fontSize_8 = s * (fontSmallest + fontIncrement * 8);
  static double fontSize_9 = s * (fontSmallest + fontIncrement * 9);
}
