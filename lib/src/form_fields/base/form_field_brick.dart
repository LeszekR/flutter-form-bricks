import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_input_base/states_color_maker.dart';

import '../../string_literals/gen/bricks_localizations.dart';

abstract class FormFieldBrick<I extends Object> extends StatefulWidget {
  final String keyString;
  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final I? initialInput;
  final bool isFocusedOnInit;
  final FormatterValidatorChain? formatterValidatorChain;
  final WidgetStatesController? statesObserver;
  final WidgetStatesController? statesNotifier;

  // TODO implement identical functionality as in flutter_form_builder using onChange, onEditingComplete, onSave
  final AutovalidateMode autoValidateMode;

  FormFieldBrick({
    Key? key,
    required this.keyString,
    required this.formManager,
    required this.colorMaker,
    this.initialInput,
    this.isFocusedOnInit = false,
    this.formatterValidatorChain = null,
    this.statesObserver,
    this.statesNotifier,
    this.autoValidateMode = AutovalidateMode.disabled,
  }) : super(key: key ?? ValueKey(keyString));
}

abstract class FormFieldStateBrick<I extends Object, V extends Object, F extends FormFieldBrick> extends State<F> {
  V getValue();

  /// Object holding state of this `FormFieldBrick`. Fetched from `FormManager` prior to `build()`
  /// and updated in `setState()`;
  late FieldContent _fieldContent;

  late final FocusNode focusNode;

  FormManager get formManager => widget.formManager;

  String get keyString => widget.keyString;

  /// Controls the field's color and is passed to `InputDecoration` it the field shows its error this way.
  String? _error;

  @override
  void initState() {
    formManager.registerField<I, V>(keyString, _hasFormatterValidator());

    if (_hasFormatterValidator()) {
      focusNode = FocusNode();
      formManager.setFocusListener(focusNode, keyString);
    }
    _fieldContent = formManager.getFieldContent(keyString);
    super.initState();
  }

  @override
  void dispose() {
    if (_hasFormatterValidator()) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// **Must be called** either in `onChanged` or `onEditingComplete`. If not called there neither of the below
  /// functions will be performed.
  /// ---
  /// Makes `FormManager`:
  /// - format the input
  /// - validate the input
  /// - register both new value and error in `FormManager` -> `FormStateBrick` -> `FieldContent`
  /// - return new `FieldContent` which then sets the field's input (if formatted), controls its color,
  ///   displays error if the field uses `InputDecoration` for this (error alternatively it can be displayed in
  ///   dedicated `FormBrick` area by `FormManager`.
  void onFieldChanged(BricksLocalizations localizations, V input) {
    // Here FormManager:
    // - validates the input
    // - saves results of format-validation in FormData -> FormFieldData -> FieldContent
    FieldContent fieldContent = formManager.onFieldChanged(localizations, keyString, input);
    setState(() {
      _fieldContent = fieldContent;
    });
  }
  
  bool _hasFormatterValidator() => widget.formatterValidatorChain != null;
}
