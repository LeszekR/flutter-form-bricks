import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/height_cache_resolver.dart';

typedef HeightCacheKey = List<Object?>;

class TextFieldBottomSpaceConfig extends HeightCacheResolver {
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

  @override
  bool isCacheable() => true;
}

abstract class TextFieldBottomWidgetConfig extends HeightCacheResolver {
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
      return 'Ay'; // even if text is null we declare some text to measure the height of the widget with error
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

  List<Object?> _makeHeightCacheKey(Widget? widget) {
    if (widget == null) return [];
    if (widget is! Text) return [widget];

    String text = widget.data!.split('\n').map((e) => 'Ay\n').reduce((v, e) => '$v$e');
    text = text.substring(0, text.length - 1);

    return [
      text,
      widget.textSpan,
      widget.style,
      widget.strutStyle,
      widget.textDirection,
      widget.locale,
      widget.softWrap,
      widget.overflow,
      widget.textScaler,
      widget.maxLines,
      widget.textWidthBasis,
      widget.textHeightBehavior,
    ];
  }

  @override
  List<Object?> get props => [
        text,
        textStyle,
        maxLines,
        ..._makeHeightCacheKey(widget),
      ];

  @override
  bool isCacheable() => widget is Text;
}

class ErrorWidgetConfig extends TextFieldBottomWidgetConfig {
  const ErrorWidgetConfig({required super.text, required super.widget, required super.textStyle, super.maxLines});
}

class HelperWidgetConfig extends TextFieldBottomWidgetConfig {
  const HelperWidgetConfig({required super.text, required super.widget, required super.textStyle, super.maxLines});
}

class CounterWidgetConfig extends TextFieldBottomWidgetConfig {
  const CounterWidgetConfig({required super.text, required super.widget, required super.textStyle, super.maxLines});
}
