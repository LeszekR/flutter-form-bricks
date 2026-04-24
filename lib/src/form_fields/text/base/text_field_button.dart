import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig textFieldButtonConfig;
  final Color? backgroundColor;
  final InputBorder? border;
  final double size;
  final void Function(BuildContext context) onTap;

  const TextFieldButton({
    super.key,
    required this.textFieldButtonConfig,
    required this.size,
    required this.onTap,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        border: _toBoxBorder(border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(context),
          child: Center(
            child: Icon(
              textFieldButtonConfig.iconData,
              size: size,
            ),
          ),
        ),
      ),
    );
  }

  // Convert InputBorder -> BoxBorder (best-effort)
  static BoxBorder? _toBoxBorder(InputBorder? border) {
    if (border == null || border == InputBorder.none) return null;

    if (border is OutlineInputBorder) {
      return Border.fromBorderSide(border.borderSide);
    }
    if (border is UnderlineInputBorder) {
      return Border(
        bottom: border.borderSide,
      );
    }
    return Border.fromBorderSide(border.borderSide);
  }
}
