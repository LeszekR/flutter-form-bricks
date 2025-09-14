import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_size.dart';

class AppStyle {
  AppStyle._();

  static var borderTabSide = BorderSide(width: AppSize.tabBorderWidth, color: AppColor.borderEnabled);
  static var borderTabSideDouble = BorderSide(width: AppSize.tabBorderWidth * 2, color: AppColor.borderEnabled);
  static var borderFormGroupSide = BorderSide(width: AppSize.borderWidth, color: AppColor.borderEnabled);

  static var borderFieldSide = BorderSide(width: AppSize.borderWidth, color: AppColor.borderEnabled);
  static var borderFieldAll = Border.all(width: AppSize.borderWidth, color: AppColor.borderEnabled);
  static var borderRadio = OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none), gapPadding: 0);
  static var borderFieldSideError = BorderSide(width: AppSize.borderWidth * 2, color: AppColor.borderEnabled);
  static var borderRadius = BorderRadius.circular(AppSize.cornerRadius);
  static var beveledRectangleBorderHardCorners = BeveledRectangleBorder(borderRadius: borderRadius);
  static var beveledRectangleBorderHardCornersNoBorder = BeveledRectangleBorder(side: borderFormGroupSide);

  static var labelTextStyle = TextStyle(fontSize: AppSize.fontSize_3);

  static var tabFontEnabled = FontStyle.normal;
  static var tabFontDisabled = FontStyle.italic;
  static var tabFontError = FontStyle.normal;

  static ThemeData mainTheme() {
    return ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.compact,
        //
        colorScheme: AppColor.colorSchemeMain,
        //
        scaffoldBackgroundColor: AppColor.formWindowBackground,
        //
        menuBarTheme: MenuBarThemeData(
          style: MenuStyle(
            minimumSize: WidgetStateProperty.all(Size.fromHeight(AppSize.menuBarHeight)),
            maximumSize: WidgetStateProperty.all(Size.fromHeight(AppSize.menuBarHeight)),
            shape: WidgetStateProperty.all(beveledRectangleBorderHardCorners),
            backgroundColor: WidgetStateProperty.all(AppColor.colorSchemeMain.secondaryFixedDim),
          ),
        ),

        // Shape of menu bar - corners
        menuTheme: MenuThemeData(
          style: MenuStyle(
            shape: WidgetStateProperty.all(beveledRectangleBorderHardCorners),
          ),
        ),

        // Every menu item whether in main or dropdown menu
        menuButtonTheme: MenuButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(beveledRectangleBorderHardCorners),
            padding: WidgetStateProperty.all(EdgeInsets.all(AppSize.paddingButton)),
            minimumSize: WidgetStateProperty.all(Size(AppSize.menuButtonWidth, AppSize.menuBarHeight)),
          ),
        ),

        // Form bar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.colorSchemeMain.secondary,
          foregroundColor: AppColor.colorSchemeMain.onSecondary,
          toolbarHeight: AppSize.formBarHeight,
          titleTextStyle: TextStyle(fontSize: AppSize.fontSize_5),
        ),
        //
        tabBarTheme: TabBarTheme(
            tabAlignment: TabAlignment.start,
            dividerColor: AppColor.borderEnabled,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: ShapeDecoration(
              shape: BeveledRectangleBorder(borderRadius: borderRadius, side: borderFieldSide),
            ),
            labelStyle: TextStyle(fontSize: AppSize.fontSize_5, fontWeight: FontWeight.normal),
            labelColor: AppColor.buttonFontEnabled,
            labelPadding: EdgeInsets.zero),
        //
        scrollbarTheme: ScrollbarThemeData(
          interactive: true,
          thumbVisibility: WidgetStateProperty.all(true),
          thickness: WidgetStateProperty.all(AppSize.scrollBarWidth),
          radius: Radius.circular(AppSize.cornerRadius),
        ),
        //
        dialogTheme: DialogTheme(
          backgroundColor: AppColor.formWindowBackground,
          contentTextStyle: TextStyle(
            fontSize: AppSize.fontSize_5,
            color: AppColor.buttonFontEnabled,
          ),
          titleTextStyle:
              TextStyle(fontSize: AppSize.fontSize_7, color: AppColor.buttonFontEnabled, fontWeight: FontWeight.bold),
        ),
        //
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: AppSize.fontSize_9),
          headlineMedium: TextStyle(fontSize: AppSize.fontSize_8),
          headlineSmall: TextStyle(fontSize: AppSize.fontSize_7),
          titleLarge: TextStyle(fontSize: AppSize.fontSize_6),
          titleMedium: TextStyle(fontSize: AppSize.fontSize_5),
          titleSmall: TextStyle(fontSize: AppSize.fontSize_4),
          bodyLarge: TextStyle(fontSize: AppSize.fontSize_5),
          bodyMedium: TextStyle(fontSize: AppSize.fontSize_4),
          bodySmall: TextStyle(fontSize: AppSize.fontSize_2),
          labelLarge: TextStyle(fontSize: AppSize.fontSize_5),
          labelMedium: TextStyle(fontSize: AppSize.fontSize_3),
          labelSmall: TextStyle(fontSize: AppSize.fontSize_2),
          displayLarge: TextStyle(fontSize: AppSize.fontSize_4),
          displayMedium: TextStyle(fontSize: AppSize.fontSize_2),
          displaySmall: TextStyle(fontSize: AppSize.fontSize_1),
        ),
        inputDecorationTheme: InputDecorationTheme(
          constraints: BoxConstraints(minWidth: AppSize.inputTextWidth, minHeight: AppSize.inputTextLineHeight),
          filled: true,
          contentPadding: EdgeInsets.all(AppSize.paddingInputText),
          isDense: true,
          fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) => AppColor.makeWidgetStateColor(states)),
          labelStyle: TextStyle(
            color: WidgetStateColor.resolveWith((Set<WidgetState> states) => AppColor.textColor(states)),
            fontSize: AppSize.fontSize_4,
          ),
          errorStyle: const TextStyle(fontSize: 0),
        ),
        //
        checkboxTheme: CheckboxThemeData(
          side: BorderSide(width: AppSize.borderWidth),
          overlayColor: WidgetStateProperty.all(AppColor.colorSchemeMain.surfaceContainerHighest),
          visualDensity: const VisualDensity(vertical: -4),
          splashRadius: AppSize.inputTextLineHeight * 0.7,
        ));
  }

  static TextStyle inputLabelStyle() {
    return TextStyle(
      fontSize: AppSize.fontSize_3,
      color: WidgetStateColor.resolveWith(((Set<WidgetState> states) => AppColor.textColor(states))),
      backgroundColor: AppColor.formWorkAreaBackground,
    );
  }

  static WidgetStateProperty<OutlinedBorder> makeShapeRectangleProperty(bool hasBorder) {
    return WidgetStateProperty.all(hasBorder
        ? AppStyle.beveledRectangleBorderHardCorners
        : const BeveledRectangleBorder(side: BorderSide(width: 0, style: BorderStyle.none)));
  }
}
