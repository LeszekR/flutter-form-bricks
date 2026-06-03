import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/underline_top_rounded_input_border.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/underline_top_rounded_shape.dart';
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
  // TextStyle textStyle() => textTheme.bodySmall!;
  TextStyle textStyle() => textTheme.bodyLarge!;

  // TextStyle textStyle() => textTheme.bodySmall!;

  @override
  get useMaterial3 => sourceTheme?.useMaterial3 ?? true;

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
        headlineLarge: TextStyle(fontSize: appSize.fontSize9),
        headlineMedium: TextStyle(fontSize: appSize.fontSize8),
        headlineSmall: TextStyle(fontSize: appSize.fontSize7),
        titleLarge: TextStyle(fontSize: appSize.fontSize6),
        titleMedium: TextStyle(fontSize: appSize.fontSize5),
        titleSmall: TextStyle(fontSize: appSize.fontSize4),
        bodyLarge: TextStyle(fontSize: appSize.fontSize5),
        bodyMedium: TextStyle(fontSize: appSize.fontSize4),
        bodySmall: TextStyle(fontSize: appSize.fontSize2),
        labelLarge: TextStyle(fontSize: appSize.fontSize5),
        labelMedium: TextStyle(fontSize: appSize.fontSize3),
        labelSmall: TextStyle(fontSize: appSize.fontSize2),
        displayLarge: TextStyle(fontSize: appSize.fontSize4),
        displayMedium: TextStyle(fontSize: appSize.fontSize2),
        displaySmall: TextStyle(fontSize: appSize.fontSize1),
      );

  @override
  get inputDecorationThemeData =>
      sourceTheme?.inputDecorationTheme ??
      InputDecorationTheme(
        isDense: true,
        visualDensity: VisualDensity(
          vertical: -2,
          horizontal: 0,
        ),
        filled: true,
        fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) => appColor.getFillColor(states)),
        border: OutlineInputBorder(),
      ).data;

  @override
  get iconButtonThemeData =>
      sourceTheme?.iconButtonTheme ??
      IconButtonThemeData(
        style: const ButtonStyle().copyWith(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // shape: WidgetStateProperty.resolveWith((Set<WidgetState> states) =>
            //   UnderlineTopRoundedShape(
            //     radiusTopRight: 3,
            //     side: WidgetStateBorderSide.resolveWith(
            //       (Set<WidgetState> states) => BorderSide(
            //         color: appColor.getBorderColor(states, appColor.borderEnabled),
            //         width: appSize.getBorderWidth(states, appSize.borderWidth),
            //       ),
            //     ),
            //   ),
            // ),
            // backgroundColor: WidgetStateColor.resolveWith((Set<WidgetState> states) => appColor.getFillColor(states)),
            iconSize: WidgetStateProperty.all(appSize.iconSize)),
      );

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
