import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/decoration_config.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/outer_label_config.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params_data.dart';

class TextFieldDecoratedBox extends StatelessWidget {
  final UiParamsData uiParamsData;
  final DecorationConfig decorationBrick;
  final double width;
  final TextField textField;

  const TextFieldDecoratedBox({
    super.key,
    required this.uiParamsData,
    required this.decorationBrick,
    required this.width,
    required this.textField,
  });

  @override
  Widget build(BuildContext context) {
    final Widget bodyWithLabel = _wrapWithOuterLabel(
      decorationBrick: decorationBrick,
      fieldBody: textField,
    );
    return SizedBox(
      width: width,
      child: bodyWithLabel,
    );
  }

  static Widget _wrapWithOuterLabel({
    required DecorationConfig decorationBrick,
    required Widget fieldBody,
  }) {
    final Widget? label = _makeOuterLabel(decorationBrick);
    if (label == null) return fieldBody;

    CrossAxisAlignment crossAxisAlignment = switch (decorationBrick.outerLabelConfig!.outerLabelAlign) {
      OuterLabelAlign.start => CrossAxisAlignment.start,
      OuterLabelAlign.center => CrossAxisAlignment.center,
      OuterLabelAlign.end => CrossAxisAlignment.end,
    };

    switch (decorationBrick.outerLabelConfig!.outerLabelSide) {
      case OuterLabelSide.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            label,
            fieldBody,
          ],
        );

      case OuterLabelSide.left:
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Flexible(flex: 0, child: label),
            Expanded(child: fieldBody),
          ],
        );

      case OuterLabelSide.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            fieldBody,
            label,
          ],
        );

      case OuterLabelSide.right:
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Expanded(child: fieldBody),
            Flexible(flex: 0, child: label),
          ],
        );
    }
  }

  static Widget? _makeOuterLabel(DecorationConfig decorationBrick) {
    if (decorationBrick.outerLabelConfig?.outerLabel != null) {
      return decorationBrick.outerLabelConfig!.outerLabel!;
    }
    if (decorationBrick.outerLabelConfig?.outerLabelText != null) {
      return Text(decorationBrick.outerLabelConfig!.outerLabelText!);
    }
    return null;
  }
}
