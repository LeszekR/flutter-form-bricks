import 'package:flutter/material.dart';

import '../../../visual_params/app_color.dart';
import '../../../visual_params/app_size.dart';
import '../../../visual_params/app_style.dart';
import '../../states_controller/update_once_widget_states_controller.dart';

class IconButtonStateAware extends StatefulWidget {
  final IconData _iconData;
  final VoidCallback? _onPressed;
  final String? tooltip;
  final bool autofocus;
  final UpdateOnceWidgetStatesController statesObserver;

  const IconButtonStateAware(
    this._iconData,
    this._onPressed, {
    super.key,
    required this.statesObserver,
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
    return makeMouseRegion(
      child: makeGestureDetector(
        child: makeFocus(
          child: IconButton(
            icon: Icon(widget._iconData),
            iconSize: AppSize.iconSize,
            style: ButtonStyle(shape: AppStyle.makeShapeRectangleProperty(false)),
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            autofocus: widget.autofocus,
            color: AppColor.iconColor,
            focusNode: _focusNode,
            onPressed: widget._onPressed,
          ),
        ),
      ),
    );
  }

  MouseRegion makeMouseRegion({required Widget child}) {
    return MouseRegion(
      onEnter: (event) {
        widget.statesObserver.updateOnce(WidgetState.hovered, true);
      },
      onExit: (event) {
        widget.statesObserver.updateOnce(WidgetState.hovered, false);
      },
      child: child,
    );
  }

  GestureDetector makeGestureDetector({required Widget child}) {
    return GestureDetector(
      onTapDown: (_) {
        // TODO make the field get focus after the button has been clicked
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
      child: child,
    );
  }

  Focus makeFocus({required Widget child}) {
    // TODO finish using this
    return Focus(child: child);
  }
}
