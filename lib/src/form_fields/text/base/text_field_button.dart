import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/double_widget_states_controller/update_once_widget_states_controller.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig buttonConfig;
  final double size;
  final VoidCallback onTap;
  final UpdateOnceWidgetStatesController? receiverColorController;
  final FocusNode _focusNode = FocusNode();

  // final FocusNode _focusNode = FocusNode(onKeyEvent: _handleKeyPress);

  TextFieldButton({
    super.key,
    required this.buttonConfig,
    required this.size,
    required this.onTap,
    this.receiverColorController,
  }) : assert((buttonConfig.syncStyleWithTextField == true) == (receiverColorController != null),
            'When syncStyleWithTextField is true, receiverColorController must be provided');

  @override
  Widget build(BuildContext context) {
    double zoomedSize = size * UiParams.of(context).appSize.zoom;

    if (receiverColorController == null) {
      return _makeButton(zoomedSize, context);
    } else {
      return _wrapWithStateDetectors(_makeButton(zoomedSize, context));
    }
  }

  SizedBox _makeButton(double zoomedSize, BuildContext context) {
    return SizedBox(
      width: zoomedSize,
      height: zoomedSize,
      child: IconButton(
          icon: Icon(buttonConfig.iconData),
          onPressed: onTap,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          style: buttonConfig.style ?? IconButtonTheme.of(context).style),
    );
  }

  MouseRegion _wrapWithStateDetectors(Widget button) {
    return MouseRegion(
      onEnter: (event) {
        receiverColorController!.updateOnce(WidgetState.hovered, true);
      },
      onExit: (event) {
        receiverColorController!.updateOnce(WidgetState.hovered, false);
      },
      child: GestureDetector(
        onTapDown: (_) {
          // TODO #101 make the field get focus after the button has been clicked
          _focusNode.requestFocus();
          // widget.receiverColorController.updateOnce(WidgetState.focused, true);
        },
        onDoubleTapDown: (_) {
          _focusNode.requestFocus();
          // widget.receiverColorController.updateOnce(WidgetState.focused, true);
        },
        onForcePressStart: (_) {
          _focusNode.requestFocus();
          // widget.receiverColorController.updateOnce(WidgetState.focused, true);
        },
        onLongPress: () {
          _focusNode.requestFocus();
          // widget.receiverColorController.updateOnce(WidgetState.focused, true);
        },
        child: Focus(
          child: button,
        ),
      ),
    );
  }
}
