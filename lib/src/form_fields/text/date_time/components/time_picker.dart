import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class TimePicker {
  final TimePickerConfig? timePickerConfig;

  const TimePicker({
    this.timePickerConfig,
  });

  static String timePickerTooltipMaker(BuildContext context) => BricksLocalizations.of(context).openTimePicker;

  Future<TimeOfDay?> open(BuildContext context) async {
    final inheritedTheme = Theme.of(context);
    final uiParams = UiParams.of(context);

    final config = timePickerConfig ?? TimePickerConfig();
    final style = config.style ?? TimePickerStyle.fromAppStyle(uiParams.appColor);

    final initialTime = config.initialTime ?? TimeOfDay(hour: 0, minute: 0);

    return showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: config.helpText ?? BricksLocalizations.of(context).openTimePicker,
      cancelText: config.cancelText,
      confirmText: config.confirmText,
      errorInvalidText: config.errorInvalidText,
      hourLabelText: config.hourLabelText,
      minuteLabelText: config.minuteLabelText,
      orientation: config.orientation,
      initialEntryMode: config.initialEntryMode,
      barrierDismissible: config.barrierDismissible,
      barrierLabel: config.barrierLabel,
      barrierColor: style.barrierColor,
      useRootNavigator: config.useRootNavigator,
      routeSettings: config.routeSettings,
      anchorPoint: config.anchorPoint,
      switchToInputEntryModeIcon: config.switchToInputEntryModeIcon,
      switchToTimerEntryModeIcon: config.switchToTimerEntryModeIcon,
      builder: (context, child) {
        final themedData = inheritedTheme.copyWith(
          colorScheme: style.colorScheme ?? inheritedTheme.colorScheme,
          textButtonTheme: style.textButtonTheme ?? inheritedTheme.textButtonTheme,
          timePickerTheme: style.theme ?? inheritedTheme.timePickerTheme,
        );
        return Theme(
          data: themedData,
          child: child!,
        );
      },
    );
  }
}

class TimePickerStyle {
  final ColorScheme? colorScheme;
  final TextButtonThemeData? textButtonTheme;
  final TimePickerThemeData? theme;

  final Color? barrierColor;

  const TimePickerStyle({
    this.colorScheme,
    this.textButtonTheme,
    this.theme,
    this.barrierColor,
  });

  TimePickerStyle copyWith({
    ColorScheme? colorScheme,
    TextButtonThemeData? textButtonTheme,
    TimePickerThemeData? theme,
    Color? barrierColor,
  }) {
    return TimePickerStyle(
      colorScheme: colorScheme ?? this.colorScheme,
      textButtonTheme: textButtonTheme ?? this.textButtonTheme,
      theme: theme ?? this.theme,
      barrierColor: barrierColor ?? this.barrierColor,
    );
  }

  factory TimePickerStyle.fromAppStyle(AppColor appColor) {
    return TimePickerStyle(
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

class TimePickerConfig {
  final TimeOfDay? initialTime;
  final DateTime? dateTimeNow;
  final TimePickerEntryMode initialEntryMode;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final String? errorInvalidText;
  final String? hourLabelText;
  final String? minuteLabelText;
  final Orientation? orientation;
  final Locale? locale;
  final TextDirection? textDirection;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final Offset? anchorPoint;
  final Icon? switchToInputEntryModeIcon;
  final Icon? switchToTimerEntryModeIcon;
  final TimePickerStyle? style;

  const TimePickerConfig({
    this.initialTime,
    this.dateTimeNow,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.orientation,
    this.locale,
    this.textDirection,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useRootNavigator = true,
    this.routeSettings,
    this.anchorPoint,
    this.switchToInputEntryModeIcon,
    this.switchToTimerEntryModeIcon,
    this.style,
  });

  TimePickerConfig copyWith({
    TimeOfDay? initialTime,
    DateTime? dateTimeNow,
    TimePickerEntryMode? initialEntryMode,
    String? helpText,
    String? cancelText,
    String? confirmText,
    String? errorInvalidText,
    String? hourLabelText,
    String? minuteLabelText,
    Orientation? orientation,
    Locale? locale,
    TextDirection? textDirection,
    bool? barrierDismissible,
    String? barrierLabel,
    bool? useRootNavigator,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    Icon? switchToInputEntryModeIcon,
    Icon? switchToTimerEntryModeIcon,
    TimePickerStyle? style,
  }) {
    return TimePickerConfig(
      initialTime: initialTime ?? this.initialTime,
      dateTimeNow: dateTimeNow ?? this.dateTimeNow,
      initialEntryMode: initialEntryMode ?? this.initialEntryMode,
      helpText: helpText ?? this.helpText,
      cancelText: cancelText ?? this.cancelText,
      confirmText: confirmText ?? this.confirmText,
      errorInvalidText: errorInvalidText ?? this.errorInvalidText,
      hourLabelText: hourLabelText ?? this.hourLabelText,
      minuteLabelText: minuteLabelText ?? this.minuteLabelText,
      orientation: orientation ?? this.orientation,
      locale: locale ?? this.locale,
      textDirection: textDirection ?? this.textDirection,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      barrierLabel: barrierLabel ?? this.barrierLabel,
      useRootNavigator: useRootNavigator ?? this.useRootNavigator,
      routeSettings: routeSettings ?? this.routeSettings,
      anchorPoint: anchorPoint ?? this.anchorPoint,
      switchToInputEntryModeIcon: switchToInputEntryModeIcon ?? this.switchToInputEntryModeIcon,
      switchToTimerEntryModeIcon: switchToTimerEntryModeIcon ?? this.switchToTimerEntryModeIcon,
      style: style ?? this.style,
    );
  }
}
