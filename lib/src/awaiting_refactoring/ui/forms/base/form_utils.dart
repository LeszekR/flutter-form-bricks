import 'package:flutter/material.dart';

import '../../../../ui_params/ui_params.dart';

class FormUtils {
  FormUtils._();

  static Container horizontalFormGroup({
    required BuildContext context,
    required List<Widget> children,
    String? label,
    Alignment alignment = Alignment.center,
    double? height,
    Color? color,
    bool padding = true,
    borderTop = true,
    borderLeft = true,
    borderBottom = true,
    borderRight = true,
  }) {
    final uiParams = UiParams.of(context);
    final appColor = uiParams.appColor;
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
    return formGroup(
      context,
      row,
      label: label,
      alignment: alignment,
      height: height,
      color: color ?? appColor.formWorkAreaBackground,
      padding: padding,
      borderTop: borderTop,
      borderLeft: borderLeft,
      borderBottom: borderBottom,
      borderRight: borderRight,
    );
  }

  static Container horizontalFormGroupBorderless(
    BuildContext context,
    final List<Widget> children, {
    final String? label,
    final Alignment alignment = Alignment.center,
    final double? height,
    final bool padding = false,
  }) {
    final uiParams = UiParams.of(context);
    final appColor = uiParams.appColor;
    return horizontalFormGroup(
        context: context,
        children: children,
        label: label,
        alignment: alignment,
        height: height,
        color: appColor.formWindowBackground,
        padding: padding,
        borderLeft: false,
        borderBottom: false,
        borderRight: false,
        borderTop: false);
  }

  static Container verticalFormGroup(
    BuildContext context,
    final List<Widget> widgets, {
    final String? label,
    final Alignment alignment = Alignment.center,
    final double? height,
    final Color? color,
    final bool padding = true,
    borderTop = true,
    borderLeft = true,
    borderBottom = true,
    borderRight = true,
  }) {
    final uiParams = UiParams.of(context);
    final appColor = uiParams.appColor;
    final column = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widgets);
    return formGroup(
      context,
      column,
      label: label,
      alignment: alignment,
      height: height,
      color: color ?? appColor.formWorkAreaBackground,
      padding: padding,
      borderTop: borderTop,
      borderLeft: borderLeft,
      borderBottom: borderBottom,
      borderRight: borderRight,
    );
  }

  static Container formGroup(
    BuildContext context,
    final Widget widget, {
    final String? label,
    final Alignment alignment = Alignment.center,
    final double? height,
    final Color? color,
    final bool padding = false,
    final bool borderTop = false,
    final bool borderLeft = false,
    final bool borderBottom = false,
    final bool borderRight = false,
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    final appStyle = uiParams.appStyle;
    final appColor = uiParams.appColor;
    final childWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) Text(label, style: TextStyle(fontSize: appSize.fontSize6, fontWeight: FontWeight.bold)),
        widget,
      ],
    );
    return Container(
      height: height,
      alignment: alignment,
      padding: EdgeInsets.all(padding ? appSize.paddingForm : 0),
      decoration: BoxDecoration(
        color: color ?? appColor.formWindowBackground,
        border: Border(
          top: borderTop ? appStyle.borderFieldSide : BorderSide.none,
          left: borderLeft ? appStyle.borderFieldSide : BorderSide.none,
          bottom: borderBottom ? appStyle.borderFieldSide : BorderSide.none,
          right: borderRight ? appStyle.borderFieldSide : BorderSide.none,
        ),
      ),
      child: childWidget,
    );
  }

  //todo think about passing ontap function
  static Future<dynamic> searchDialog<E>(BuildContext context,Map<String, E> items) {
    final list = ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final String elementKey = items.keys.elementAt(index);
        return ListTile(
          title: Text(elementKey),
          onTap: () {
            Navigator.pop(context, items[elementKey]);
          },
        );
      },
    );

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 400,
          width: 600,
          alignment: Alignment.center,
          child: list,
        ),
      ),
    );
  }

  static Scaffold defaultScaffold({
    required BuildContext context,
    required String label,
    required Widget child,
  }) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(label),
      ),
      body: Padding(
        padding: EdgeInsets.all(appSize.scaffoldInsetsVertical),
        child: child,
      ),
    );
  }
}
