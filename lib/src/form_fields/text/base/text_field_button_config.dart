import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

enum ButtonSide { left, right }

class TextFieldButtonConfig {
  final IconData iconDataMaker;
  final ButtonSide buttonSide;
  final String Function(BuildContext)? tooltipMaker;
  final bool autofocus;

  const TextFieldButtonConfig({
    required this.iconDataMaker,
    this.buttonSide = ButtonSide.right,
    this.tooltipMaker,
    this.autofocus = false,
  });
}
