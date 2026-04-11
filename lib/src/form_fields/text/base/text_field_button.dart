import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig textFieldButtonConfig;
  final void Function(BuildContext context) onTap;

  const TextFieldButton({
    super.key,
    required this.textFieldButtonConfig,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(context),
          child: Center(
            child: Icon(textFieldButtonConfig.iconDataMaker),
          ),
        ),
      ),
    );
  }
}
