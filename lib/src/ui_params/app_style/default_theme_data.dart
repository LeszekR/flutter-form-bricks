import 'package:flutter/material.dart';

import '../app_color/app_color.dart';
import '../app_size/app_size.dart';
import 'app_style.dart';

class DefaultThemeData {
  static DefaultThemeData? _instance;

  DefaultThemeData._();

  static DefaultThemeData instance() {
    if (_instance == null) _instance = DefaultThemeData._();
    return _instance!;
  }

  ThemeData get(
    AppColor appColor,
    AppSize appSize,
    AppStyle appStyle,
  ) {
    return ThemeData(
      //
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      //
      colorScheme: appColor.colorSchemeMain,
      scaffoldBackgroundColor: appColor.formWindowBackground,
      //
      menuBarTheme: MenuBarThemeData(
        style: MenuStyle(
          minimumSize: WidgetStateProperty.all(Size.fromHeight(appSize.menuBarHeight)),
          maximumSize: WidgetStateProperty.all(Size.fromHeight(appSize.menuBarHeight)),
          shape: WidgetStateProperty.all(appStyle.beveledRectangleBorderHardCorners),
          backgroundColor: WidgetStateProperty.all(appColor.colorSchemeMain.secondaryFixedDim),
        ),
      ),
      //
      menuTheme: MenuThemeData(
        style: MenuStyle(
          shape: WidgetStateProperty.all(appStyle.beveledRectangleBorderHardCorners),
        ),
      ),
      //
      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(appStyle.beveledRectangleBorderHardCorners),
          padding: WidgetStateProperty.all(EdgeInsets.all(appSize.paddingButton)),
          minimumSize: WidgetStateProperty.all(Size(appSize.menuButtonWidth, appSize.menuBarHeight)),
        ),
      ),
      //
      appBarTheme: AppBarTheme(
        backgroundColor: appColor.colorSchemeMain.secondary,
        foregroundColor: appColor.colorSchemeMain.onSecondary,
        toolbarHeight: appSize.formBarHeight,
        titleTextStyle: TextStyle(fontSize: appSize.fontSize5),
      ),
      //
      tabBarTheme: TabBarThemeData(
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
      ),
      //
      scrollbarTheme: ScrollbarThemeData(
        interactive: true,
        thumbVisibility: WidgetStateProperty.all(true),
        thickness: WidgetStateProperty.all(appSize.scrollBarWidth),
        radius: Radius.circular(appSize.cornerRadius),
      ),
      //
      dialogTheme: DialogThemeData(
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
      ),
      //
      textTheme: TextTheme(
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
      ),
      //
      inputDecorationTheme: InputDecorationTheme(
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
      ),
      //
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(width: appSize.borderWidth),
        overlayColor: WidgetStateProperty.all(appColor.colorSchemeMain.surfaceContainerHighest),
        visualDensity: const VisualDensity(vertical: -4),
        splashRadius: appSize.inputTextLineHeight * 0.7,
      ),
    );
  }
}
