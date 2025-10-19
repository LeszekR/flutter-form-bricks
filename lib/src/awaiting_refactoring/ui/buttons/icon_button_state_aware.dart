import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/inputs/states_controller/update_once_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params_data.dart';

class IconButtonStateAware extends StatefulWidget {
  final IconData _iconData;
  final VoidCallback? _onPressed;
  final String? tooltip;
  final bool autofocus;
  final UpdateOnceWidgetStatesController receiverColorController;

  const IconButtonStateAware(
    this._iconData,
    this._onPressed, {
    super.key,
    required this.receiverColorController,
    required this.autofocus,
    this.tooltip,
  });

  @override
  State<IconButtonStateAware> createState() => _IconButtonStateAwareState();
}

class _IconButtonStateAwareState extends State<IconButtonStateAware> {
  final FocusNode _focusNode = FocusNode();

  // final FocusNode _focusNode = FocusNode(onKeyEvent: _handleKeyPress);

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // TODO #100: handle keyPress Enter, Ecape
  // FocusOnKeyEventCallback? _handleKeyPress() {
  //   if (event is KeyDownEvent) {
  //     if (event == KeyDownEvent.enter) {
  //       widget.action();
  //       return KeyEventResult.handled;
  //     }
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    final appSize = getAppSize(context);
    final appStyle = getAppStyle(context);
    final appColor = getAppColor(context);
    return MouseRegion(
      onEnter: (event) {
        widget.receiverColorController.updateOnce(WidgetState.hovered, true);
      },
      onExit: (event) {
        widget.receiverColorController.updateOnce(WidgetState.hovered, false);
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
          child: IconButton(
            icon: Icon(widget._iconData),
            iconSize: appSize.iconSize,
            style: ButtonStyle(shape: appStyle.makeShapeRectangleProperty(false)),
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            autofocus: widget.autofocus,
            color: appColor.iconColor,
            focusNode: _focusNode,
            onPressed: widget._onPressed,
          ),
        ),
      ),
    );
  }
}
