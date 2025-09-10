import 'package:flutter/material.dart';
import 'package:flutter_desktop_bricks/src/ui/inputs/text/text_inputs_base/states_color_maker.dart';

import '../../../visual_params/app_color.dart';
import '../../../visual_params/app_size.dart';
import '../../../visual_params/app_style.dart';
import '../../states_controller/update_once_widget_states_controller.dart';

class StateAwareIconButton extends StatefulWidget {
  final UpdateOnceWidgetStatesController statesObserver;
  final WidgetStatesController statesNotifier;
  final StatesColorMaker colorMaker;
  final IconData iconData;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool autofocus;

  const StateAwareIconButton({
    super.key,
    required this.statesObserver,
    required this.statesNotifier,
    required this.colorMaker,
    required this.iconData,
    required this.onPressed,
    required this.autofocus,
    this.tooltip,
  });

  @override
  State<StateAwareIconButton> createState() => _StateAwareIconButtonState();
}

class _StateAwareIconButtonState extends State<StateAwareIconButton> {
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
            width: AppSize.inputTextHeight,
            height: AppSize.inputTextHeight,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            color: widget.colorMaker.makeColor(_states),
            child: IconButton(
              icon: Icon(widget.iconData),
              iconSize: AppSize.iconSize,
              style: ButtonStyle(shape: AppStyle.makeShapeRectangleProperty(false)),
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              autofocus: widget.autofocus,
              color: AppColor.iconColor,
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
