import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/error_config.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/outer_label_config.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/app_size.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

class LabelledBox extends StatelessWidget {
  final Widget fieldBody;
  final double? width;
  final InputDecoration? inputDecoration;
  final OuterLabelConfig? outerLabelConfig;
  final ErrorConfig errorConfig;

  const LabelledBox({
    super.key,
    required this.fieldBody,
    this.width,
    this.inputDecoration,
    this.errorConfig = const ErrorConfig(),
    this.outerLabelConfig,
  });

  @override
  Widget build(BuildContext context) {
    final Widget bodyWithLabel = _wrapWithOuterLabel(
      context: context,
      fieldBody: fieldBody,
      errorConfig: errorConfig,
      inputDecoration: inputDecoration,
      outerLabelConfig: outerLabelConfig,
    );

    double sideLabelWidth = width == null
        ? 0
        : outerLabelConfig == null
            ? 0
            : switch (outerLabelConfig!.side) {
                Side.top || Side.bottom => 0,
                Side.left || Side.right => outerLabelConfig!.width!
              };

    return SizedBox(
      width: width == null ? null : width! + sideLabelWidth,
      child: bodyWithLabel,
    );
  }

  static Widget _wrapWithOuterLabel({
    required BuildContext context,
    required Widget fieldBody,
    required ErrorConfig errorConfig,
    InputDecoration? inputDecoration,
    OuterLabelConfig? outerLabelConfig,
  }) {
    if (outerLabelConfig == null) return fieldBody;

    final Widget label = _makeOuterLabel(context, outerLabelConfig);

    final appSize = UiParams.of(context).appSize;

    Align alignedLabel = Align(alignment: outerLabelConfig.align, child: label);

    switch (outerLabelConfig.side) {
      case Side.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _topOrBottomCrossAxisAlignment(outerLabelConfig),
          children: [
            label,
            SizedBox(height: appSize.spacerHorizontalSmallest),
            Expanded(child: fieldBody),
          ],
        );

      case Side.left:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppSize.textFieldButtonHeight(context: context, inputDecoration: inputDecoration),
              child: alignedLabel,
            ),
            SizedBox(width: appSize.spacerHorizontalSmallest),
            Expanded(child: fieldBody),
          ],
        );

      case Side.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _topOrBottomCrossAxisAlignment(outerLabelConfig),
          children: [
            Expanded(child: fieldBody),
            SizedBox(width: appSize.spacerHorizontalSmallest),
            label,
          ],
        );

      case Side.right:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fieldBody,
            SizedBox(width: appSize.spacerHorizontalSmallest),
            Expanded(
              child: SizedBox(
                height: AppSize.textFieldButtonHeight(context: context, inputDecoration: inputDecoration),
                child: alignedLabel,
              ),
            ),
          ],
        );
    }
  }

  static CrossAxisAlignment _topOrBottomCrossAxisAlignment(OuterLabelConfig outerLabelConfig) {
    return switch (outerLabelConfig.align) {
      Alignment.bottomLeft || Alignment.centerLeft || Alignment.topLeft => CrossAxisAlignment.start,
      Alignment.bottomCenter || Alignment.center || Alignment.topCenter => CrossAxisAlignment.center,
      Alignment.bottomRight || Alignment.centerRight || Alignment.topRight => CrossAxisAlignment.end,
      Alignment() => throw UnimplementedError('Only alignment constant values are supported for outerLabelAlign'),
    };
  }

  static Widget _makeOuterLabel(BuildContext context, OuterLabelConfig outerLabelConfig) {
    if (outerLabelConfig.labelWidget != null) {
      return outerLabelConfig.labelWidget!;
    }
    return Text(
      outerLabelConfig.labelText!,
      style: TextStyle(fontSize: UiParams.of(context).appSize.fontSize3),
    );
  }
}
