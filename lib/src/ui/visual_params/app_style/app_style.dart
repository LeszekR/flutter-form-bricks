import 'package:flutter/material.dart';

import '../app_color/app_color.dart';
import '../app_size/app_size.dart';

abstract class AppStyle {
  const AppStyle();

  BorderSide get borderTabSide;
  BorderSide get borderTabSideDouble;
  BorderSide get borderFormGroupSide;

  BorderSide get borderFieldSide;
  Border get borderFieldAll;
  OutlineInputBorder get borderRadio;
  BorderSide get borderFieldSideError;
  BorderRadius get borderRadius;
  BeveledRectangleBorder get beveledRectangleBorderHardCorners;
  BeveledRectangleBorder get beveledRectangleBorderHardCornersNoBorder;

  TextStyle get labelTextStyle;

  FontStyle get tabFontEnabled;
  FontStyle get tabFontDisabled;
  FontStyle get tabFontError;

  ThemeData mainTheme();

  TextStyle inputLabelStyle();

  WidgetStateProperty<OutlinedBorder> makeShapeRectangleProperty(bool hasBorder);
}
