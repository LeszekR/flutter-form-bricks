import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_input_base/formatter_validator_defaults.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_input_base/states_color_maker.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

abstract class FormFieldBrick<I extends Object, V extends Object> extends StatefulWidget {
  final String keyString;

  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final I? initialInput;
  final bool isFocusedOnStart;
  final bool isRequired;
  final FormatterValidatorListMaker? defaultFormatterValidatorListMaker;
  final FormatterValidatorListMaker? addFormatterValidatorListMaker;

  // final FormatterValidatorChainDescriptor? formatterValidatorChainDescriptor;
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
    this.isFocusedOnStart = false,
    this.isRequired = false,
    this.defaultFormatterValidatorListMaker = null,
    this.addFormatterValidatorListMaker = null,
    // this.formatterValidatorChainDescriptor = null,
    this.statesObserver,
    this.statesNotifier,
    this.autoValidateMode = AutovalidateMode.disabled,
  }) : super(key: key ?? ValueKey(keyString));
}

abstract class FormFieldStateBrick<I extends Object, V extends Object, F extends FormFieldBrick<I, V>>
    extends State<F> {
  Set<WidgetState>? _states;

  /// Object holding state of this `FormFieldBrick`. Fetched from `FormManager` prior to `build()`
  /// and updated in `setState()`;
  late FieldContent _fieldContent;

  late final FocusNode focusNode;

  FormManager get formManager => widget.formManager;

  String get keyString => widget.keyString;

  /// Controls the field's color and is passed to `InputDecoration` it the field shows its error this way.
  String? _error;

  @mustCallSuper
  @override
  void initState() {
    formManager.registerField<I, V>(keyString, _hasFormatterValidator());

    focusNode = FocusNode();
    formManager.setFocusListener(focusNode, keyString);

    _fieldContent = formManager.getFieldContent(keyString);

    _states = widget.statesNotifier?.value;
    widget.statesNotifier?.addListener(_onStatesChanged);

    if (formManager.isFocusedOnStart(keyString)) focusNode.requestFocus();

    super.initState();
  }

  @mustCallSuper
  @override
  void dispose() {
    widget.statesNotifier?.removeListener(_onStatesChanged);
    focusNode.dispose();
    super.dispose();
  }

  void _onStatesChanged() {
    setState(() {
      _states = widget.statesNotifier?.value;
    });
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
  void onFieldChanged(BricksLocalizations localizations, I input) {
    // Here FormManager:
    // - validates the input
    // - saves results of format-validation in FormData -> FormFieldData -> FieldContent
    FieldContent fieldContent = formManager.onFieldChanged(localizations, keyString, input);
    setState(() {
      _fieldContent = fieldContent;
    });
  }

  bool _hasFormatterValidator() =>
      widget.defaultFormatterValidatorListMaker != null || widget.addFormatterValidatorListMaker != null;

  // bool _hasFormatterValidator() => widget.formatterValidatorChainDescriptor != null;

  Color? makeColor() => widget.colorMaker.makeColor(context, _states);
}
