import 'package:flutter/material.dart';

import '../app_color/app_color.dart';
import '../app_size/app_size.dart';
import '../app_style/app_style.dart';

abstract class BricksThemeData {
  bool get useMaterial3;
  VisualDensity get visualDensity;
  ColorScheme get colorScheme;
  Color get scaffoldBackgroundColor;
  MenuBarThemeData get menuBarThemeData;
  MenuThemeData get menuThemeData;
  MenuButtonThemeData get menuButtonThemeData;
  AppBarTheme get appBarTheme;
  TabBarThemeData get tabBarThemeData;
  ScrollbarThemeData get scrollbarThemeData;
  DialogThemeData get dialogThemeData;
  TextTheme get textTheme;
  InputDecorationTheme get inputDecorationTheme;
  CheckboxThemeData get checkboxThemeData;

  final AppColor appColor;
  final AppSize appSize;
  final AppStyle appStyle;

  BricksThemeData(
    this.appColor,
    this.appSize,
    this.appStyle,
  );

    TextStyle textStyle();

  /// Final composer: builds ThemeData from abstract parts.
  ThemeData get themeData => ThemeData(
        useMaterial3: useMaterial3,
        visualDensity: visualDensity,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        menuBarTheme: menuBarThemeData,
        menuTheme: menuThemeData,
        menuButtonTheme: menuButtonThemeData,
        appBarTheme: appBarTheme,
        tabBarTheme: tabBarThemeData,
        scrollbarTheme: scrollbarThemeData,
        dialogTheme: dialogThemeData,
        textTheme: textTheme,
        inputDecorationTheme: inputDecorationTheme,
        checkboxTheme: checkboxThemeData,
      );

  double? _textLineHeight;
  double get textLineHeight => _textLineHeight ?? _textLineHeight ?? calculateLineHeight(textStyle());
  final Map<TextStyle, double> textLineHeightMap = {};

  double calculateLineHeight(TextStyle style) {
    if (!textLineHeightMap.containsKey(style)) {
      final textPainter = TextPainter(
        text: TextSpan(text: 'a', style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      textLineHeightMap[style] = textPainter.height;
    }
    return textLineHeightMap[style]!;
  }
}
