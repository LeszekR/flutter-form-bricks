import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/decoration/bottom_border_top_rounded_shape.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/style_controller/compound_widget_states_controller.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/style_controller/style_controller_kit.dart';

class TextFieldButton extends StatelessWidget {
  final TextFieldButtonConfig buttonConfig;
  final VoidCallback onTap;
  final StyleControllerKit? _styleControllerKit;

  // TODO refactor to StatefulWidget and destroy the FocusNode manually
  final FocusNode _focusNode = FocusNode();

  // final FocusNode _focusNode = FocusNode(onKeyEvent: _handleKeyPress);

  TextFieldButton({
    super.key,
    required this.buttonConfig,
    required this.onTap,
    StyleControllerKit? styleControllerKit,
  }) : _styleControllerKit = styleControllerKit;

  @override
  Widget build(BuildContext context) {
    AppSize appSize = UiParams.of(context).appSize;
    double zoomedSize = buttonConfig.size ?? appSize.textFieldHeight * appSize.zoom;

    if (_styleControllerKit == null) {
      return _makeButton(context, zoomedSize, null);

    } else {
      var compoundWidgetStatesController = _styleControllerKit!.compoundWidgetStatesController;

      return AnimatedBuilder(
          animation: compoundWidgetStatesController,
          builder: (context, _) {
            // print('button: ${_styleControllerKit!.compoundWidgetStatesController.states}');
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
        IconButtonTheme.of(context).style?.copyWith(
              backgroundColor: WidgetStatePropertyAll(_styleControllerKit?.statesColorMaker.makeColor(context, states)),
              shape: WidgetStatePropertyAll(
                BottomBorderTopRoundedShape(
                  borderRadius: 3,
                  side: BorderSide(
                    color: uiParams.appColor.getBorderColor(states, uiParams.appColor.borderEnabled),
                    width: uiParams.appSize.getBorderWidth(states, uiParams.appSize.borderWidth),
                  ),
                ),
              ),
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
}
