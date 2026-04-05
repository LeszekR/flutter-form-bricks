import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class TimePicker {
  static String timePickerTooltip(BuildContext context) => BricksLocalizations.of(context).openTimePicker;

  Future<TimeOfDay?> open(BuildContext context) async {
    final appStyle = UiParams.of(context).appStyle;

    final now = TimeOfDay.now();

    return showTimePicker(
      context: context,
      initialTime: now,
      helpText: BricksLocalizations.of(context).openTimePicker,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // colorScheme: ColorScheme.light(
            //   primary: appStyle.primaryColor,
            //   onPrimary: appStyle.onPrimaryColor,
            //   surface: appStyle.surfaceColor,
            //   onSurface: appStyle.onSurfaceColor,
            // ),
            textButtonTheme: TextButtonThemeData(
                // style: TextButton.styleFrom(
                //   foregroundColor: appStyle.primaryColor,
                // ),
                ),
          ),
          child: child!,
        );
      },
    );
  }
}
