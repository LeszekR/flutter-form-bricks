import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/outer_label_config.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params_data.dart';

class LabelledBox extends StatelessWidget {
  final UiParamsData uiParamsData;
  final OuterLabelConfig? outerLabelConfig;
  final double width;
  final Widget textField;

  const LabelledBox({
    super.key,
    required this.uiParamsData,
    required this.outerLabelConfig,
    required this.width,
    required this.textField,
  });

  @override
  Widget build(BuildContext context) {
    final Widget bodyWithLabel = _wrapWithOuterLabel(
      context: context,
      outerLabelConfig: outerLabelConfig,
      fieldBody: textField,
    );
    return SizedBox(
      width: width,
      child: bodyWithLabel,
    );
  }

  static Widget _wrapWithOuterLabel({
    required BuildContext context,
    required OuterLabelConfig? outerLabelConfig,
    required Widget fieldBody,
  }) {
    if (outerLabelConfig == null) return fieldBody;
    final appSize = UiParams.of(context).appSize;
    final Widget label = _makeOuterLabel(outerLabelConfig);

    CrossAxisAlignment crossAxisAlignment = switch (outerLabelConfig.outerLabelAlign) {
      OuterLabelAlign.start => CrossAxisAlignment.start,
      OuterLabelAlign.center => CrossAxisAlignment.center,
      OuterLabelAlign.end => CrossAxisAlignment.end,
    };

    switch (outerLabelConfig.outerLabelSide) {
      case OuterLabelSide.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            label,
            appSize.horizontalSpacer(appSize.spacerHorizontalSmallest),
            fieldBody,
          ],
        );

      case OuterLabelSide.left:
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Flexible(flex: 0, child: label),
            appSize.verticalSpacer(appSize.spacerHorizontalSmallest),

            Expanded(child: fieldBody),
          ],
        );

      case OuterLabelSide.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            fieldBody,
            appSize.verticalSpacer(appSize.spacerHorizontalSmallest),
            label,
          ],
        );

      case OuterLabelSide.right:
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Expanded(child: fieldBody),
            appSize.horizontalSpacer(appSize.spacerHorizontalSmallest),
            Flexible(flex: 0, child: label),
          ],
        );
    }
  }

  static Widget _makeOuterLabel(OuterLabelConfig outerLabelConfig) {
    if (outerLabelConfig.outerLabel != null) {
      return outerLabelConfig.outerLabel!;
    }
    return Text(outerLabelConfig.outerLabelText!);
  }
}
