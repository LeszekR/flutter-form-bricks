import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/input_decoration_brick.dart';

class IconButtonConfig {
  final IconData iconData;
  final VoidCallback onPressed;
  final String? tooltip;
  final double? width;
  final double? height;
  final bool autofocus;

  const IconButtonConfig({
    required this.iconData,
    required this.onPressed,
    this.tooltip,
    this.width,
    this.height,
    this.autofocus = false,
  });
}
