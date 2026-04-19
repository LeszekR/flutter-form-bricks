import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig textFieldButtonConfig;
  final void Function(BuildContext context) onTap;
  final double size;

  const TextFieldButton({
    super.key,
    required this.textFieldButtonConfig,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 10,
      // width: 15,
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
}
