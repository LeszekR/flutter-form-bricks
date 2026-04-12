import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_form_bricks/src/ui_params/app_color/app_color.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

class DatePicker {
  static DateTime firstDate = DateTime.now().subtract(const Duration(days: 36500));
  static DateTime lastDate = DateTime.now().add(const Duration(days: 36500));

  final CurrentDate? currentDate;
  final DatePickerConfig? datePickerConfig;

  const DatePicker(
    this.currentDate, {
    this.datePickerConfig,
  });

  static String datePickerTooltip(BuildContext context) => BricksLocalizations.of(context).openDatePicker;

  Future<DateTime?> open(BuildContext context) async {
    final inheritedTheme = Theme.of(context);
    final uiParams = UiParams.of(context);

    final config = datePickerConfig ?? DatePickerConfig();
    final style = config.style ?? DatePickerStyle.fromAppStyle(uiParams.appColor);

    final initialDate =
        config.initialDate ?? config.dateNow ?? currentDate?.now() ?? DateTime.now();

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: config.firstDate ?? firstDate,
      lastDate: config.lastDate ?? lastDate,
      currentDate: config.dateNow ?? currentDate?.now(),
      initialEntryMode: config.initialEntryMode,
      selectableDayPredicate: config.selectableDayPredicate,
      helpText: config.helpText ?? BricksLocalizations.of(context).openDatePicker,
      cancelText: config.cancelText,
      confirmText: config.confirmText,
      errorFormatText: config.errorFormatText,
      errorInvalidText: config.errorInvalidText,
      fieldHintText: config.fieldHintText,
      fieldLabelText: config.fieldLabelText,
      locale: config.locale,
      textDirection: config.textDirection,
      barrierDismissible: config.barrierDismissible,
      barrierLabel: config.barrierLabel,
      barrierColor: style.barrierColor,
      useRootNavigator: config.useRootNavigator,
      routeSettings: config.routeSettings,
      anchorPoint: config.anchorPoint,
      switchToInputEntryModeIcon: config.switchToInputEntryModeIcon,
      switchToCalendarEntryModeIcon: config.switchToCalendarEntryModeIcon,
      initialDatePickerMode: config.initialDatePickerMode,
      calendarDelegate: config.calendarDelegate,
      builder: (context, child) {
        final themedData = inheritedTheme.copyWith(
          colorScheme: style.colorScheme ?? inheritedTheme.colorScheme,
          textButtonTheme: style.textButtonTheme ?? inheritedTheme.textButtonTheme,
          datePickerTheme: style.theme ?? inheritedTheme.datePickerTheme,
        );
        return Theme(
          data: themedData,
          child: child!,
        );
      },
    );
  }
}

class DatePickerStyle {
  final ColorScheme? colorScheme;
  final TextButtonThemeData? textButtonTheme;
  final DatePickerThemeData? theme;

  final Color? barrierColor;

  const DatePickerStyle({
    this.colorScheme,
    this.textButtonTheme,
    this.theme,
    this.barrierColor,
  });

  DatePickerStyle copyWith({
    ColorScheme? colorScheme,
    TextButtonThemeData? textButtonTheme,
    DatePickerThemeData? theme,
    Color? barrierColor,
  }) {
    return DatePickerStyle(
      colorScheme: colorScheme ?? this.colorScheme,
      textButtonTheme: textButtonTheme ?? this.textButtonTheme,
      theme: theme ?? this.theme,
      barrierColor: barrierColor ?? this.barrierColor,
    );
  }

  factory DatePickerStyle.fromAppStyle(AppColor appColor) {
    return DatePickerStyle(
      colorScheme: ColorScheme.light(
        primary: appColor.colorSchemeMain.primary,
        onPrimary: appColor.colorSchemeMain.onPrimary,
        surface: appColor.colorSchemeMain.surface,
        onSurface: appColor.colorSchemeMain.onSurface,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: appColor.colorSchemeMain.primary,
        ),
      ),
      barrierColor: appColor.dialogBarrier,
    );
  }
}

