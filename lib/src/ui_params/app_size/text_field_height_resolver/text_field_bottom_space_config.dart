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

  const TextFieldBottomSpaceConfig.empty() : errorConfig = null, helperConfig = null, counterConfig = null;

  @override
  List<Object?> get props => [
        errorConfig,
        helperConfig,
        counterConfig,
      ];
}

class TextFieldBottomWidgetConfig extends Equatable {
  final String? text;
  final Widget? widget;
  final TextStyle? textStyle;

  const TextFieldBottomWidgetConfig({
    required this.text,
    required this.widget,
    required this.textStyle,
  });

  @override
  List<Object?> get props => [
        text,
        widget,
        textStyle,
      ];
}
