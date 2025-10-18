import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/theme_data/bricks_theme_data.dart';

class DefaultThemeData extends BricksThemeData {
  ThemeData? sourceTheme;

  DefaultThemeData(
    super.appColor,
    super.appSize,
    super.appStyle,
  );

  DefaultThemeData.from(
    super.appColor,
    super.appSize,
    super.appStyle,
    this.sourceTheme,
  );

  @override
  TextStyle textStyle() => textTheme.bodyLarge!;

  @override
  get useMaterial3 => sourceTheme?.useMaterial3 ?? true;

  @override
  get visualDensity => sourceTheme?.visualDensity ?? VisualDensity.compact;

  @override
  get colorScheme => sourceTheme?.colorScheme ?? appColor.colorSchemeMain;

  @override
  get scaffoldBackgroundColor => sourceTheme?.scaffoldBackgroundColor ?? appColor.formWindowBackground;

  @override
  get menuBarThemeData =>
      sourceTheme?.menuBarTheme ??
      MenuBarThemeData(
        style: MenuStyle(
          minimumSize: WidgetStateProperty.all(Size.fromHeight(appSize.menuBarHeight)),
          maximumSize: WidgetStateProperty.all(Size.fromHeight(appSize.menuBarHeight)),
          shape: WidgetStateProperty.all(appStyle.beveledRectangleBorderHardCorners),
          backgroundColor: WidgetStateProperty.all(appColor.colorSchemeMain.secondaryFixedDim),
        ),
      );

  @override
  get menuThemeData =>
      sourceTheme?.menuTheme ??
      MenuThemeData(
        style: MenuStyle(
          shape: WidgetStateProperty.all(appStyle.beveledRectangleBorderHardCorners),
        ),
      );

  @override
  get menuButtonThemeData =>
      sourceTheme?.menuButtonTheme ??
      MenuButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(appStyle.beveledRectangleBorderHardCorners),
          padding: WidgetStateProperty.all(EdgeInsets.all(appSize.paddingButton)),
          minimumSize: WidgetStateProperty.all(Size(appSize.menuButtonWidth, appSize.menuBarHeight)),
        ),
      );

  @override
  get appBarThemeData {
    return sourceTheme?.appBarTheme ??
        AppBarTheme(
          backgroundColor: appColor.colorSchemeMain.secondary,
          foregroundColor: appColor.colorSchemeMain.onSecondary,
          toolbarHeight: appSize.formBarHeight,
          titleTextStyle: TextStyle(fontSize: appSize.fontSize5),
        ).data;
  }

  @override
  get tabBarThemeData =>
      sourceTheme?.tabBarTheme ??
      TabBarThemeData(
        tabAlignment: TabAlignment.start,
        dividerColor: appColor.borderEnabled,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: ShapeDecoration(
          shape: BeveledRectangleBorder(
            borderRadius: appStyle.borderRadius,
            side: appStyle.borderFieldSide,
          ),
        ),
        labelStyle: TextStyle(fontSize: appSize.fontSize5, fontWeight: FontWeight.normal),
        labelColor: appColor.buttonFontEnabled,
        labelPadding: EdgeInsets.zero,
      );

  @override
  get scrollbarThemeData =>
      sourceTheme?.scrollbarTheme ??
      ScrollbarThemeData(
        interactive: true,
        thumbVisibility: WidgetStateProperty.all(true),
        thickness: WidgetStateProperty.all(appSize.scrollBarWidth),
        radius: Radius.circular(appSize.cornerRadius),
      );

  @override
  get dialogThemeData =>
      sourceTheme?.dialogTheme ??
      DialogThemeData(
        backgroundColor: appColor.formWindowBackground,
        contentTextStyle: TextStyle(
          fontSize: appSize.fontSize5,
          color: appColor.buttonFontEnabled,
        ),
        titleTextStyle: TextStyle(
          fontSize: appSize.fontSize7,
          color: appColor.buttonFontEnabled,
          fontWeight: FontWeight.bold,
        ),
      );

  @override
  get textTheme =>
      sourceTheme?.textTheme ??
      TextTheme(
        headlineLarge: TextStyle(fontSize: appSize.fontSize9, height: 1.2),
        headlineMedium: TextStyle(fontSize: appSize.fontSize8, height: 1.2),
        headlineSmall: TextStyle(fontSize: appSize.fontSize7, height: 1.2),
        titleLarge: TextStyle(fontSize: appSize.fontSize6, height: 1.2),
        titleMedium: TextStyle(fontSize: appSize.fontSize5, height: 1.2),
        titleSmall: TextStyle(fontSize: appSize.fontSize4, height: 1.2),
        bodyLarge: TextStyle(fontSize: appSize.fontSize5, height: 1.2),
        bodyMedium: TextStyle(fontSize: appSize.fontSize4, height: 1.2),
        bodySmall: TextStyle(fontSize: appSize.fontSize2, height: 1.2),
        labelLarge: TextStyle(fontSize: appSize.fontSize5, height: 1.2),
        labelMedium: TextStyle(fontSize: appSize.fontSize3, height: 1.2),
        labelSmall: TextStyle(fontSize: appSize.fontSize2, height: 1.2),
        displayLarge: TextStyle(fontSize: appSize.fontSize4, height: 1.2),
        displayMedium: TextStyle(fontSize: appSize.fontSize2, height: 1.2),
        displaySmall: TextStyle(fontSize: appSize.fontSize1, height: 1.2),
      );

  @override
  get inputDecorationThemeData =>
      sourceTheme?.inputDecorationTheme ??
      InputDecorationTheme(
        constraints: BoxConstraints(
          minWidth: appSize.textFieldWidth,
          minHeight: appSize.inputTextLineHeight,
        ),
        filled: true,
        contentPadding: EdgeInsets.all(appSize.paddingInputText),
        isDense: true,
        fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) => appColor.fillColor(states)),
        labelStyle: TextStyle(
          color: WidgetStateColor.resolveWith((Set<WidgetState> states) => appColor.textColor(states)),
          fontSize: appSize.fontSize4,
        ),
        errorStyle: const TextStyle(fontSize: 0),
      ).data;

  @override
  get checkboxThemeData =>
      sourceTheme?.checkboxTheme ??
      CheckboxThemeData(
        side: BorderSide(width: appSize.borderWidth),
        overlayColor: WidgetStateProperty.all(appColor.colorSchemeMain.surfaceContainerHighest),
        visualDensity: const VisualDensity(vertical: -4),
        splashRadius: appSize.inputTextLineHeight * 0.7,
      );
}
