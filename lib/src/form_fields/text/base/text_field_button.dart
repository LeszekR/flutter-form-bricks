import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/style_controller/style_controller_kit.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/style_controller/update_once_widget_states_controller.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig buttonConfig;
  final VoidCallback onTap;
  final StyleControllerKit? styleControllerKit;

  final FocusNode _focusNode = FocusNode();

  // final FocusNode _focusNode = FocusNode(onKeyEvent: _handleKeyPress);

  TextFieldButton({
    super.key,
    required this.buttonConfig,
    required this.onTap,
    this.styleControllerKit,
  });

  @override
  Widget build(BuildContext context) {
    AppSize appSize = UiParams.of(context).appSize;
    double zoomedSize = buttonConfig.size ?? appSize.textFieldHeight  * appSize.zoom;

    if (styleControllerKit == null) {
      return _makeButton(context, zoomedSize, null);
    } else {
      final WidgetStatesController statesNotifier =
          styleControllerKit!.doubleWidgetStatesController as WidgetStatesController;
      final UpdateOnceWidgetStatesController statesReceiver =
          styleControllerKit!.doubleWidgetStatesController.updateOnceStatesObserver;

      return ValueListenableBuilder(
          valueListenable: statesNotifier,
          builder: (context, states, _) {
            return _wrapWithStateDetectors(
              _makeButton(context, zoomedSize, states),
              statesReceiver,
            );
          });
    }
  }

  SizedBox _makeButton(BuildContext context, double zoomedSize, Set<WidgetState>? states) {
    ButtonStyle? effectiveStyle = buttonConfig.style ??
        IconButtonTheme.of(context).style?.copyWith(
            backgroundColor: WidgetStatePropertyAll(styleControllerKit?.statesColorMaker.makeColor(context, states)));

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

  MouseRegion _wrapWithStateDetectors(Widget button, UpdateOnceWidgetStatesController statesReceiver) {
    return MouseRegion(
      onEnter: (event) {
        statesReceiver.updateOnce(WidgetState.hovered, true);
      },
      onExit: (event) {
        statesReceiver.updateOnce(WidgetState.hovered, false);
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
