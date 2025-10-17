import 'package:flutter/material.dart';

import '../../style/app_color.dart';
import '../../style/app_size.dart';
import '../../style/app_style.dart';

class FormUtils {
  FormUtils._();

  static Container horizontalFormGroup(
    final List<Widget> children, {
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
    final row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,);
    return formGroup(
      row,
      label: label,
      alignment: alignment,
      height: height,
      color: color ?? AppColor.formWorkAreaBackground,
      padding: padding,
      borderTop: borderTop,
      borderLeft: borderLeft,
      borderBottom: borderBottom,
      borderRight: borderRight,
    );
  }

  static Container horizontalFormGroupBorderless(
    final List<Widget> children, {
    final String? label,
    final Alignment alignment = Alignment.center,
    final double? height,
    final bool padding = false,
  }) {
    return horizontalFormGroup(children,
        label: label,
        alignment: alignment,
        height: height,
        color: AppColor.formWindowBackground,
        padding: padding,
        borderLeft: false,
        borderBottom: false,
        borderRight: false,
        borderTop: false);
  }

  static Container verticalFormGroup(
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
    final column = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widgets);
    return formGroup(
      column,
      label: label,
      alignment: alignment,
      height: height,
      color: color ?? AppColor.formWorkAreaBackground,
      padding: padding,
      borderTop: borderTop,
      borderLeft: borderLeft,
      borderBottom: borderBottom,
      borderRight: borderRight,
    );
  }

  static Container formGroup(
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
    final childWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) Text(label, style: TextStyle(fontSize: AppSize.fontSize_6, fontWeight: FontWeight.bold)),
        widget,
      ],
    );
    return Container(
      height: height,
      alignment: alignment,
      padding: EdgeInsets.all(padding ? AppSize.paddingForm : 0),
      decoration: BoxDecoration(
        color: color ?? AppColor.formWindowBackground,
        border: Border(
          top: borderTop ? AppStyle.borderFieldSideEnabled : BorderSide.none,
          left: borderLeft ? AppStyle.borderFieldSideEnabled : BorderSide.none,
          bottom: borderBottom ? AppStyle.borderFieldSideEnabled : BorderSide.none,
          right: borderRight ? AppStyle.borderFieldSideEnabled : BorderSide.none,
        ),
      ),
      child: childWidget,
    );
  }

  //todo think about passing ontap function
  static Future<dynamic> searchDialog<E>(final BuildContext context, final Map<String, E> items) {
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

  static Scaffold defaultScaffold({required final String label, required final Widget child}) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(label),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.scaffoldInsetsVertical),
        child: child,
      ),
    );
  }
}
