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
    final appSize = getAppSize(context);
    return SizedBox(
      // width: 1,
      // height: 1,
      width: appSize.textFieldButtonHeight,
      height: appSize.textFieldButtonHeight,
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
