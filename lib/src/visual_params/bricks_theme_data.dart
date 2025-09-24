import 'app_color/app_color.dart';
import 'app_color/default_app_color.dart';
import 'app_size/app_size.dart';
import 'app_size/default_app_size.dart';
import 'app_style/app_style.dart';
import 'app_style/default_app_style.dart';

class BricksThemeData {
  final AppColor colors;
  final AppSize sizes;
  final AppStyle styles;

  BricksThemeData({
    this.colors = const DefaultAppColor(),
    this.sizes = const DefaultAppSize(),
    AppStyle? appStyle,
  }) : styles = appStyle ?? DefaultAppStyle(appColor: colors, appSize: sizes);

  BricksThemeData copyWith({
    AppColor? appColor,
    AppSize? appSize,
    AppStyle? appStyle,
  }) {
    return BricksThemeData(
      colors: appColor ?? this.colors,
      sizes: appSize ?? this.sizes,
      appStyle: appStyle ?? this.styles,
    );
  }
}
