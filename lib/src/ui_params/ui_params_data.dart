import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/theme_data/bricks_theme_data.dart';
import 'package:flutter_form_bricks/src/ui_params/theme_data/default_theme_data.dart';

import 'app_color/app_color.dart';
import 'app_color/default_app_color.dart';
import 'app_size/app_size.dart';
import 'app_size/default_app_size.dart';
import 'app_style/app_style.dart';
import 'app_style/default_app_style.dart';

class UiParamsData {
  final AppColor color;
  final AppSize size;
  final AppStyle style;
  final BricksThemeData theme;

  UiParamsData({
    AppColor? appColor,
    AppSize? appSize,
    AppStyle? appStyle,
    ThemeData? themeData,
  })  : this.color = appColor ?? DefaultAppColor(const Color.fromARGB(255, 101, 224, 190)),
        this.size = appSize ?? DefaultAppSize(),
        this.style = appStyle ?? DefaultAppStyle(appColor!, appSize!),
        this.theme = themeData != null
            ?  DefaultThemeData.from(appColor!, appSize!, appStyle!, themeData).themeData
            : DefaultThemeData(appColor!, appSize!, appStyle!).themeData;

  UiParamsData copyWith({
    AppColor? appColor,
    AppSize? appSize,
    AppStyle? appStyle,
    ThemeData? theme,
  }) {
    return UiParamsData(
      appColor: appColor ?? this.color,
      appSize: appSize ?? this.size,
      appStyle: appStyle ?? this.style,
      themeData: theme ?? this.theme,
    );
  }
}
