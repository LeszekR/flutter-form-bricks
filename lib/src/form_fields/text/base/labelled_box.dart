import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_button.dart';

class LabelledBox extends StatelessWidget {
  final Widget fieldBody;
  final ErrorConfig errorConfig;
  final OuterLabelConfig? outerLabelConfig;
  final InputDecoration? inputDecoration;
  final TextFieldButtonConfig? buttonConfig;
  final VoidCallback? onButtonTap;
  final double? width;
  final double? height;

  const LabelledBox({
    super.key,
    required this.fieldBody,
    this.errorConfig = const ErrorConfig(),
    this.outerLabelConfig,
    this.inputDecoration,
    this.buttonConfig,
    this.onButtonTap,
    this.width,
    this.height,
  })  : assert((buttonConfig == null) || (onButtonTap != null),
            'When buttonConfig != null then onButtonTap must be declared'),
        assert((buttonConfig == null) || (inputDecoration != null),
            'When buttonConfig != null then inputDecoration must be declared');

  @override
  Widget build(BuildContext context) {
    AppSize appSize = UiParams.of(context).appSize;
    double effectiveHeight = height ?? appSize.textFieldHeight;

    final Widget bodyWithButton;
    if (buttonConfig == null) {
      bodyWithButton = fieldBody;
    } else {
      bodyWithButton = _addButton(
        context: context,
        fieldBody: fieldBody,
        height: effectiveHeight,
        inputDecoration: inputDecoration!,
        buttonConfig: buttonConfig!,
        onButtonTap: onButtonTap!,
      );
    }

    final Widget bodyWithLabel = _wrapWithOuterLabel(
      context: context,
      fieldBody: bodyWithButton,
      height: effectiveHeight,
      errorConfig: errorConfig,
      inputDecoration: inputDecoration,
      outerLabelConfig: outerLabelConfig,
    );
    double zoom = appSize.zoom;
    double buttonWidth = buttonConfig == null ? 0 : height!;

    double sideLabelWidth = width == null
        ? 0
        : outerLabelConfig == null
            ? 0
            : switch (outerLabelConfig!.side) {
                Side.top || Side.bottom => 0,
                Side.left || Side.right =>
                  (outerLabelConfig!.width! + UiParams.of(context).appSize.spacerHorizontalSmallest),
              };

    return SizedBox(
      width: width == null ? null : (width! + buttonWidth + sideLabelWidth) * zoom,
      child: bodyWithLabel,
    );
  }

  static _addButton({
    required BuildContext context,
    required Widget fieldBody,
    required double height,
    required InputDecoration inputDecoration,
    required TextFieldButtonConfig buttonConfig,
    required VoidCallback onButtonTap,
  }) {
    AppSize appSize = UiParams.of(context).appSize;
    double size = height * appSize.zoom;

    TextFieldButton button = TextFieldButton(
      buttonConfig: buttonConfig,
      onTap: onButtonTap,
      size: size,
    );

    double padding = (buttonConfig.distanceFromTextField ?? appSize.buttonDistanceFromTextField) * appSize.zoom;

    return switch (buttonConfig.buttonPosition) {
      ButtonPosition.right => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fieldBody),
            SizedBox(width: padding),
            SizedBox(width: size, height: size, child: button),
          ],
        ),
      ButtonPosition.left => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: size, height: size, child: button),
            SizedBox(width: padding),
            Expanded(child: fieldBody),
          ],
        )
    };
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
