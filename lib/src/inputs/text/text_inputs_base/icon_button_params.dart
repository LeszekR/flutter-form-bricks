import 'package:flutter/cupertino.dart';

class IconButtonParams {
  final IconData iconData;
  final VoidCallback onPressed;
  final bool autofocus;
  final String? tooltip;

  const IconButtonParams({
    required this.iconData,
    required this.onPressed,
    required this.autofocus,
    this.tooltip,
  });
}
