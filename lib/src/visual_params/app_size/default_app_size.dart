import 'package:flutter/cupertino.dart';

import 'app_size.dart';

class DefaultAppSize extends AppSize {
  @override
  final double s;

  const DefaultAppSize({this.s = 1.0});

  static const double fontSmallest = 7;
  static const double fontIncrement = 1.5;

  @override
  double get cornerRadius => 0;

  double get _barHeight => s * 34;

  @override
  double get appBarHeight => _barHeight;

  @override
  double get formBarHeight => _barHeight;

  @override
  double get menuBarHeight => _barHeight;

  @override
  double get menuButtonWidth => s * 110;

  @override
  double get tabHeight => s * 28;

  @override
  double get tabWidth => s * 70;

  @override
  double get borderWidth => s * 0.5;

  @override
  double get tabBorderWidth => s * 1.5;

  @override
  double get bottomPanelHeight => s * 120;

  @override
  double get labelHeight => s * 20;

  @override
  double get inputTextWidth => s * 200;

  @override
  double get inputDateWidth => s * 105;

  @override
  double get inputTimeWidth => s * 65;

  @override
  double get inputNumberWidth => s * 50;

  @override
  double get inputLabelWidth => s * 180;

  @override
  double get inputLabelHeight => fontSize2 + paddingInputLabel * 2; // using fontSize2 as proxy
  @override
  double get inputTextLineHeight => s * 25;

  @override
  double get iconSize => inputTextLineHeight * 0.7;

  @override
  double get checkboxScaleSquare => 0.7;

  @override
  double get checkboxScaleRound => 0.8;

  @override
  double get radioScale => 0.8;

  @override
  double get popupFormSpacing => s * 10;

  @override
  double get tabMinWidth => s * 90;

  @override
  double get buttonWidth => s * 120;

  @override
  double get buttonHeight => s * 35;

  @override
  double get buttonFontSize => s * 14;

  @override
  double get buttonScaleWidth => s * 90;

  @override
  double get buttonSpacingHorizontal => s * 10;

  @override
  double get buttonScaleHeight => s * 60;

  @override
  double get tableRowHeight => s * 30;

  @override
  double get scrollBarWidth => s * 15;

  @override
  double get paddingTabsConstant => s * 5;

  @override
  double get paddingTabsVertical => s * 8;

  @override
  double get paddingButton => s * 7;

  @override
  double get paddingTableCell => s * 2;

  @override
  double get paddingForm => s * 10;

  @override
  double get paddingInputText => s * 4;

  @override
  double get paddingInputLabel => s * 4;

  @override
  double get dialogContentInsetTop => s * 30;

  @override
  double get dialogContentInsetBottom => s * 22;

  @override
  double get dialogContentInsetSide => s * 27;

  @override
  double get scaffoldInsetsHorizontal => s * 10;

  @override
  double get scaffoldInsetsVertical => s * 10;

  @override
  double get dashboardTileInsets => s * 10;

  @override
  double get dashboardTileShadowOffset => s * 2;

  @override
  double get spinnerInsets => s * 20;

  @override
  double get fontSize1 => s * (fontSmallest + fontIncrement * 1);

  @override
  double get fontSize2 => s * (fontSmallest + fontIncrement * 2);

  @override
  double get fontSize3 => s * (fontSmallest + fontIncrement * 3);

  @override
  double get fontSize4 => s * (fontSmallest + fontIncrement * 4);

  @override
  double get fontSize5 => s * (fontSmallest + fontIncrement * 5);

  @override
  double get fontSize6 => s * (fontSmallest + fontIncrement * 6);

  @override
  double get fontSize7 => s * (fontSmallest + fontIncrement * 7);

  @override
  double get fontSize8 => s * (fontSmallest + fontIncrement * 8);

  @override
  double get fontSize9 => s * (fontSmallest + fontIncrement * 9);

  @override
  SizedBox get spacerBoxVerticalSmallest => SizedBox(height: s * 3.0);

  @override
  SizedBox get spacerBoxVerticalSmall => SizedBox(height: s * 10.0);

  @override
  SizedBox get spacerBoxVerticalMedium => SizedBox(height: s * 20);

  @override
  SizedBox get spacerBoxHorizontalSmallest => SizedBox(width: s * 3.0);

  @override
  SizedBox get spacerBoxHorizontalSmall => SizedBox(width: s * 10.0);

  @override
  SizedBox get spacerBoxHorizontalMedium => SizedBox(width: s * 20);
}
