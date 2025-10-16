import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_style/default_theme_data.dart';

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
  final ThemeData theme;

  UiParamsData({
    AppColor? colors,
    AppSize? sizes,
    AppStyle? style,
    ThemeData? themeData,
  })  : this.color = colors ?? DefaultAppColor(const Color.fromARGB(255, 101, 224, 190)),
        this.size = sizes ?? DefaultAppSize(),
        this.style = style ?? DefaultAppStyle(appColor: colors!, appSize: sizes!),
        this.theme = themeData ?? DefaultThemeData.instance().get(colors!, sizes!, style!);

  UiParamsData copyWith({
    AppColor? appColor,
    AppSize? appSize,
    AppStyle? appStyle,
    ThemeData? theme,
  }) {
    return UiParamsData(
      colors: appColor ?? this.color,
      sizes: appSize ?? this.size,
      style: appStyle ?? this.style,
      themeData: theme ?? this.theme,
    );
  }
}
