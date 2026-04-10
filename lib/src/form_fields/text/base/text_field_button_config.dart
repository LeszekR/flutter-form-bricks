import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

enum ButtonPosition { left, right }

class TextFieldButtonConfig {
  final IconData iconDataMaker;
  final ButtonPosition buttonPosition;
  final String Function(BuildContext)? tooltipMaker;
  final bool autofocus;

  const TextFieldButtonConfig({
    required this.iconDataMaker,
    this.buttonPosition = ButtonPosition.right,
    this.tooltipMaker,
    this.autofocus = false,
  });
}
