import 'package:flutter/material.dart';

import '../app_color/app_color.dart';
import '../app_size/app_size.dart';
import '../app_style/app_style.dart';

/// BricksThemeData
///
/// This abstraction mirrors **Flutter's `ThemeData` property types** on the
/// current SDK channel. Many Material theming APIs have moved from returning
/// `*Theme` (e.g. `AppBarTheme`) to returning `*ThemeData` (e.g.
/// `AppBarThemeData`). To keep wiring explicit and cast-free, this class
/// exposes getters that **exactly match** what `ThemeData` expects.
///
/// # What you get
/// - Getters suffixed with `...ThemeData` return the concrete `*ThemeData`
///   types that `ThemeData.<prop>` requires (e.g. `appBarThemeData`,
///   `dialogThemeData`, `tabBarThemeData`, `inputDecorationThemeData`,
///   `scrollbarThemeData`, etc.).
/// - Plain types (e.g. `TextTheme`, `ColorScheme`, `Color`) are exposed as-is.
///
/// # Why not always `*Theme`?
/// Flutter now returns `*ThemeData` for several properties. Returning the same
/// types prevents implicit up/down casts and avoids analyzer issues
/// (e.g. accidentally widening to `Diagnosticable` in ternaries).
///
/// # Fallback construction
/// When a property is not provided by a source theme, we may construct a
/// `*Theme(...)` and then convert it to `*ThemeData` via `.data` so the final
/// type **matches** `ThemeData.<prop>`:
/// ```dart
/// @override
/// AppBarThemeData get appBarThemeData =>
///   sourceTheme?.appBarTheme ?? AppBarTheme(...).data;
/// ```
///
/// # Upgrading Flutter
/// If a future SDK changes a `ThemeData` property type, update the corresponding
/// getter type and fallback conversion here to continue returning the **exact**
/// type `ThemeData` expects.
///
/// # Sanity-check (debug)
/// In debug builds you can assert that runtime types match the current SDK:
/// ```dart
/// assert(() {
///   final t = themeData;
///   return t.appBarTheme is AppBarThemeData
///       && t.dialogTheme is DialogThemeData
///       && t.tabBarTheme is TabBarThemeData
///       && t.inputDecorationTheme is InputDecorationThemeData;
/// }(), 'BricksThemeData: mismatch with ThemeData types on this SDK');
/// ```
abstract class BricksThemeData {
  bool get useMaterial3;
  VisualDensity get visualDensity;
  ColorScheme get colorScheme;
  Color get scaffoldBackgroundColor;
  MenuBarThemeData get menuBarThemeData;
  MenuThemeData get menuThemeData;
  MenuButtonThemeData get menuButtonThemeData;
  AppBarThemeData get appBarThemeData;
  TabBarThemeData get tabBarThemeData;
  ScrollbarThemeData get scrollbarThemeData;
  DialogThemeData get dialogThemeData;
  TextTheme get textTheme;
  InputDecorationThemeData get inputDecorationThemeData;
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
        appBarTheme: appBarThemeData,
        tabBarTheme: tabBarThemeData,
        scrollbarTheme: scrollbarThemeData,
        dialogTheme: dialogThemeData,
        textTheme: textTheme,
        inputDecorationTheme: inputDecorationThemeData,
        checkboxTheme: checkboxThemeData,
      );

  double? _textLineHeight;
  final Map<TextStyle, double> textLineHeightMap = {};

  double get textLineHeight => _textLineHeight ??= calculateLineHeight(textStyle());

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
