import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/error_config.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/outer_label_config.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

class LabelledBox extends StatelessWidget {
  final Widget fieldBody;
  final double? width;
  final OuterLabelConfig? outerLabelConfig;
  final ErrorConfig errorConfig;

  const LabelledBox({
    super.key,
    required this.fieldBody,
    this.width,
    this.errorConfig = const ErrorConfig(),
    this.outerLabelConfig,
  });

  @override
  Widget build(BuildContext context) {
    final Widget bodyWithLabel = _wrapWithOuterLabel(
      context: context,
      fieldBody: fieldBody,
      errorConfig: errorConfig,
      outerLabelConfig: outerLabelConfig,
    );
    return SizedBox(
      width: width,
      child: bodyWithLabel,
    );
  }

  static Widget _wrapWithOuterLabel({
    required BuildContext context,
    required Widget fieldBody,
    required ErrorConfig errorConfig,
    OuterLabelConfig? outerLabelConfig,
  }) {
    if (outerLabelConfig == null) return fieldBody;
    final appSize = UiParams.of(context).appSize;
    final Widget label = _makeOuterLabel(context, outerLabelConfig);

    Align alignedLabel = Align(alignment: outerLabelConfig.outerLabelAlign, child: label);
    switch (outerLabelConfig.outerLabelSide) {
      case OuterLabelSide.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _topOrBottomCrossAxisAlignment(outerLabelConfig),
          children: [
            label,
            appSize.verticalSpacer(appSize.spacerHorizontalSmallest),
            fieldBody,
          ],
        );

      case OuterLabelSide.left:
        return Row(
          crossAxisAlignment: _leftOrRightCrossAxisAlignment(outerLabelConfig),
          children: [
            SizedBox(
              height: appSize.textFieldButtonHeight,
              child: alignedLabel,
            ),
            appSize.horizontalSpacer(appSize.spacerHorizontalSmallest),
            Expanded(child: fieldBody),
          ],
        );

      case OuterLabelSide.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _topOrBottomCrossAxisAlignment(outerLabelConfig),
          children: [
            fieldBody,
            appSize.verticalSpacer(appSize.spacerHorizontalSmallest),
            label,
          ],
        );

      case OuterLabelSide.right:
        return Row(
          crossAxisAlignment: _leftOrRightCrossAxisAlignment(outerLabelConfig),
          children: [
            SizedBox(
              height: appSize.textFieldButtonHeight,
              child: alignedLabel,
            ),
            appSize.horizontalSpacer(appSize.spacerHorizontalSmallest),
            Flexible(flex: 0, child: label),
          ],
        );
    }
  }

  static CrossAxisAlignment _topOrBottomCrossAxisAlignment(OuterLabelConfig outerLabelConfig) {
    return switch (outerLabelConfig.outerLabelAlign) {
      Alignment.bottomLeft => CrossAxisAlignment.start,
      Alignment.bottomCenter => CrossAxisAlignment.center,
      Alignment.bottomRight => CrossAxisAlignment.end,
      Alignment.centerLeft => CrossAxisAlignment.start,
      Alignment.center => CrossAxisAlignment.center,
      Alignment.centerRight => CrossAxisAlignment.end,
      Alignment.topLeft => CrossAxisAlignment.start,
      Alignment.topCenter => CrossAxisAlignment.center,
      Alignment.topRight => CrossAxisAlignment.end,
      Alignment() => throw UnimplementedError('Only alignment constant values are supported for outerLabelAlign'),
    };
  }

  static CrossAxisAlignment _leftOrRightCrossAxisAlignment(OuterLabelConfig outerLabelConfig) {
    return switch (outerLabelConfig.outerLabelAlign) {
      Alignment.bottomLeft => CrossAxisAlignment.end,
      Alignment.bottomCenter => CrossAxisAlignment.end,
      Alignment.bottomRight => CrossAxisAlignment.end,
      Alignment.centerLeft => CrossAxisAlignment.center,
      Alignment.center => CrossAxisAlignment.center,
      Alignment.centerRight => CrossAxisAlignment.center,
      Alignment.topLeft => CrossAxisAlignment.start,
      Alignment.topCenter => CrossAxisAlignment.start,
      Alignment.topRight => CrossAxisAlignment.start,
      Alignment() => throw UnimplementedError('Only alignment constant values are supported for outerLabelAlign'),
    };
  }

  static Widget _makeOuterLabel(BuildContext context, OuterLabelConfig outerLabelConfig) {
    if (outerLabelConfig.outerLabel != null) {
      return outerLabelConfig.outerLabel!;
    }
    return Text(
      outerLabelConfig.outerLabelText!,
      style: TextStyle(fontSize: UiParams.of(context).appSize.fontSize3),
    );
  }
}
