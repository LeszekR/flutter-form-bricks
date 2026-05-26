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
  final double? width;
  final OuterLabelConfig? outerLabelConfig;
  final TextFieldButtonConfig? buttonConfig;
  final FocusNode? targetFocusNode;
  final CompoundWidgetStatesController? compoundWidgetStatesController;
  final VoidCallback? onButtonTap;

  const LabelledBox({
    super.key,
    required this.fieldBody,
    required this.heightProbeConfig,
    required this.borderType,
    this.width,
    this.outerLabelConfig,
    this.buttonConfig,
    this.targetFocusNode,
    this.compoundWidgetStatesController,
    this.onButtonTap,
  })  : assert(buttonConfig == null ? compoundWidgetStatesController == null : true,
            'If buttonConfig is null styleControllerKit must be null'),
        assert(buttonConfig != null ? borderType != null : true,
            'If buttonConfig is declared textFieldBorderType must also be declared'),
        assert(buttonConfig != null ? targetFocusNode != null : true,
            'If buttonConfig is declared then targetFocusNode of the button\'s TextFieldBrick must be provided'),
        assert(buttonConfig != null ? heightProbeConfig != null : true,
            'If buttonConfig is declared then heightProbeConfig must be provided'),
        assert(outerLabelConfig != null ? heightProbeConfig != null : true,
            'If outerLabelConfig is declared then heightProbeConfig must be provided');

  @override
  LabelledBoxState createState() => LabelledBoxState();
}

class LabelledBoxState extends State<LabelledBox> {
  double? _textEditingAreaHeight;

  double _setHeight(double height) => _textEditingAreaHeight = height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textEditingAreaHeight = null;
  }

  @override
  Widget build(BuildContext context) {
    final AppSize appSize = UiParams.of(context).appSize;

    if (_textEditingAreaHeight == null && (widget.buttonConfig != null || widget.outerLabelConfig != null)) {
      _textEditingAreaHeight = appSize.getHeightOfInputDecoratorEditArea(widget.heightProbeConfig);

      // Get height of the editable text area of InputDecorator
      // If ever Flutter exposes API for this - refactor and get rid of the TextFieldHeightProbe use
      if (_textEditingAreaHeight == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
        if (TextFieldHeightCache.isMeasured(widget.heightProbeConfig)) {
          return OffstageDummy();
        } else {
          return TextFieldHeightProbe(
            heightProbeConfig: widget.heightProbeConfig,
            borderType: widget.borderType!,
            onMeasured: _setHeight,
          );
        }
      }
    }

    // Once we have height of the editable text area of InputDecorator build LabelledBox
    final Widget bodyWithButton;

    // no button
    if (widget.buttonConfig == null) {
      bodyWithButton = widget.fieldBody;
    }

    // with button
    else {
      bodyWithButton = _addButton(
        context: context,
        fieldBody: widget.fieldBody,
        height: _textEditingAreaHeight!,
        buttonConfig: widget.buttonConfig!,
        textFieldBorderType: widget.borderType!,
        targetFocusNode: widget.targetFocusNode!,
        compoundWidgetStatesController: widget.compoundWidgetStatesController,
        onButtonTap: widget.onButtonTap!,
      );
    }

    final Widget bodyWithLabel = _wrapWithOuterLabel(
      context: context,
      fieldBody: bodyWithButton,
      height: _textEditingAreaHeight,
      outerLabelConfig: widget.outerLabelConfig,
    );


    double buttonWidth = widget.buttonConfig == null
        ? 0
        : widget.buttonConfig!.width != null
            ? widget.buttonConfig!.width!
            : _textEditingAreaHeight!;

    double sideLabelWidth = widget.width == null
        ? 0
        : widget.outerLabelConfig == null
            ? 0
            : switch (widget.outerLabelConfig!.side) {
                Side.top || Side.bottom => 0,
                Side.left || Side.right => widget.outerLabelConfig!.width!,
              };

    double? totalWidth = widget.width == null
        ? null
        : (widget.width! + buttonWidth + sideLabelWidth) * appSize.zoom;

    return SizedBox(
      width: totalWidth,
      child: bodyWithLabel,
    );
  }

  static _addButton({
    required BuildContext context,
    required Widget fieldBody,
    required double height,
    required TextFieldButtonConfig buttonConfig,
    required TextFieldBorderType textFieldBorderType,
    required VoidCallback onButtonTap,
    required FocusNode targetFocusNode,
    CompoundWidgetStatesController? compoundWidgetStatesController,
  }) {
    AppSize appSize = UiParams.of(context).appSize;

    double width = buttonConfig.width ?? height;
    TextFieldButtonConfig effectiveButtonConfig = buttonConfig.copyWith(width: width);

    TextFieldButton button = TextFieldButton(
      buttonConfig: effectiveButtonConfig,
      textFieldBorderType: textFieldBorderType,
      onTap: onButtonTap,
      targetFocusNode: targetFocusNode,
      compoundWidgetStatesController: compoundWidgetStatesController,
    );

    double padding = (buttonConfig.distanceFromTextField ?? appSize.buttonDistanceFromTextField) * appSize.zoom;

    return switch (buttonConfig.buttonPosition) {
      ButtonPosition.right => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fieldBody),
            SizedBox(width: padding),
            SizedBox(width: width, height: width, child: button),
          ],
        ),
      ButtonPosition.left => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: width, height: width, child: button),
            SizedBox(width: padding),
            Expanded(child: fieldBody),
          ],
        )
    };
  }

  static Widget _wrapWithOuterLabel({
    required BuildContext context,
    required Widget fieldBody,
    required double? height,
    OuterLabelConfig? outerLabelConfig,
  }) {
    if (outerLabelConfig == null) return fieldBody;

    final Widget label = _makeOuterLabel(context, outerLabelConfig, height!);

    final appSize = UiParams.of(context).appSize;

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

  static Widget _makeOuterLabel(BuildContext context, OuterLabelConfig outerLabelConfig, double height) {
    if (outerLabelConfig.labelWidget != null) {
      return outerLabelConfig.labelWidget!;
    }
    AppSize appSize = UiParams.of(context).appSize;

    return SizedBox(
      width: outerLabelConfig.width == null ? null : outerLabelConfig.width! * appSize.zoom,
      height: height,
      // height: outerLabelConfig.height == null ? null : outerLabelConfig.height! * appSize.zoom,
      child: Align(
        alignment: outerLabelConfig.align,
        child: Text(
          outerLabelConfig.labelText!,
          // TODO make this style declarable in params of OuterLabelConfig
          style: TextStyle(fontSize: appSize.fontSize3),
        ),
      ),
    );
  }
}
