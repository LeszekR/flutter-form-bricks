import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/states_controller/update_once_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/states_color_maker.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';


class StateColoredIconButton extends StatefulWidget {
  final UpdateOnceWidgetStatesController statesObserver;
  final WidgetStatesController statesNotifier;
  final StatesColorMaker colorMaker;
  final IconButtonConfig config;

  // TODO complete with all other fields of Flutter IconButton
  const StateColoredIconButton({
    super.key,
    required this.statesObserver,
    required this.statesNotifier,
    required this.colorMaker,
    required this.config,
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
            width: widget.config.width,
            height: widget.config.height,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            color: widget.colorMaker.makeColor(context, _states),
            child: IconButton(
              icon: Icon(widget.config.iconData),
              iconSize: UiParams.of(context).appSize.iconSize,
              style: ButtonStyle(shape: UiParams.of(context).appStyle.makeShapeRectangleProperty(false)),
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              autofocus: widget.config.autofocus,
              color: UiParams.of(context).appColor.iconColor,
              tooltip: widget.config.tooltip,
              focusNode: _focusNode,
              onPressed: widget.config.onPressed,
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

