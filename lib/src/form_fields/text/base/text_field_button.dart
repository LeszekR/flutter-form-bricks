import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig buttonConfig;
  final InputBorder? border;
  final double size;
  final VoidCallback onTap;

  // final void Function(BuildContext context) onTap;

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
        style: buttonConfig.style ??
            IconButtonTheme.of(context).style ??
            const ButtonStyle().copyWith(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(),
              ),
            ),
      ),
    );
    // return DecoratedBox(
    //   decoration: BoxDecoration(
    //     color: backgroundColor ?? Colors.transparent,
    //     border: _toBoxBorder(border),
    //   ),
    //   child: Material(
    //     color: Colors.yellow,
    //     child: InkWell(
    //       onTap: onTap,
    //       child: Center(
    //         child: Icon(
    //           textFieldButtonConfig.iconData,
    //           size: size,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
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