class DatePickerConfig {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? dateNow;
  final DatePickerEntryMode initialEntryMode;
  final SelectableDayPredicate? selectableDayPredicate;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final Locale? locale;
  final TextDirection? textDirection;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final Offset? anchorPoint;
  final Icon? switchToInputEntryModeIcon;
  final Icon? switchToCalendarEntryModeIcon;
  final DatePickerMode initialDatePickerMode;
  final CalendarDelegate<DateTime> calendarDelegate;
  final DatePickerStyle? style;

  DatePickerConfig({
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.dateNow,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.selectableDayPredicate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.locale,
    this.textDirection,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useRootNavigator = true,
    this.routeSettings,
    this.anchorPoint,
    this.switchToInputEntryModeIcon,
    this.switchToCalendarEntryModeIcon,
    this.initialDatePickerMode = DatePickerMode.day,
    this.calendarDelegate = const GregorianCalendarDelegate(),
    this.style,
  })  : assert(
          firstDate == null ||
              lastDate == null ||
              !(lastDate ?? DatePicker.lastDate).isBefore(firstDate ?? DatePicker.firstDate),
          'lastDate must be on or after firstDate',
        ),
        assert(
          initialDate == null ||
              (!initialDate.isBefore(firstDate ?? DatePicker.firstDate) &&
                  !initialDate.isAfter(lastDate ?? DatePicker.lastDate)),
          'initialDate must be within firstDate..lastDate',
        ),
        assert(
          dateNow == null ||
              (!dateNow.isBefore(firstDate ?? DatePicker.firstDate) &&
                  !dateNow.isAfter(lastDate ?? DatePicker.lastDate)),
          'dateNow should be within firstDate..lastDate',
        );

  DatePickerConfig copyWith({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? dateNow,
    DatePickerEntryMode? initialEntryMode,
    SelectableDayPredicate? selectableDayPredicate,
    String? helpText,
    String? cancelText,
    String? confirmText,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    Locale? locale,
    TextDirection? textDirection,
    bool? barrierDismissible,
    String? barrierLabel,
    bool? useRootNavigator,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    Icon? switchToInputEntryModeIcon,
    Icon? switchToCalendarEntryModeIcon,
    DatePickerMode? initialDatePickerMode,
    CalendarDelegate<DateTime>? calendarDelegate,
    DatePickerStyle? style,
  }) {
    return DatePickerConfig(
      initialDate: initialDate ?? this.initialDate,
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      dateNow: dateNow ?? this.dateNow,
      initialEntryMode: initialEntryMode ?? this.initialEntryMode,
      selectableDayPredicate: selectableDayPredicate ?? this.selectableDayPredicate,
      helpText: helpText ?? this.helpText,
      cancelText: cancelText ?? this.cancelText,
      confirmText: confirmText ?? this.confirmText,
      errorFormatText: errorFormatText ?? this.errorFormatText,
      errorInvalidText: errorInvalidText ?? this.errorInvalidText,
      fieldHintText: fieldHintText ?? this.fieldHintText,
      fieldLabelText: fieldLabelText ?? this.fieldLabelText,
      locale: locale ?? this.locale,
      textDirection: textDirection ?? this.textDirection,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      barrierLabel: barrierLabel ?? this.barrierLabel,
      useRootNavigator: useRootNavigator ?? this.useRootNavigator,
      routeSettings: routeSettings ?? this.routeSettings,
      anchorPoint: anchorPoint ?? this.anchorPoint,
      switchToInputEntryModeIcon: switchToInputEntryModeIcon ?? this.switchToInputEntryModeIcon,
      switchToCalendarEntryModeIcon: switchToCalendarEntryModeIcon ?? this.switchToCalendarEntryModeIcon,
      initialDatePickerMode: initialDatePickerMode ?? this.initialDatePickerMode,
      calendarDelegate: calendarDelegate ?? this.calendarDelegate,
      style: style ?? this.style,
    );
  }
}
