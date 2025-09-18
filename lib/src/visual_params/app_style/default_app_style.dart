import 'package:flutter/material.dart';

import '../app_color/app_color.dart';
import '../app_size/app_size.dart';
import 'app_style.dart';

class DefaultAppStyle extends AppStyle {
  const DefaultAppStyle({
    required super.appColor,
    required super.appSize,
  });

  @override
  BorderSide get borderTabSide => BorderSide(width: appSize.tabBorderWidth, color: appColor.borderEnabled);

  @override
  BorderSide get borderTabSideDouble => BorderSide(width: appSize.tabBorderWidth * 2, color: appColor.borderEnabled);

  @override
  BorderSide get borderFormGroupSide => BorderSide(width: appSize.borderWidth, color: appColor.borderEnabled);

  @override
  BorderSide get borderFieldSide => BorderSide(width: appSize.borderWidth, color: appColor.borderEnabled);

  @override
  Border get borderFieldAll => Border.all(width: appSize.borderWidth, color: appColor.borderEnabled);

  @override
  OutlineInputBorder get borderRadio =>
      const OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none), gapPadding: 0);

  @override
  BorderSide get borderFieldSideError => BorderSide(width: appSize.borderWidth * 2, color: appColor.borderEnabled);

  @override
  BorderRadius get borderRadius => BorderRadius.circular(appSize.cornerRadius);

  @override
  BeveledRectangleBorder get beveledRectangleBorderHardCorners => BeveledRectangleBorder(borderRadius: borderRadius);

  @override
  BeveledRectangleBorder get beveledRectangleBorderHardCornersNoBorder =>
      BeveledRectangleBorder(side: borderFormGroupSide);

  @override
  TextStyle get labelTextStyle => TextStyle(fontSize: appSize.fontSize3);

  @override
  FontStyle get tabFontEnabled => FontStyle.normal;

  @override
  FontStyle get tabFontDisabled => FontStyle.italic;

  @override
  FontStyle get tabFontError => FontStyle.normal;


  // ======= Theme + helpers =======
  @override
  ThemeData mainTheme() {
    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      //
      colorScheme: appColor.colorSchemeMain,
      //
      scaffoldBackgroundColor: appColor.formWindowBackground,
      //
      menuBarTheme: MenuBarThemeData(
        style: MenuStyle(
          minimumSize: WidgetStateProperty.all(Size.fromHeight(appSize.menuBarHeight)),
          maximumSize: WidgetStateProperty.all(Size.fromHeight(appSize.menuBarHeight)),
          shape: WidgetStateProperty.all(beveledRectangleBorderHardCorners),
          backgroundColor: WidgetStateProperty.all(appColor.colorSchemeMain.secondaryFixedDim),
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
          padding: WidgetStateProperty.all(EdgeInsets.all(appSize.paddingButton)),
          minimumSize: WidgetStateProperty.all(Size(appSize.menuButtonWidth, appSize.menuBarHeight)),
        ),
      ),

      // Form bar
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
            borderRadius: borderRadius,
            side: borderFieldSide,
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
      ),
      //
      // TODO check which ones are ACTUALLY used - remove redundant
      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints(minWidth: appSize.inputTextWidth, minHeight: appSize.inputTextLineHeight),
        filled: true,
        contentPadding: EdgeInsets.all(appSize.paddingInputText),
        isDense: true,
        fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) => appColor.makeWidgetStateColor(states)),
        labelStyle: TextStyle(
          color: WidgetStateColor.resolveWith((Set<WidgetState> states) => appColor.textColor(states)),
          fontSize: appSize.fontSize4,
        ),
        // TODO is this one used??
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

  @override
  TextStyle textFieldStyle() {
    return TextStyle(
      fontSize: mainTheme().textTheme.titleMedium!.fontSize,
      // TODO this will NOT WORK - the states must be passed in the TextField constructor
      color: WidgetStateColor.resolveWith(((Set<WidgetState> states) => appColor.textColor(states))),
    );
  }

  @override
  TextStyle inputLabelStyle() {
    return TextStyle(
      fontSize: appSize.fontSize3,
      color: WidgetStateColor.resolveWith(((Set<WidgetState> states) => appColor.textColor(states))),
      backgroundColor: appColor.formWorkAreaBackground,
    );
  }

  @override
  WidgetStateProperty<OutlinedBorder> makeShapeRectangleProperty(bool hasBorder) {
    return WidgetStateProperty.all(
      hasBorder
          ? beveledRectangleBorderHardCorners
          : const BeveledRectangleBorder(side: BorderSide(width: 0, style: BorderStyle.none)),
    );
  }

  // final double tp = (TextPainter(
  //   text: const TextSpan(
  //     text: 'A',
  //     style: const TextStyle(fontSize: 14),
  //   ),
  //   textDirection: TextDirection.ltr,
  // )..layout()).height;
}
