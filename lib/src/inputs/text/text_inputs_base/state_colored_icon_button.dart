import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/inputs/text/text_inputs_base/states_color_maker.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

import '../../states_controller/update_once_widget_states_controller.dart';

class StateColoredIconButton extends StatefulWidget {
  final UpdateOnceWidgetStatesController statesObserver;
  final double width;
  final double height;
  final WidgetStatesController statesNotifier;
  final StatesColorMaker colorMaker;
  final IconData iconData;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool autofocus;

  // TODO complete with all other fields of Flutter IconButton
  const StateColoredIconButton({
    super.key,
    required this.width,
    required this.height,
    required this.statesObserver,
    required this.statesNotifier,
    required this.colorMaker,
    required this.iconData,
    required this.onPressed,
    required this.autofocus,
    this.tooltip,
  });

  @override
  State<StateColoredIconButton> createState() => _StateColoredIconButtonState();
}

class _StateColoredIconButtonState extends State<StateColoredIconButton> {
  final FocusNode _focusNode = FocusNode();
  Set<WidgetState>? _states;

  // final FocusNode _focusNode = FocusNode(onKeyEvent: _handleKeyPress);

  @override
  void initState() {
    super.initState();
    _setStates(widget.statesNotifier);
    widget.statesObserver.addListener(_onStatesChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onStatesChanged() {
    setState(() {
      _setStates(widget.statesNotifier);
    });
  }

  void _setStates(WidgetStatesController? statesNotifier) {
    _states = statesNotifier?.value;
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
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            color: widget.colorMaker.makeColor(context, _states),
            child: IconButton(
              icon: Icon(widget.iconData),
              iconSize: UiParams.of(context).appSize.iconSize,
              style: ButtonStyle(shape: UiParams.of(context).appStyle.makeShapeRectangleProperty(false)),
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              autofocus: widget.autofocus,
              color: UiParams.of(context).appColor.iconColor,
              tooltip: widget.tooltip,
              focusNode: _focusNode,
              onPressed: widget.onPressed,
            ),
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

