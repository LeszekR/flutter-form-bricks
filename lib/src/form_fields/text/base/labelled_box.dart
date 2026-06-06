import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/compound_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_button.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_cache_key.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/text_field_height_probe.dart';

class LabelledBox extends StatefulWidget {
  final Widget fieldBody;
  final TextFieldHeightProbeConfig heightProbeConfig;
  final TextFieldBorderType borderType;
  final double width;
  final OuterLabelConfig? outerLabelConfig;

  /// In case the `LabelledBox` contains other `LabelledBoxes` that have labels on top or bottom
  /// and this `LabelledBox` label is placed on one side then the `sideLabelTopOffset` should be equal
  /// to height of labels of the contained `LabelledBoxes`.
  ///
  /// If the contained `LabelledBoxes` have labels on top
  /// then use positive value, if on the bottom use negative one - positive value offsets the label from the top,
  /// negative one offsets the same distance from the bottom. This will align the side label widget with
  /// the contained `LabelledBoxes'` `TextFields'` editing areas.
  ///
  /// (You can also control the alignment of the side label with its `outerLabelConfig.align` parameter. It will
  /// align it within `SizedBox` of the same height as the editing areas' height).
  final double sideLabelTopOffset;

  final TextFieldButtonConfig? buttonConfig;
  final int numberOfButtons;
  final FocusNode? targetFocusNode;
  final CompoundWidgetStatesController? compoundWidgetStatesController;
  final VoidCallback? onButtonTap;

  const LabelledBox({
    super.key,
    required this.fieldBody,
    required this.heightProbeConfig,
    required this.borderType,
    required this.width,
    this.outerLabelConfig,
    this.sideLabelTopOffset = 0,
    this.buttonConfig,
    this.numberOfButtons = 0,
    this.targetFocusNode,
    this.compoundWidgetStatesController,
    this.onButtonTap,
  }) : assert(buttonConfig == null ? compoundWidgetStatesController == null : true,
            'If buttonConfig is null styleControllerKit must be null'); /*,
        assert(buttonConfig != null ? targetFocusNode != null : true,
            'If buttonConfig is declared then targetFocusNode of the button\'s TextFieldBrick must be provided');*/

  @override
  LabelledBoxState createState() => LabelledBoxState();
}

class LabelledBoxState extends State<LabelledBox> {
  double? _textEditingAreaHeight;

