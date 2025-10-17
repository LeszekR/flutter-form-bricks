import 'package:flutter/material.dart';

import 'app_size.dart';

class DefaultAppSize extends AppSize {

  DefaultAppSize({super.zoom = 1.0});

  @override final double fontSmallest = 7;
  @override final  double fontIncrement = 1.5;

  @override late final fontSize1 = calculateFontSize(1);
  @override late final fontSize2 = calculateFontSize(2);
  @override late final fontSize3 = calculateFontSize(3);
  @override late final fontSize4 = calculateFontSize(4);
  @override late final fontSize5 = calculateFontSize(5);
  @override late final fontSize6 = calculateFontSize(6);
  @override late final fontSize7 = calculateFontSize(7);
  @override late final fontSize8 = calculateFontSize(8);
  @override late final fontSize9 = calculateFontSize(9);

  @override late final double cornerRadius = 0;
  @override late final double appBarHeight = zoom * 34;
  @override late final double formBarHeight = zoom * 34;
  @override late final double menuBarHeight = zoom * 34;
  @override late final double menuButtonWidth = zoom * 110;
  @override late final double tabHeight = zoom * 28;
  @override late final double tabWidth = zoom * 70;
  @override late final double borderWidth = zoom * 0.5;
  @override late final BorderRadiusGeometry borderRadius = BorderRadius.zero;
  @override late final double tabBorderWidth = zoom * 1.5;
  @override late final double bottomPanelHeight = zoom * 120;
  @override late final double labelHeight = zoom * 20;
  @override late final double textFieldWidth = zoom * 200;
  @override late final double dateFieldWidth = zoom * 105;
  @override late final double timeFieldWidth = zoom * 65;
  @override late final double numberFieldWidth = zoom * 50;

  @override late final double inputLabelWidth = zoom * 180;
  @override late final double inputLabelHeight = fontSize2 + paddingInputLabel * 2; // using fontSize2 as proxy

  @override late final double inputTextLineHeight = zoom * 25;
  @override late final double textFieldButtonWidth = inputTextLineHeight;
  @override late final double textFieldButtonHeight = inputTextLineHeight;
  @override late final double iconSize = inputTextLineHeight * 0.7;
  @override late final double checkboxScaleSquare = 0.7;
  @override late final double checkboxScaleRound = 0.8;
  @override late final double radioScale = 0.8;
  @override late final double popupFormSpacing = zoom * 10;
  @override late final double tabMinWidth = zoom * 90;

  @override late final double buttonWidth = zoom * 120;
  @override late final double buttonHeight = zoom * 35;
  @override late final double buttonFontSize = zoom * 14;
  @override late final double buttonScaleWidth = zoom * 90;
  @override late final double buttonSpacingHorizontal = zoom * 10;
  @override late final double buttonScaleHeight = zoom * 60;

  @override late final double tableRowHeight = zoom * 30;
  @override late final double scrollBarWidth = zoom * 15;

  @override late final double paddingTabsConstant = zoom * 5;
  @override late final double paddingTabsVertical = zoom * 8;
  @override late final double paddingButton = zoom * 7;
  @override late final double paddingTableCell = zoom * 2;
  @override late final double paddingForm = zoom * 10;
  @override late final double paddingInputText = zoom * 4;
  @override late final double paddingInputLabel = zoom * 4;

  @override late final double dialogContentInsetTop = zoom * 30;
  @override late final double dialogContentInsetBottom = zoom * 22;
  @override late final double dialogContentInsetSide = zoom * 27;
  @override late final double scaffoldInsetsHorizontal = zoom * 10;
  @override late final double scaffoldInsetsVertical = zoom * 10;
  @override late final double dashboardTileInsets = zoom * 10;
  @override late final double dashboardTileShadowOffset = zoom * 2;
  @override late final double spinnerInsets = zoom * 20;

  @override late final SizedBox spacerBoxVerticalSmallest = SizedBox(height: zoom * 3.0);
  @override late final SizedBox spacerBoxVerticalSmall = SizedBox(height: zoom * 10.0);
  @override late final SizedBox spacerBoxVerticalMedium = SizedBox(height: zoom * 20);
  @override late final SizedBox spacerBoxHorizontalSmallest = SizedBox(width: zoom * 3.0);
  @override late final SizedBox spacerBoxHorizontalSmall = SizedBox(width: zoom * 10.0);
  @override late final SizedBox spacerBoxHorizontalMedium = SizedBox(width: zoom * 20);
}
