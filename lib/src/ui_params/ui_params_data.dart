import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart' show UiParams;
import 'package:flutter_form_bricks/src/ui_params/theme_data/bricks_theme_data.dart';
import 'package:flutter_form_bricks/src/ui_params/theme_data/default_theme_data.dart';

import 'app_color/app_color.dart';
import 'app_color/default_app_color.dart';
import 'app_size/app_size.dart';
import 'app_size/default_app_size.dart';
import 'app_style/app_style.dart';
import 'app_style/default_app_style.dart';

class UiParamsData {
  final AppColor appColor;
  final AppSize appSize;
  final AppStyle appStyle;
  final BricksThemeData appTheme;

  const UiParamsData._(
    this.appColor,
    this.appSize,
    this.appStyle,
    this.appTheme,
  );

  factory UiParamsData({
    AppColor? appColor,
    AppSize? appSize,
    AppStyle? appStyle,
    ThemeData? appTheme,
  }) {
    final color = appColor ?? DefaultAppColor(const Color.fromARGB(255, 101, 224, 190));
    final size = appSize ?? DefaultAppSize();
    final style = appStyle ?? DefaultAppStyle(color, size);

    // Assert style consistency when caller injects a DefaultAppStyle.
    assert(() {
      if (style is DefaultAppStyle) {
        return identical(style.appColor, color) && identical(style.appSize, size);
      }
      return true;
    }(), 'DefaultAppStyle must be constructed with the same AppColor/AppSize instances.');

    final theme = (appTheme == null)
        ? DefaultThemeData(color, size, style)
        : DefaultThemeData.from(color, size, style, appTheme);

    return UiParamsData._(color, size, style, theme);
  }
}

AppStyle getAppStyle(BuildContext context) => UiParams.of(context).appStyle;

AppSize getAppSize(BuildContext context) => UiParams.of(context).appSize;

AppColor getAppColor(BuildContext context) => UiParams.of(context).appColor;
