import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/double_widget_states_controller/double_widget_states_controller.dart';

enum ButtonPosition { left, right }

class TextFieldButtonConfig {
  final IconData iconData;
  final ButtonPosition buttonPosition;
  final String Function(BuildContext)? tooltipMaker;
  final ButtonStyle? style;
  final double? distanceFromTextField;
  final bool syncStyleWithTextField;
  // final DoubleWidgetStatesController? doubleWidgetStatesController;
  // final StatesColorMaker? statesColorMaker;
  final bool autofocus;

  const TextFieldButtonConfig({
    this.iconData = Icons.arrow_drop_down,
    this.buttonPosition = ButtonPosition.right,
    this.tooltipMaker,
    this.style,
    this.distanceFromTextField,
    this.syncStyleWithTextField = true,
    // this.doubleWidgetStatesController,
    // this.statesColorMaker,
    this.autofocus = false,
  }); /*: assert((syncStyleWithTextField == true) == (doubleWidgetStatesController != null) && (statesColorMaker == null),
            'When syncStyleWithTextField is true, doubleWidgetStatesController and colorMaker must be provided');
*/
  TextFieldButtonConfig fillFrom(TextFieldButtonConfig? other) {
    return TextFieldButtonConfig(
      iconData: other?.iconData ?? iconData,
      buttonPosition: other?.buttonPosition ?? buttonPosition,
      tooltipMaker: tooltipMaker,
      style: other?.style ?? style,
      distanceFromTextField: other?.distanceFromTextField ?? distanceFromTextField,
      syncStyleWithTextField: other?.syncStyleWithTextField ?? syncStyleWithTextField,
      // doubleWidgetStatesController: other?.doubleWidgetStatesController ?? doubleWidgetStatesController,
      // statesColorMaker: other?.statesColorMaker ?? statesColorMaker,
      autofocus: other?.autofocus ?? autofocus,
    );
  }

  TextFieldButtonConfig copyWith({
    IconData? iconData,
    ButtonPosition? buttonPosition,
    String Function(BuildContext)? tooltipMaker,
    ButtonStyle? style,
    double? distanceFromTextField,
    bool? syncStyleWithTextField,
    DoubleWidgetStatesController? widgetStatesController,
    StatesColorMaker? colorMaker,
    bool? autofocus,
  }) {
    return TextFieldButtonConfig(
      iconData: iconData ?? this.iconData,
      buttonPosition: buttonPosition ?? this.buttonPosition,
      tooltipMaker: tooltipMaker ?? this.tooltipMaker,
      style: style ?? this.style,
      distanceFromTextField: distanceFromTextField ?? this.distanceFromTextField,
      syncStyleWithTextField: syncStyleWithTextField ?? this.syncStyleWithTextField,
      // doubleWidgetStatesController: widgetStatesController ?? this.doubleWidgetStatesController,
      // statesColorMaker: colorMaker ?? this.statesColorMaker,
      autofocus: autofocus ?? this.autofocus,
    );
  }
}
