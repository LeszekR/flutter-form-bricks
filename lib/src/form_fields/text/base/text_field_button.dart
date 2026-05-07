import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig buttonConfig;
  final InputBorder? border;
  final double size;
  final VoidCallback onTap;

  const TextFieldButton({
    super.key,
    required this.buttonConfig,
    required this.size,
    required this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    double zoomedSize = size * UiParams.of(context).appSize.zoom;
    return SizedBox(
      width: zoomedSize,
      height: zoomedSize,
      child: IconButton(
        icon: Icon(buttonConfig.iconData),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        style: buttonConfig.style ?? IconButtonTheme.of(context).style
      ),
    );
  }
}
