import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig textFieldButtonConfig;

  const TextFieldButton({
    super.key,
    required this.textFieldButtonConfig,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 5,
      height: 5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: textFieldButtonConfig.onTap,
          child: Center(
            child: Icon(textFieldButtonConfig.iconData),
          ),
        ),
      ),
    );
  }
}
