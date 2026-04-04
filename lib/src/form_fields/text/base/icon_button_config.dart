import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

enum ButtonSide { left, right }

class TextFieldButtonConfig {
  final IconData iconData;
  final VoidCallback onTap;
  final String? tooltip;
  final ButtonSide buttonSide;
  final bool autofocus;

  const TextFieldButtonConfig({
    required this.iconData,
    required this.onTap,
    this.tooltip,
    this.buttonSide = ButtonSide.right,
    this.autofocus = false,
  });
}
