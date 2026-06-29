import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/widget_height_cache.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache_key.dart';

abstract class AppSize {
  AppSize({required this.zoom});

  /// Base scaling factor (from AppScale, or const 1.0 if no scaling)
  double zoom;

  double? getHeightOfInputDecoratorEditArea(TextFieldHeightProbeConfig cacheKey){
    return WidgetHeightCache.getHeight(cacheKey);
  }

  double getBorderWidth(Set<WidgetState>? states, double defaultWidth) {
    if (states == null) return defaultWidth;

    return switch (states) {
      _ when states.contains(WidgetState.disabled) => borderWidth,
      _ when states.contains(WidgetState.selected) => borderWidth,
      _ when states.contains(WidgetState.focused) => borderDoubleWidth,
      _ when states.contains(WidgetState.pressed) => borderDoubleWidth,
      _ when states.contains(WidgetState.error) => borderWidth,
      _ when states.contains(WidgetState.hovered) => borderWidth,
      _ => borderWidth,
    };
  }

  // fonts
  final Map<double, Map<double, double>> _fontSizesMap = {};

  double calculateFontSize(double size) {
    if (!_fontSizesMap.containsKey(zoom)) {
      _fontSizesMap[zoom] = {};
    }
    if (_fontSizesMap[zoom]!.containsKey(size)) {
      return _fontSizesMap[zoom]![size]!;
    }
    double fontSize = (fontSmallest + fontIncrement * size) * zoom;
    _fontSizesMap[zoom]![size] = fontSize;
    return fontSize;
  }

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
  double get dateFieldWidth;
  double get timeFieldWidth;
  double get buttonDistanceFromTextField;
  double get inputDecorationPaddingHorizontal;
  double get inputDecorationPaddingVertical;
  double get borderWidth;
  double get borderDoubleWidth;

  // spacers
  double get spacerVerticalSmallest;
  double get spacerVerticalSmall;
  double get spacerVerticalMedium;
  double get spacerHorizontalSmallest;
  double get spacerHorizontalSmall;
  double get spacerHorizontalMedium;

  // USED? REMOVE?
  // =========================================================
  double get cornerRadius;
  double get appBarHeight;
  double get formBarHeight;
  double get menuBarHeight;
  double get menuButtonWidth;
  double get tabHeight;
  double get tabWidth;
  BorderRadiusGeometry get borderRadius;
  double get tabBorderWidth;
  double get bottomPanelHeight;
  double get labelHeight;
  double get inputLabelHeight;
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
}
