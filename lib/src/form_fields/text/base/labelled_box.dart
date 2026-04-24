import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_button.dart';

class LabelledBox extends StatelessWidget {
  final Widget fieldBody;
  final double? width;
  final InputDecoration? inputDecoration;
  final OuterLabelConfig? outerLabelConfig;
  final TextFieldButtonConfig? buttonConfig;
  final void Function(BuildContext context)? onButtonTap;

  // final TextFieldButton? button;
  final double? height;
  final ErrorConfig errorConfig;

  const LabelledBox({
    super.key,
    required this.fieldBody,
    this.width,
    this.inputDecoration,
    this.errorConfig = const ErrorConfig(),
    this.outerLabelConfig,
    this.buttonConfig,
    this.onButtonTap,
    this.height,
  }) : assert((buttonConfig == null) || (onButtonTap != null),
            'When buttonConfig != null then onButtonTap must be declared');

  @override
  Widget build(BuildContext context) {
    AppSize appSize = UiParams.of(context).appSize;
    double effectiveHeight = height ?? appSize.textFieldHeight;

    final Widget bodyWithButton = _addButton(
      context: context,
      fieldBody: fieldBody,
      height: effectiveHeight,
      buttonConfig: buttonConfig,
      onButtonTap: onButtonTap,
    );

    final Widget bodyWithLabel = _wrapWithOuterLabel(
      context: context,
      fieldBody: bodyWithButton,
      height: effectiveHeight,
      errorConfig: errorConfig,
      inputDecoration: inputDecoration,
      outerLabelConfig: outerLabelConfig,
    );

    double buttonWidth = buttonConfig == null ? 0 : height!;

    double sideLabelWidth = width == null
        ? 0
        : outerLabelConfig == null
            ? 0
            : switch (outerLabelConfig!.side) {
                Side.top || Side.bottom => 0,
                Side.left ||
                Side.right =>
                  outerLabelConfig!.width! * appSize.zoom + UiParams.of(context).appSize.spacerHorizontalSmallest,
              };

    return SizedBox(
      width: width == null ? null : width! * appSize.zoom + buttonWidth + sideLabelWidth,
      child: bodyWithLabel,
    );
  }

  static Widget _wrapWithOuterLabel({
    required BuildContext context,
    required Widget fieldBody,
    required ErrorConfig errorConfig,
    required double? height,
    InputDecoration? inputDecoration,
    OuterLabelConfig? outerLabelConfig,
  }) {
    if (outerLabelConfig == null) return fieldBody;

    final Widget label = _makeOuterLabel(context, outerLabelConfig, height);

    final appSize = UiParams.of(context).appSize;

    switch (outerLabelConfig.side) {
      case Side.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _topOrBottomCrossAxisAlignment(outerLabelConfig),
          children: [
            label,
            // SizedBox(height: appSize.spacerHorizontalSmallest),
            fieldBody,
          ],
        );

      case Side.left:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label,
            // SizedBox(width: appSize.spacerHorizontalSmallest),
            Expanded(child: fieldBody),
          ],
        );

      case Side.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _topOrBottomCrossAxisAlignment(outerLabelConfig),
          children: [
            fieldBody,
            SizedBox(width: appSize.spacerHorizontalSmallest),
            label,
          ],
        );

      case Side.right:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fieldBody),
            SizedBox(width: appSize.spacerHorizontalSmallest),
            label,
          ],
        );
    }
  }

  static _addButton({
    required BuildContext context,
    required Widget fieldBody,
    required double height,
    TextFieldButtonConfig? buttonConfig,
    void Function(BuildContext context)? onButtonTap,
  }) {
    if (buttonConfig == null) {
      return fieldBody;
    }

    final TextFieldButton? button = TextFieldButton(
      textFieldButtonConfig: buttonConfig,
      onTap: onButtonTap!,
      size: height * UiParams.of(context).appSize.zoom,
    );

    ButtonPosition effectiveButtonPosition = buttonConfig.buttonPosition ?? ButtonPosition.right;

    return switch (effectiveButtonPosition) {
      ButtonPosition.right => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fieldBody),
            SizedBox(width: height, height: height, child: button),
          ],
        ),
      ButtonPosition.left => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: height, height: height, child: button),
            Expanded(child: fieldBody),
          ],
        )
    };
  }

  static CrossAxisAlignment _topOrBottomCrossAxisAlignment(OuterLabelConfig outerLabelConfig) {
    return switch (outerLabelConfig.align) {
      Alignment.bottomLeft || Alignment.centerLeft || Alignment.topLeft => CrossAxisAlignment.start,
      Alignment.bottomCenter || Alignment.center || Alignment.topCenter => CrossAxisAlignment.center,
      Alignment.bottomRight || Alignment.centerRight || Alignment.topRight => CrossAxisAlignment.end,
      Alignment() => throw UnimplementedError('Only alignment constant values are supported for outerLabelAlign'),
    };
  }

  static Widget _makeOuterLabel(BuildContext context, OuterLabelConfig outerLabelConfig, double? height) {
    if (outerLabelConfig.labelWidget != null) {
      return outerLabelConfig.labelWidget!;
    }

    AppSize appSize = UiParams.of(context).appSize;

    return SizedBox(
      width: outerLabelConfig.width == null ? null : outerLabelConfig.width! * appSize.zoom,
      height: outerLabelConfig.height == null ? null : outerLabelConfig.height! * appSize.zoom,
      child: Align(
        alignment: outerLabelConfig.align,
        child: Text(
          outerLabelConfig.labelText!,
          // TODO move this font size to appSize
          style: TextStyle(fontSize: appSize.fontSize3),
        ),
      ),
    );
  }
}
