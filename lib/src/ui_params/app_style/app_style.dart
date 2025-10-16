import 'package:flutter/material.dart';

import '../app_color/app_color.dart';
import '../app_size/app_size.dart';

abstract class AppStyle {
  final AppColor appColor;
  final AppSize appSize;

  AppStyle({
    required this.appColor,
    required this.appSize,
  });

   // TODO go through all, remove redundant, correct names
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
