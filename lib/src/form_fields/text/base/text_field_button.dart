import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/outline_sides_shape.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/underline_top_rounded_shape.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/compound_widget_states_controller.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig buttonConfig;
  final TextFieldBorderType textFieldBorderType;
  final VoidCallback onTap;
  final CompoundWidgetStatesController? _compoundWidgetStatesController;

  // TODO refactor to StatefulWidget and destroy the FocusNode manually
  final FocusNode _focusNode = FocusNode();

  // final FocusNode _focusNode = FocusNode(onKeyEvent: _handleKeyPress);

  TextFieldButton({
    super.key,
    required this.buttonConfig,
    required this.textFieldBorderType,
    required this.onTap,
    CompoundWidgetStatesController? compoundWidgetStatesController,
  }) : _compoundWidgetStatesController = compoundWidgetStatesController;

  @override
  Widget build(BuildContext context) {
    AppSize appSize = UiParams
        .of(context)
        .appSize;
    double zoomedSize = buttonConfig.size ?? appSize.textFieldHeight * appSize.zoom;

    if (_compoundWidgetStatesController == null) {
      return _makeButton(context, zoomedSize, null);
    } else {
      CompoundWidgetStatesController compoundWidgetStatesController = _compoundWidgetStatesController!;

      return AnimatedBuilder(
          animation: compoundWidgetStatesController,
          builder: (context, _) {
            return CompoundWidgetStatesController.wrapWithStateDetectors(
              compoundWidgetStatesController,
              _focusNode,
              _makeButton(context, zoomedSize, compoundWidgetStatesController.states,),
            );
          });
    }
  }

  SizedBox _makeButton(BuildContext context, double zoomedSize, Set<WidgetState>? states) {
    UiParamsData uiParams = UiParams.of(context);
    ButtonStyle? effectiveStyle = buttonConfig.style ??
        IconButtonTheme
            .of(context)
            .style
            ?.copyWith(
          backgroundColor: WidgetStatePropertyAll(UiParams
              .of(context)
              .appColor
              .getFillColor(states)),
          shape: WidgetStatePropertyAll(_makeShape(uiParams, states)),
        );

    return SizedBox(
      width: zoomedSize,
      height: zoomedSize,
      child: IconButton(
        icon: Icon(buttonConfig.iconData),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        style: effectiveStyle,
      ),
    );
  }

  OutlinedBorder? _makeShape(UiParamsData uiParams, Set<WidgetState>? states) {
    BorderSide borderSide = BorderSide(
      color: uiParams.appColor.getBorderColor(states, uiParams.appColor.borderEnabled),
      width: uiParams.appSize.getBorderWidth(states, uiParams.appSize.borderWidth),
    );

    return switch (textFieldBorderType) {
      TextFieldBorderType.outline =>
      switch (buttonConfig.buttonPosition) {
        ButtonPosition.left => OutlineSidesShape(side: borderSide, sideRight: false),
        ButtonPosition.right => OutlineSidesShape(side: borderSide, sideLeft: false),
      },
      TextFieldBorderType.underline =>
      switch (buttonConfig.buttonPosition) {
        ButtonPosition.left => UnderlineTopRoundedShape(side: borderSide, radiusTopLeft: 0),
        ButtonPosition.right => UnderlineTopRoundedShape(side: borderSide, radiusTopRight: 0),
      },
      TextFieldBorderType.other => null,
    };
  }
}
