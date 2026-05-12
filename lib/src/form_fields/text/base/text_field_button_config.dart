import 'package:flutter/material.dart';

enum ButtonPosition { left, right }

class TextFieldButtonConfig {
  final double? size;
  final IconData iconData;
  final ButtonPosition buttonPosition;
  final String Function(BuildContext)? tooltipMaker;
  final ButtonStyle? style;
  final double? distanceFromTextField;
  final bool syncStyleWithTextField;
  final bool autofocus;

  const TextFieldButtonConfig({
    this.size,
    this.iconData = Icons.arrow_drop_down,
    this.buttonPosition = ButtonPosition.right,
    this.tooltipMaker,
    this.style,
    this.distanceFromTextField,
    this.syncStyleWithTextField = true,
    this.autofocus = false,
  });

  TextFieldButtonConfig fillFrom(TextFieldButtonConfig? other) {
    return TextFieldButtonConfig(
      size: other?.size ?? size,
      iconData: other?.iconData ?? iconData,
      buttonPosition: other?.buttonPosition ?? buttonPosition,
      tooltipMaker: tooltipMaker,
      style: other?.style ?? style,
      distanceFromTextField: other?.distanceFromTextField ?? distanceFromTextField,
      syncStyleWithTextField: other?.syncStyleWithTextField ?? syncStyleWithTextField,
      autofocus: other?.autofocus ?? autofocus,
    );
  }

  TextFieldButtonConfig copyWith({
    double? size,
    IconData? iconData,
    ButtonPosition? buttonPosition,
    String Function(BuildContext)? tooltipMaker,
    ButtonStyle? style,
    double? distanceFromTextField,
    bool? syncStyleWithTextField,
    bool? autofocus,
  }) {
    return TextFieldButtonConfig(
      size: size ?? this.size,
      iconData: iconData ?? this.iconData,
      buttonPosition: buttonPosition ?? this.buttonPosition,
      tooltipMaker: tooltipMaker ?? this.tooltipMaker,
      style: style ?? this.style,
      distanceFromTextField: distanceFromTextField ?? this.distanceFromTextField,
      syncStyleWithTextField: syncStyleWithTextField ?? this.syncStyleWithTextField,
    );
  }
}
