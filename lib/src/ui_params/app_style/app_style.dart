import 'package:flutter/material.dart';

import '../app_color/app_color.dart';
import '../app_size/app_size.dart';

abstract class AppStyle {
  final AppColor appColor;
  final AppSize appSize;

  AppStyle(
    this.appColor,
    this.appSize,
  );

  BorderSide get borderTabSide;
  BorderSide get borderTabSideDouble;
  BorderSide get borderFormGroupSide;
  Border get borderFieldAll;
  BorderSide get borderFieldSide;
  BorderSide get borderFieldSideError;
  OutlineInputBorder get borderRadio;
  BorderRadius get borderRadius;
  BeveledRectangleBorder get beveledRectangleBorderHardCorners;
  BeveledRectangleBorder get beveledRectangleBorderHardCornersNoBorder;
  TextStyle get labelTextStyle;
  FontStyle get tabFontEnabled;
  FontStyle get tabFontDisabled;
  FontStyle get tabFontError;

  TextStyle inputLabelStyle();

  WidgetStateProperty<OutlinedBorder> makeShapeRectangleProperty(bool hasBorder);
}
