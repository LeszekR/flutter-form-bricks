import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TextFieldBottomSpaceConfig extends Equatable {
  final TextFieldBottomWidgetConfig? errorConfig;
  final TextFieldBottomWidgetConfig? helperConfig;
  final TextFieldBottomWidgetConfig? counterConfig;

  const TextFieldBottomSpaceConfig({
    required this.errorConfig,
    required this.helperConfig,
    required this.counterConfig,
  });

  const TextFieldBottomSpaceConfig.empty()
      : errorConfig = null,
        helperConfig = null,
        counterConfig = null;

  bool get isEmpty => errorConfig == null && helperConfig == null && counterConfig == null;

  @override
  List<Object?> get props => [
        errorConfig,
        helperConfig,
        counterConfig,
      ];
}

abstract class TextFieldBottomWidgetConfig extends Equatable {
  final String? text;
  final Widget? widget;
  final TextStyle? textStyle;
  final int? errorMaxLines;

  const TextFieldBottomWidgetConfig({
    required this.text,
    required this.widget,
    required this.textStyle,
    this.errorMaxLines
  });

  bool get isEmpty => text == null && widget == null && errorMaxLines == null;

  @override
  List<Object?> get props => [
        text,
        widget,
        textStyle,
        errorMaxLines,
      ];
}

class ErrorWidgetConfig extends TextFieldBottomWidgetConfig {
  const ErrorWidgetConfig({required super.text, required super.widget, required super.textStyle, super.errorMaxLines});
}

class HelperWidgetConfig extends TextFieldBottomWidgetConfig {
  const HelperWidgetConfig({required super.text, required super.widget, required super.textStyle});
}

class CounterWidgetConfig extends TextFieldBottomWidgetConfig {
  const CounterWidgetConfig({required super.text, required super.widget, required super.textStyle});
}
