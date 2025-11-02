import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/inputs/text/text_input_base/states_color_maker.dart';

abstract class FormFieldBrick<T> extends StatefulWidget {
  final String keyString;
  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final WidgetStatesController? statesObserver;
  final WidgetStatesController? statesNotifier;
  final T? initialValue;
  final FormatterValidatorChain? formatterValidatorChain;

  // TODO implement identical functionality as in flutter_form_builder using onChange, onEditingComplete, onSave
  final AutovalidateMode autoValidateMode;

  T getValue();

  FormFieldBrick({
    // TODO refactor to obligatory use of KeyString class guaranteeing key uniqueness
    super.key,
    required this.keyString,
    required this.formManager,
    required this.colorMaker,
    this.statesObserver,
    this.statesNotifier,
    this.autoValidateMode = AutovalidateMode.disabled,
  })  : initialValue = formManager.getInitialValue(keyString),
        formatterValidatorChain = formManager.getFormatterValidatorChain(keyString) {
    formManager.registerField(keyString, T.runtimeType);
  }
}

abstract class FormFieldStateBrick<T extends FormFieldBrick> extends State<T> {
  // TODO implement onChange common to all inputs
  FormManager get formManager => widget.formManager;

  String get keyString => widget.keyString;
}
