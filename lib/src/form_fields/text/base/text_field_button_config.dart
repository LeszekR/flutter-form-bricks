import 'package:flutter/material.dart';

enum ButtonPosition { left, right }

class TextFieldButtonConfig {
  final IconData iconData;
  final ButtonPosition buttonPosition;
  final String Function(BuildContext)? tooltipMaker;
  final bool autofocus;

  const TextFieldButtonConfig({
    this.iconData = Icons.arrow_drop_down,
    this.buttonPosition = ButtonPosition.right,
    this.tooltipMaker,
    this.autofocus = false,
  });

  TextFieldButtonConfig fillFrom(TextFieldButtonConfig? other) {
    return TextFieldButtonConfig(
      iconData: other?.iconData ?? iconData,
      buttonPosition: other?.buttonPosition ?? buttonPosition,
      tooltipMaker: tooltipMaker,
      autofocus: other?.autofocus ?? autofocus,
    );
  }
}
