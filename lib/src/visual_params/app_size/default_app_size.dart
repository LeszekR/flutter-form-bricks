import 'package:flutter/cupertino.dart';

import 'app_size.dart';

class DefaultAppSize extends AppSize {
  @override
  final double zoom;

  const DefaultAppSize({this.zoom = 1.0});

  static const double fontSmallest = 7;
  static const double fontIncrement = 1.5;

  @override
  double get cornerRadius => 0;

  double get _barHeight => zoom * 34;

  @override
  double get appBarHeight => _barHeight;

  @override
  double get formBarHeight => _barHeight;

  @override
  double get menuBarHeight => _barHeight;

  @override
  double get menuButtonWidth => zoom * 110;

  @override
  double get tabHeight => zoom * 28;

  @override
  double get tabWidth => zoom * 70;

  @override
  double get borderWidth => zoom * 0.5;

  @override
  double get tabBorderWidth => zoom * 1.5;

  @override
  double get bottomPanelHeight => zoom * 120;

  @override
  double get labelHeight => zoom * 20;

  @override
  double get inputTextWidth => zoom * 200;

  @override
  double get inputDateWidth => zoom * 105;

  @override
  double get inputTimeWidth => zoom * 65;

  @override
  double get inputNumberWidth => zoom * 50;

  @override
  double get inputLabelWidth => zoom * 180;

  @override
  double get inputLabelHeight => fontSize2 + paddingInputLabel * 2; // using fontSize2 as proxy

  @override
  double get inputTextLineHeight => zoom * 25;

  @override
  double get textFieldButtonWidth => inputTextLineHeight;

  @override
  double get textFieldButtonHeight => inputTextLineHeight;

  @override
  double get iconSize => inputTextLineHeight * 0.7;

  @override
  double get checkboxScaleSquare => 0.7;

  @override
  double get checkboxScaleRound => 0.8;

  @override
  double get radioScale => 0.8;

  @override
  double get popupFormSpacing => zoom * 10;

  @override
  double get tabMinWidth => zoom * 90;

  @override
  double get buttonWidth => zoom * 120;

  @override
  double get buttonHeight => zoom * 35;

  @override
  double get buttonFontSize => zoom * 14;

  @override
  double get buttonScaleWidth => zoom * 90;

  @override
  double get buttonSpacingHorizontal => zoom * 10;

  @override
  double get buttonScaleHeight => zoom * 60;

  @override
  double get tableRowHeight => zoom * 30;

  @override
  double get scrollBarWidth => zoom * 15;

  @override
  double get paddingTabsConstant => zoom * 5;

  @override
  double get paddingTabsVertical => zoom * 8;

  @override
  double get paddingButton => zoom * 7;

  @override
  double get paddingTableCell => zoom * 2;

  @override
  double get paddingForm => zoom * 10;

  @override
  double get paddingInputText => zoom * 4;

  @override
  double get paddingInputLabel => zoom * 4;

  @override
  double get dialogContentInsetTop => zoom * 30;

  @override
  double get dialogContentInsetBottom => zoom * 22;

  @override
  double get dialogContentInsetSide => zoom * 27;

  @override
  double get scaffoldInsetsHorizontal => zoom * 10;

  @override
  double get scaffoldInsetsVertical => zoom * 10;

  @override
  double get dashboardTileInsets => zoom * 10;

  @override
  double get dashboardTileShadowOffset => zoom * 2;

  @override
  double get spinnerInsets => zoom * 20;

  @override
  double get fontSize1 => zoom * (fontSmallest + fontIncrement * 1);

  @override
  double get fontSize2 => zoom * (fontSmallest + fontIncrement * 2);

  @override
  double get fontSize3 => zoom * (fontSmallest + fontIncrement * 3);

  @override
  double get fontSize4 => zoom * (fontSmallest + fontIncrement * 4);

  @override
  double get fontSize5 => zoom * (fontSmallest + fontIncrement * 5);

  @override
  double get fontSize6 => zoom * (fontSmallest + fontIncrement * 6);

  @override
  double get fontSize7 => zoom * (fontSmallest + fontIncrement * 7);

  @override
  double get fontSize8 => zoom * (fontSmallest + fontIncrement * 8);

  @override
  double get fontSize9 => zoom * (fontSmallest + fontIncrement * 9);

  @override
  SizedBox get spacerBoxVerticalSmallest => SizedBox(height: zoom * 3.0);

  @override
  SizedBox get spacerBoxVerticalSmall => SizedBox(height: zoom * 10.0);

  @override
  SizedBox get spacerBoxVerticalMedium => SizedBox(height: zoom * 20);

  @override
  SizedBox get spacerBoxHorizontalSmallest => SizedBox(width: zoom * 3.0);

  @override
  SizedBox get spacerBoxHorizontalSmall => SizedBox(width: zoom * 10.0);

  @override
  SizedBox get spacerBoxHorizontalMedium => SizedBox(width: zoom * 20);
}
