import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

enum ButtonSide { left, right }

enum ButtonAlign { top, stretch, bottom }

class IconButtonConfig {
  final IconData iconData;
  final VoidCallback onPressed;
  final String? tooltip;
  late final double width;
  late final double height;
  final ButtonSide buttonSide;
  final ButtonAlign buttonAlign;
  final bool autofocus;

  IconButtonConfig({
    required BuildContext context,
    required this.iconData,
    required this.onPressed,
    this.tooltip,
    double? width,
    double? height,
    this.buttonSide = ButtonSide.right,
    this.buttonAlign = ButtonAlign.top,
    this.autofocus = false,
  }) {
    this.width = width ?? UiParams.of(context).appSize.inputTextLineHeight;
    this.height = width ?? UiParams.of(context).appSize.inputTextLineHeight;
  }
}
