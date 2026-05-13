import 'package:flutter/material.dart';

abstract class AppSize {
  AppSize({required this.zoom});

  /// Base scaling factor (from AppScale, or const 1.0 if no scaling)
  double zoom;

  double getBorderWidth(Set<WidgetState>? states, double defaultWidth) {
    if (states == null) return defaultWidth;

    return switch (states) {
      _ when states.contains(WidgetState.disabled) => borderWidth,
      _ when states.contains(WidgetState.error) => borderErrorWidth,
      _ when states.contains(WidgetState.selected) => borderFocusedWidth,
      _ when states.contains(WidgetState.focused) => borderFocusedWidth,
      _ when states.contains(WidgetState.hovered) => borderWidth,
      _ when states.contains(WidgetState.pressed) => borderFocusedWidth,
      _ => borderWidth,
    };
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
  double get textFieldWidth;
  double get textFieldHeight;
  double get buttonDistanceFromTextField;
  double get cornerRadius;
  double get appBarHeight;
  double get formBarHeight;
  double get menuBarHeight;
  double get menuButtonWidth;
  double get tabHeight;
  double get tabWidth;
  double get borderWidth;
  double get borderFocusedWidth;
  double get borderErrorWidth;
  BorderRadiusGeometry get borderRadius;
  double get tabBorderWidth;
  double get bottomPanelHeight;
  double get labelHeight;
  double get inputLabelHeight;
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
