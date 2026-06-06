import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/outline_sides_shape.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/underline_top_rounded_shape.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/compound_widget_states_controller.dart';

class TextFieldButton extends StatefulWidget {
  final TextFieldButtonConfig buttonConfig;
  final double width;
  final double height;
  final TextFieldBorderType textFieldBorderType;
  final VoidCallback onTap;
  final CompoundWidgetStatesController? compoundWidgetStatesController;
  final FocusNode targetFocusNode;

  const TextFieldButton({
    super.key,
    required this.buttonConfig,
    required this.width,
    required this.height,
    required this.textFieldBorderType,
    required this.onTap,
    required this.targetFocusNode,
    this.compoundWidgetStatesController,
  });

  @override
  TextFieldButtonState createState() => TextFieldButtonState();
}

class TextFieldButtonState extends State<TextFieldButton> {
  final FocusNode _focusNode = FocusNode();

  // final FocusNode _focusNode = FocusNode(onKeyEvent: _handleKeyPress);

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CompoundWidgetStatesController? compoundWidgetStatesController = widget.compoundWidgetStatesController;

    if (compoundWidgetStatesController == null) {
      return _makeButton(context, widget.width, widget.height, null);
    } else {
      return CompoundWidgetStatesController.wrapWithStateDetectors(
        compoundWidgetStatesController.buttonStatesSink,
        _focusNode,
        AnimatedBuilder(
            animation: compoundWidgetStatesController,
            builder: (context, _) {
              return _makeButton(context, widget.width, widget.height, compoundWidgetStatesController.states);
            }),
      );
    }
  }

  SizedBox _makeButton(BuildContext context, double width, double height, Set<WidgetState>? states) {
    UiParamsData uiParams = UiParams.of(context);

    WidgetStateProperty<BorderSide?>? side;
    WidgetStateProperty<Color>? backgroundColor, overlayColor, shadowColor, surfaceTintColor;
    WidgetStateProperty<double>? elevation;

    if (widget.buttonConfig.transparentBackground) {
      side = const WidgetStatePropertyAll(BorderSide.none);
      backgroundColor = const WidgetStatePropertyAll(Colors.transparent);
      overlayColor = const WidgetStatePropertyAll(Colors.transparent);
      shadowColor = const WidgetStatePropertyAll(Colors.transparent);
      surfaceTintColor = const WidgetStatePropertyAll(Colors.transparent);
      elevation = const WidgetStatePropertyAll(0);
    } else {
      backgroundColor = WidgetStatePropertyAll(UiParams.of(context).appColor.getFillColor(states));
    }

    ButtonStyle? effectiveStyle = widget.buttonConfig.buttonStyle ??
        IconButtonTheme.of(context).style?.copyWith(
              // animationDuration - an attempt to sync this animation with the field's InputDecoration border animation
              // which we have no control over,
              animationDuration: const Duration(milliseconds: 150),
              shape: WidgetStatePropertyAll(_makeShape(uiParams, states)),
              side: side,
              backgroundColor: backgroundColor,
              overlayColor: overlayColor,
              shadowColor: shadowColor,
              surfaceTintColor: surfaceTintColor,
              elevation: elevation,
            );

    final double zoom = UiParams.of(context).appSize.zoom;

    return SizedBox(
      width: width * zoom,
      height: height * zoom,
      child: IconButton(
        iconSize: min(width, height) * zoom,
        icon: Icon(widget.buttonConfig.iconData),
        onPressed: () {
          widget.onTap();
          widget.targetFocusNode.requestFocus();
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        style: effectiveStyle,
        tooltip: widget.buttonConfig.tooltipMaker == null ? '' : widget.buttonConfig.tooltipMaker!(context),
      ),
    );
  }

  OutlinedBorder? _makeShape(UiParamsData uiParams, Set<WidgetState>? states) {
    BorderSide borderSide = BorderSide(
      color: uiParams.appColor.getBorderColor(states, uiParams.appColor.borderEnabled),
      width: uiParams.appSize.getBorderWidth(states, uiParams.appSize.borderWidth),
    );

    bool noDistance = widget.buttonConfig.distanceFromTextField == null ||
        widget.buttonConfig.distanceFromTextField! <= 0;

    return switch (noDistance) {
      true => switch (widget.textFieldBorderType) {
          TextFieldBorderType.outline => switch (widget.buttonConfig.buttonPosition) {
              ButtonPosition.left => OutlineSidesShape(side: borderSide, sideRight: false),
              ButtonPosition.right => OutlineSidesShape(side: borderSide, sideLeft: false),
            },
          TextFieldBorderType.underline => switch (widget.buttonConfig.buttonPosition) {
              ButtonPosition.left => UnderlineTopRoundedShape(side: borderSide, radiusTopRight: 0),
              ButtonPosition.right => UnderlineTopRoundedShape(side: borderSide, radiusTopLeft: 0),
            },
          TextFieldBorderType.other => null,
        },
      false => switch (widget.textFieldBorderType) {
          TextFieldBorderType.outline => switch (widget.buttonConfig.buttonPosition) {
              ButtonPosition.left => OutlineSidesShape(side: borderSide),
              ButtonPosition.right => OutlineSidesShape(side: borderSide),
            },
          TextFieldBorderType.underline => switch (widget.buttonConfig.buttonPosition) {
              ButtonPosition.left => UnderlineTopRoundedShape(side: borderSide),
              ButtonPosition.right => UnderlineTopRoundedShape(side: borderSide),
            },
          TextFieldBorderType.other => null,
        },
    };
  }
}
