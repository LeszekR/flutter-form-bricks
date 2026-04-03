import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/state_colored_icon_button.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params_data.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/input_decoration_brick.dart';

class TextFieldBorderedBox extends StatelessWidget {
  final UiParamsData uiParamsData;
  final InputDecorationBrick decorationBrick;
  final double width;
  final TextField textField;
  final StateColoredIconButton? button;

  const TextFieldBorderedBox({
    super.key,
    required this.uiParamsData,
    required this.decorationBrick,
    required this.width,
    required this.textField,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    final Widget textFieldWithButton = button == null
        ? textField
        : _buildTextFieldWithButton(
      decorationBrick: decorationBrick,
      textField: textField,
      button: button!,
    );

    final Widget body = _wrapWithOuterLabel(
      decorationBrick: decorationBrick,
      fieldBody: textFieldWithButton,
    );

    return SizedBox(
      width: width,
      child: body,
    );
  }

  static Widget _buildTextFieldWithButton({
    required InputDecorationBrick decorationBrick,
    required TextField textField,
    required Widget button,
  }) {
    switch (decorationBrick.buttonPosition) {
      case null:
      case ButtonPosition.rightTop:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: textField),
            button,
          ],
        );

      case ButtonPosition.leftTop:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            button,
            Expanded(child: textField),
          ],
        );

      case ButtonPosition.leftFullHeight:
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              button,
              Expanded(child: textField),
            ],
          ),
        );

      case ButtonPosition.rightFullHeight:
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: textField),
              button,
            ],
          ),
        );
    }
  }

  static Widget _wrapWithOuterLabel({
    required InputDecorationBrick decorationBrick,
    required Widget fieldBody,
  }) {
    final Widget? label = _makeOuterLabel(decorationBrick);
    if (label == null) return fieldBody;

    switch (decorationBrick.outerLabelPosition) {
      case null:
      case OuterLabelPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label,
            fieldBody,
          ],
        );

      case OuterLabelPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fieldBody,
            label,
          ],
        );

      case OuterLabelPosition.left:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 0, child: label),
            Expanded(child: fieldBody),
          ],
        );

      case OuterLabelPosition.right:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fieldBody),
            Flexible(flex: 0, child: label),
          ],
        );
    }
  }

  static Widget? _makeOuterLabel(InputDecorationBrick decorationBrick) {
    if (decorationBrick.outerLabel != null) {
      return decorationBrick.outerLabel!;
    }
    if (decorationBrick.outerLabelText != null) {
      return Text(decorationBrick.outerLabelText!);
    }
    return null;
  }
}