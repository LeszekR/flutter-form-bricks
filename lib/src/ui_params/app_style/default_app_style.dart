import 'package:flutter/material.dart';

import 'app_style.dart';

class DefaultAppStyle extends AppStyle {
  DefaultAppStyle(
    super.appColor,
    super.appSize,
  );

  @override late final
  BorderSide borderTabSide = BorderSide(width: appSize.tabBorderWidth, color: appColor.borderEnabled);
  @override late final
  BorderSide borderTabSideDouble = BorderSide(width: appSize.tabBorderWidth * 2, color: appColor.borderEnabled);
  @override late final
  BorderSide borderFormGroupSide = BorderSide(width: appSize.borderWidth, color: appColor.borderEnabled);
  @override late final
  BorderSide borderFieldSide = BorderSide(width: appSize.borderWidth, color: appColor.borderEnabled);
  @override late final
  Border borderFieldAll = Border.all(width: appSize.borderWidth, color: appColor.borderEnabled);
  @override late final
  OutlineInputBorder borderRadio = const OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none), gapPadding: 0,);
  @override late final
  BorderSide borderFieldSideError = BorderSide(width: appSize.borderWidth * 2, color: appColor.borderEnabled);
  @override late final
  BorderRadius borderRadius = BorderRadius.circular(appSize.cornerRadius);
  @override late final
  BeveledRectangleBorder beveledRectangleBorderHardCorners = BeveledRectangleBorder(borderRadius: borderRadius);
  @override late final
  BeveledRectangleBorder beveledRectangleBorderHardCornersNoBorder = BeveledRectangleBorder(side: borderFormGroupSide);
  @override late final
  TextStyle labelTextStyle = TextStyle(fontSize: appSize.fontSize3);
  @override late final
  FontStyle tabFontEnabled = FontStyle.normal;
  @override late final
  FontStyle tabFontDisabled = FontStyle.italic;
  @override late final
  FontStyle tabFontError = FontStyle.normal;

  @override
  TextStyle inputLabelStyle() {
    return TextStyle(
      fontSize: appSize.fontSize3,
      color: WidgetStateColor.resolveWith((Set<WidgetState> states) => appColor.textColor(states)),
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
