import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_desktop_bricks/src/ui/inputs/states_controller/double_widget_states_controller.dart';
import 'package:flutter_desktop_bricks/src/ui/inputs/states_controller/update_once_widget_states_controller.dart';
import 'package:flutter_desktop_bricks/src/ui/inputs/text/text_inputs_base/state_aware_icon_button.dart';
import 'package:flutter_desktop_bricks/src/ui/inputs/text/text_inputs_base/state_aware_text_field.dart';
import 'package:flutter_desktop_bricks/src/ui/inputs/text/text_inputs_base/states_color_maker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../forms/form_manager/form_manager.dart';
import '../../../visual_params/app_size.dart';

class TextFieldColored extends StatelessWidget {
  final String keyString;
  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final double? width;
  final double? height;
  final int? maxLines;
  final AutovalidateMode autoValidateMode;
  final int? inputHeightMultiplier;
  final dynamic initialValue;
  final bool expands;
  final bool readonly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool? withTextEditingController;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final ValueTransformer? valueTransformer;
  final ValueChanged<String?>? onChanged;
  final dynamic onEditingComplete;
  final ValueChanged<String?>? onSubmitted;
  final TextInputAction? textInputAction;
  final IconButtonParams? buttonParams;

  TextFieldColored({
    super.key,
    required this.keyString,
    required this.formManager,
    required this.colorMaker,
    this.width,
    this.height,
    this.maxLines,
    required this.autoValidateMode,
    this.inputHeightMultiplier,
    this.initialValue,
    this.expands = true,
    this.readonly = false,
    this.obscureText = false,
    this.keyboardType,
    this.withTextEditingController,
    this.validator,
    this.inputFormatters,
    this.valueTransformer,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.textInputAction,
    this.buttonParams,
  });

  @override
  Widget build(BuildContext context) {
    var statesObserver;
    var statesNotifier;

    if (buttonParams == null) {
      var statesController = WidgetStatesController();
      statesObserver = statesController;
      statesNotifier = statesController;
    } else {
      var statesController = DoubleWidgetStatesController();
      statesObserver = statesController.lateWidgetStatesController;
      statesNotifier = statesController.receiverStatesController;
    }

    var containerWidth = width ?? AppSize.inputTextWidth;
    var textWidth = (width ?? AppSize.inputTextWidth - (buttonParams == null ? 0 : AppSize.inputTextHeight));

    return Container(
      width: containerWidth,
      height: height ?? AppSize.inputTextHeight,
      child: ValueListenableBuilder(
        valueListenable: statesNotifier,
        builder: (__, states, _) {
          if (buttonParams == null) {
            return _makeTextField(statesObserver, statesNotifier, textWidth);
          } else {
            return _makeTextFieldWithButton(statesObserver, statesNotifier, textWidth);
          }
        },
      ),
    );
  }

  Widget _makeTextFieldWithButton(
    UpdateOnceWidgetStatesController statesObserver,
    WidgetStatesController statesNotifier,
    double textWidth,
  ) {
    return Row(children: [
      _makeTextField(statesObserver, statesNotifier, textWidth),
      _makeButton(statesObserver, statesNotifier),
    ]);
  }

  StateAwareTextField _makeTextField(
    WidgetStatesController statesObserver,
    WidgetStatesController statesNotifier,
    double textWidth,
  ) {
    return StateAwareTextField(
      keyString: keyString,
      formManager: formManager,
      statesObserver: statesObserver,
      statesNotifier: statesNotifier,
      colorMaker: colorMaker,
      textWidth: textWidth,
      maxLines: maxLines,
      expands: expands,
      inputHeightMultiplier: inputHeightMultiplier,
      autoValidateMode: autoValidateMode,
      readonly: readonly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      initialValue: initialValue,
      withTextEditingController: withTextEditingController,
      validator: validator,
      inputFormatters: inputFormatters,
      valueTransformer: valueTransformer,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
    );
  }

  StateAwareIconButton _makeButton(
      UpdateOnceWidgetStatesController statesObserver, WidgetStatesController statesNotifier) {
    return StateAwareIconButton(
      statesObserver: statesObserver,
      statesNotifier: statesNotifier,
      colorMaker: colorMaker,
      iconData: buttonParams!.iconData,
      onPressed: buttonParams!.onPressed,
      autofocus: buttonParams!.autofocus,
      tooltip: buttonParams!.tooltip,
    );
  }
}

class IconButtonParams {
  final IconData iconData;
  final VoidCallback onPressed;
  final String? tooltip;
  final bool autofocus;

  const IconButtonParams(this.iconData, this.onPressed, this.tooltip, this.autofocus);
}
