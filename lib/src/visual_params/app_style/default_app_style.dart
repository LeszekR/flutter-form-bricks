import 'package:flutter/material.dart';

import '../app_color/app_color.dart';
import '../app_size/app_size.dart';
import 'app_style.dart';

class DefaultAppStyle extends AppStyle {
  final AppColor appColor;
  final AppSize appSize;

  const DefaultAppStyle(this.appColor, this.appSize);

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

  @override
  ThemeData mainTheme() {
    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      colorScheme: appColor.colorSchemeMain,
      scaffoldBackgroundColor: appColor.formWindowBackground,
      menuBarTheme: MenuBarThemeData(
        style: MenuStyle(
          minimumSize: WidgetStateProperty.all(Size.fromHeight(appSize.menuBarHeight)),
          maximumSize: WidgetStateProperty.all(Size.fromHeight(appSize.menuBarHeight)),
          shape: WidgetStateProperty.all(beveledRectangleBorderHardCorners),
          backgroundColor: WidgetStateProperty.all(appColor.colorSchemeMain.secondaryFixedDim),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appColor.colorSchemeMain.secondary,
        foregroundColor: appColor.colorSchemeMain.onSecondary,
        toolbarHeight: appSize.formBarHeight,
        titleTextStyle: TextStyle(fontSize: appSize.fontSize5),
      ),
      tabBarTheme: TabBarThemeData(
        tabAlignment: TabAlignment.start,
        dividerColor: appColor.borderEnabled,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: ShapeDecoration(
          shape: BeveledRectangleBorder(borderRadius: borderRadius, side: borderFieldSide),
        ),
        labelStyle: TextStyle(fontSize: appSize.fontSize5, fontWeight: FontWeight.normal),
        labelColor: appColor.buttonFontEnabled,
        labelPadding: EdgeInsets.zero,
      ),
      scrollbarTheme: ScrollbarThemeData(
        interactive: true,
        thumbVisibility: WidgetStateProperty.all(true),
        thickness: WidgetStateProperty.all(appSize.scrollBarWidth),
        radius: Radius.circular(appSize.cornerRadius),
      ),
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
    );
  }

  @override
  TextStyle inputLabelStyle() {
    return TextStyle(
      fontSize: appSize.fontSize3,
      color: appColor.buttonFontEnabled,
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
}
