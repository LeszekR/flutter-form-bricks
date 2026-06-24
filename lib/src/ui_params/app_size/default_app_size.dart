import 'package:flutter/material.dart';

import 'app_size.dart';

class DefaultAppSize extends AppSize {

  DefaultAppSize({super.zoom = 1});

  // fonts
  @override final double fontSmallest = 7;
  @override final double fontIncrement = 1.5;
  @override late final fontSize1 = calculateFontSize(1);
  @override late final fontSize2 = calculateFontSize(2);
  @override late final fontSize3 = calculateFontSize(3);
  @override late final fontSize4 = calculateFontSize(4);
  @override late final fontSize5 = calculateFontSize(5);
  @override late final fontSize6 = calculateFontSize(6);
  @override late final fontSize7 = calculateFontSize(7);
  @override late final fontSize8 = calculateFontSize(8);
  @override late final fontSize9 = calculateFontSize(9);

  // dimensions
  @override late final double textFieldWidth = 200;
  @override late final double dateFieldWidth = 130;
  @override late final double timeFieldWidth = 90;
  @override late final buttonDistanceFromTextField = 0;
  @override late final double inputDecorationPaddingHorizontal = 10;
  @override late final double inputDecorationPaddingVertical = 10;
  @override late final double borderWidth = 1;
  @override late final double borderDoubleWidth = 2;

  // spacers
  @override late final double spacerVerticalSmallest = 4.0;
  @override late final double spacerVerticalSmall = 8.0;
  @override late final double spacerVerticalMedium = 16;
  @override late final double spacerHorizontalSmallest = 4.0;
  @override late final double spacerHorizontalSmall = 8.0;
  @override late final double spacerHorizontalMedium = 16;


  // USED? REMOVE?
  // =========================================================
  @override late final double cornerRadius = 0;
  @override late final double appBarHeight = 34;
  @override late final double formBarHeight = 34;
  @override late final double menuBarHeight = 34;
  @override late final double menuButtonWidth = 110;
  @override late final double tabHeight = 28;
  @override late final double tabWidth = 70;
  @override late final BorderRadiusGeometry borderRadius = BorderRadius.zero;
  @override late final double tabBorderWidth = 1.5;
  @override late final double bottomPanelHeight = 120;
  @override late final double labelHeight = 20;
  @override late final double numberFieldWidth = 50;

  @override late final double inputLabelWidth = 180;
  @override late final double inputLabelHeight = fontSize2 + paddingInputLabel * 2; // using fontSize2 as proxy

  @override late final double inputTextLineHeight = 25;
  @override late final double iconSize = inputTextLineHeight * 0.7;
  @override late final double checkboxScaleSquare = 0.7;
  @override late final double checkboxScaleRound = 0.8;
  @override late final double radioScale = 0.8;
  @override late final double popupFormSpacing = 10;
  @override late final double tabMinWidth = 90;

  @override late final double buttonWidth = 120;
  @override late final double buttonHeight = 35;
  @override late final double buttonFontSize = 14;
  @override late final double buttonScaleWidth = 90;
  @override late final double buttonSpacingHorizontal = 10;
  @override late final double buttonScaleHeight = 60;

  @override late final double tableRowHeight = 30;
  @override late final double scrollBarWidth = 15;

  @override late final double paddingTabsConstant = 5;
  @override late final double paddingTabsVertical = 8;
  @override late final double paddingButton = 7;
  @override late final double paddingTableCell = 2;
  @override late final double paddingForm = 10;
  @override late final double paddingInputText = 4;
  @override late final double paddingInputLabel = 4;

  @override late final double dialogContentInsetTop = 30;
  @override late final double dialogContentInsetBottom = 22;
  @override late final double dialogContentInsetSide = 27;
  @override late final double scaffoldInsetsHorizontal = 10;
  @override late final double scaffoldInsetsVertical = 10;
  @override late final double dashboardTileInsets = 10;
  @override late final double dashboardTileShadowOffset = 2;
  @override late final double spinnerInsets = 20;

}
