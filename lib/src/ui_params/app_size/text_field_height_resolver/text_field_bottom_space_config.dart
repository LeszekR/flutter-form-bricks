import 'dart:math';

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
  final int? maxLines;

  const TextFieldBottomWidgetConfig({
    required this.text,
    required this.widget,
    required this.textStyle,
    this.maxLines,
  });

  static String makeDummyText(String? text, int? maxLines, bool followMaxLines) {
    if (maxLines == null) {
      return 'Ay';  // even if text is null we declare some text to measure the height of the widget with error
    } else {
      if (maxLines < 2) {
        return 'Ay';
      } else {
        return _makeBottomDummyText(text, maxLines, followMaxLines);
      }
    }
  }

  static String _makeBottomDummyText(String? text, int? maxLines, bool followMaxLines) {
    int nTextLines;
    if (text == null) {
      nTextLines = 1;
    } else {
      nTextLines = text.split('\n').length;
    }

    int nBottomLines;
    if (followMaxLines) {
      nBottomLines = max(nTextLines, maxLines ?? 0);
    } else {
      nBottomLines = min(nTextLines, maxLines ?? 0);
    }

    String multilineText = 'Ay';
    for (int i = 0; i < nBottomLines - 1; i++) {
      multilineText += '\nAy';
    }
    return multilineText;
  }

  bool get isEmpty => text == null && widget == null && maxLines == null;

  @override
  List<Object?> get props => [
        text,
        widget,
        textStyle,
        maxLines,
      ];
}

class ErrorWidgetConfig extends TextFieldBottomWidgetConfig {
  const ErrorWidgetConfig({required super.text, required super.widget, required super.textStyle, super.maxLines});
}

class HelperWidgetConfig extends TextFieldBottomWidgetConfig {
  const HelperWidgetConfig({required super.text, required super.widget, required super.textStyle, super.maxLines});
}

class CounterWidgetConfig extends TextFieldBottomWidgetConfig {
  const CounterWidgetConfig({required super.text, required super.widget, required super.textStyle});
}
