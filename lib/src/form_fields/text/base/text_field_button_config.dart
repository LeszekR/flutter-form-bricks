import 'package:flutter/material.dart';

enum ButtonPosition { left, right }

class TextFieldButtonConfig {
  final IconData iconData;
  final ButtonPosition buttonPosition;
  final String Function(BuildContext)? tooltipMaker;
  final ButtonStyle? style;
  final double? distanceFromTextField;
  final bool syncStyleWithTextField;
  final bool autofocus;

  const TextFieldButtonConfig({
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
      iconData: other?.iconData ?? iconData,
      buttonPosition: other?.buttonPosition ?? buttonPosition,
      tooltipMaker: tooltipMaker,
      style: other?.style ?? style,
      distanceFromTextField: other?.distanceFromTextField ?? distanceFromTextField,
      syncStyleWithTextField: other?.syncStyleWithTextField ?? syncStyleWithTextField,
      autofocus: other?.autofocus ?? autofocus,
    );
  }
}