  void _setHeight(double? height) {
    if (height == null) {
      _textEditingAreaHeight = null;
    } else {
      _textEditingAreaHeight = height / UiParams.of(context).appSize.zoom;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setHeight(null);
  }

  @override
  Widget build(BuildContext context) {
    final AppSize appSize = UiParams.of(context).appSize;

    final bool measureForButton = widget.buttonConfig != null;
    final bool measureForOuterLabel = widget.outerLabelConfig != null &&
        (widget.outerLabelConfig!.side == Side.left ||
            widget.outerLabelConfig!.side == Side.right);

    if (_textEditingAreaHeight == null && (measureForButton || measureForOuterLabel)) {
      _setHeight(appSize.getHeightOfInputDecoratorEditArea(widget.heightProbeConfig));

      // Get height of the editable text area of InputDecorator
      // If ever Flutter exposes API for this - refactor and get rid of the TextFieldHeightProbe use
      if (_textEditingAreaHeight == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
        if (TextFieldHeightCache.isBeingMeasured(widget.heightProbeConfig)) {
          return const OffstageDummy();
        } else {
          return TextFieldHeightProbe(
            heightProbeConfig: widget.heightProbeConfig,
            onMeasured: _setHeight,
          );
        }
      }
    }

    // Once we have height of the editable text area of InputDecorator - we build LabelledBox
    final Widget bodyWithButton;

    // no button
    if (widget.buttonConfig == null || widget.targetFocusNode == null) {
      bodyWithButton = widget.fieldBody;
    }
    // with button
    else {
      bodyWithButton = _addButton(
        context: context,
        fieldBody: widget.fieldBody,
        measuredHeight: _textEditingAreaHeight!,
        buttonConfig: widget.buttonConfig!,
        textFieldBorderType: widget.borderType,
        targetFocusNode: widget.targetFocusNode!,
        compoundWidgetStatesController: widget.compoundWidgetStatesController,
        onButtonTap: widget.onButtonTap!,
      );
    }

    double? configLabelHeight = widget.outerLabelConfig?.height == null
        ? null
        : widget.outerLabelConfig!.height!;

    double? labelHeight = switch (widget.outerLabelConfig?.side) {
      Side.top || Side.bottom => configLabelHeight,
      Side.left || Side.right => configLabelHeight ?? _textEditingAreaHeight!,
      null => null,
    };

    final Widget bodyWithLabel = _wrapWithOuterLabel(
      context: context,
      fieldBody: bodyWithButton,
      labelHeight: labelHeight,
      outerLabelConfig: widget.outerLabelConfig,
      sideLabelTopOffset: widget.sideLabelTopOffset,
    );

    double buttonWidth = widget.buttonConfig?.width ?? _textEditingAreaHeight ?? 0;

    double sideLabelWidth = widget.outerLabelConfig == null
        ? 0
        : switch (widget.outerLabelConfig!.side) {
            Side.top || Side.bottom => 0,
            Side.left || Side.right => widget.outerLabelConfig!.width!,
          };

    double? totalWidth =
        (widget.width + buttonWidth * widget.numberOfButtons + sideLabelWidth);

    return SizedBox(
      width: totalWidth * appSize.zoom,
      child: bodyWithLabel,
    );
  }

  static _addButton({
    required BuildContext context,
    required Widget fieldBody,
    required double measuredHeight,
    required TextFieldButtonConfig buttonConfig,
    required TextFieldBorderType textFieldBorderType,
    required VoidCallback onButtonTap,
    required FocusNode targetFocusNode,
    CompoundWidgetStatesController? compoundWidgetStatesController,
  }) {
    final AppSize appSize = UiParams.of(context).appSize;
    final double zoom = appSize.zoom;

    double width;
    if (buttonConfig.width != null) {
      width = buttonConfig.width!;
    } else {
      width = measuredHeight;
    }

    TextFieldButton button = TextFieldButton(
      buttonConfig: buttonConfig,
      width: width,
      height: measuredHeight,
      textFieldBorderType: textFieldBorderType,
      onTap: onButtonTap,
      targetFocusNode: targetFocusNode,
      compoundWidgetStatesController: compoundWidgetStatesController,
    );

    double padding = (buttonConfig.distanceFromTextField ?? appSize.buttonDistanceFromTextField) * zoom;

    return switch (buttonConfig.buttonPosition) {
      ButtonPosition.right => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fieldBody),
            SizedBox(width: padding),
            SizedBox(
                width: width * zoom,
                height: measuredHeight * zoom,
                child: button),
          ],
        ),
      ButtonPosition.left => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: width * zoom,
                height: measuredHeight * zoom,
                child: button),
            SizedBox(width: padding),
            Expanded(child: fieldBody),
          ],
        )
    };
  }

  static Widget _wrapWithOuterLabel({
    required BuildContext context,
    required Widget fieldBody,
    required double? labelHeight,
    double sideLabelTopOffset = 0,
    OuterLabelConfig? outerLabelConfig,
  }) {
    if (outerLabelConfig == null) return fieldBody;

    final Widget label =
        _makeOuterLabel(context, outerLabelConfig, labelHeight);

    var zoom = UiParams.of(context).appSize.zoom;

    final Widget labelWithOffset = switch (outerLabelConfig.side) {
      Side.top || Side.bottom => label,
      Side.left || Side.right => switch (sideLabelTopOffset > 0) {
          true => Column(
              children: [SizedBox(height: sideLabelTopOffset * zoom), label]),
          false => Column(children: [
              label,
              SizedBox(height: -(sideLabelTopOffset * zoom))
            ]),
        }
    };

    switch (outerLabelConfig.side) {
      case Side.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _topOrBottomCrossAxisAlignment(outerLabelConfig),
          children: [
            label,
            // TODO implement padding around outer label
// SizedBox(height: appSize.spacerHorizontalSmallest),
            fieldBody,
          ],
        );

      case Side.left:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelWithOffset,
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
// SizedBox(width: appSize.spacerHorizontalSmallest),
            label,
          ],
        );

      case Side.right:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fieldBody),
// SizedBox(width: appSize.spacerHorizontalSmallest),
            labelWithOffset,
          ],
        );
    }
  }

  static CrossAxisAlignment _topOrBottomCrossAxisAlignment(
      OuterLabelConfig outerLabelConfig) {
    return switch (outerLabelConfig.align) {
      Alignment.bottomLeft ||
      Alignment.centerLeft ||
      Alignment.topLeft =>
        CrossAxisAlignment.start,
      Alignment.bottomCenter ||
      Alignment.center ||
      Alignment.topCenter =>
        CrossAxisAlignment.center,
      Alignment.bottomRight ||
      Alignment.centerRight ||
      Alignment.topRight =>
        CrossAxisAlignment.end,
      Alignment() => throw UnimplementedError(
          'Only alignment constant values are supported for outerLabelAlign'),
    };
  }

  static Widget _makeOuterLabel(
      BuildContext context, OuterLabelConfig outerLabelConfig, double? height) {
    if (outerLabelConfig.labelWidget != null) {
      return outerLabelConfig.labelWidget!;
    }

    AppSize appSize = UiParams.of(context).appSize;

    return SizedBox(
      width: outerLabelConfig.width == null
          ? null
          : outerLabelConfig.width! * appSize.zoom,
      height: height == null ? null : height * appSize.zoom,
      child: Padding(
        padding: outerLabelConfig.padding,
        child: Align(
          alignment: outerLabelConfig.align,
          child: Text(
            outerLabelConfig.labelText!,
            style: outerLabelConfig.labelTextStyle ?? TextStyle(fontSize: appSize.fontSize3),
          ),
        ),
      ),
    );
  }
}
