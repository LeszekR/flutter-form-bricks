import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class DatePicker {
  final CurrentDate? currentDate;

  const DatePicker(this.currentDate);

  static String datePickerTooltip(BuildContext context) => BricksLocalizations.of(context).openDatePicker;

  Future<DateTime?> open(BuildContext context) async {
    final appStyle = UiParams.of(context).appStyle;

    return showDatePicker(
      context: context,
      initialDate: currentDate?.now() ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: BricksLocalizations.of(context).openDatePicker,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              // primary: appStyle.primaryColor,
              // onPrimary: appStyle.onPrimaryColor,
              // surface: appStyle.surfaceColor,
              // onSurface: appStyle.onSurfaceColor,
            ),
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
