import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

enum ButtonPosition { leftTop, leftFullHeight, rightTop, rightFullHeight }

class IconButtonConfig {
  final IconData iconData;
  final VoidCallback onPressed;
  final String? tooltip;
  late final double width;
  late final double height;
  final ButtonPosition? buttonPosition;
  final bool autofocus;

  IconButtonConfig({
    required BuildContext context,
    required this.iconData,
    required this.onPressed,
    this.tooltip,
    double? width,
    double? height,
    this.buttonPosition = ButtonPosition.rightTop,
    this.autofocus = false,
  }) {
    this.width = width ?? UiParams.of(context).appSize.inputTextLineHeight;
    this.height = width ?? UiParams.of(context).appSize.inputTextLineHeight;
  }
}
