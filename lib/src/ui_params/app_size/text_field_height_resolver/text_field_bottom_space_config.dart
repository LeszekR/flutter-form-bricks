import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TextFieldBottomSpaceConfig extends Equatable {
  final TextFieldElementConfig? errorConfig;
  final TextFieldElementConfig? helperConfig;
  final TextFieldElementConfig? counterConfig;

  const TextFieldBottomSpaceConfig({
    required this.errorConfig,
    required this.helperConfig,
    required this.counterConfig,
  });

  @override
  List<Object?> get props => [
        errorConfig,
        helperConfig,
        counterConfig,
      ];
}

class TextFieldElementConfig extends Equatable {
  final String? text;
  final Widget? widget;
  final TextStyle? textStyle;

  const TextFieldElementConfig({
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
