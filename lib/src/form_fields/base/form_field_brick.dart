import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/states_color_maker.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

abstract class FormFieldBrick<I extends Object, V extends Object> extends StatefulWidget {
  final String keyString;

  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final WidgetStatesController? statesObserver;
  final WidgetStatesController? statesNotifier;
  final ValueChanged<I>? onChanged;

  // TODO implement identical functionality as in flutter_form_builder using onChange, onEditingComplete, onSave
  final ValidateModeBrick validateMode;

  FormFieldBrick({
    Key? key,
    required this.keyString,
    // TODO add field label, required if has validator so FormManager shows error for named field
    required this.formManager,
    required this.validateMode,
    StatesColorMaker? colorMaker,
    this.statesObserver,
    this.statesNotifier,
    this.onChanged,
  })  : this.colorMaker = colorMaker ?? StatesColorMaker(),
        super(key: key ?? ValueKey(keyString));
}

abstract class FormFieldStateBrick<I extends Object, V extends Object, F extends FormFieldBrick<I, V>>
    extends State<F> {
  Set<WidgetState>? _states;

  /// Value of the field saved in `FieldData` and used on form save when the field has no
  /// `FormatterValidator` (which otherwise provides formatted value).
  V? get defaultValue;

  /// Object holding state of this `FormFieldBrick`. Fetched from `FormManager` prior to `build()`
  /// and updated in `setState()`;
  late I? _input;

  /// Controls the field's color and is passed to `InputDecoration` it the field shows its error this way.
  String? _error;

  late final FocusNode focusNode;

  FormManager get formManager => widget.formManager;

  String get keyString => widget.keyString;

  @mustCallSuper
  @override
  void initState() {
    formManager.registerField<F>(keyString, _hasFormatterValidator());

    focusNode = FocusNode();
    formManager.setFocusListener(focusNode, keyString);

    _input = formManager.getFieldContent(keyString).input as I?;
    // _input = formManager.getFieldContent<I, V>(keyString).input;

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
  ///   dedicated `FormBrick` area by `FormManager`).
  @mustCallSuper
  I? onInputChanged(I? input, V? defaultValue) {
    // Here FormManager:
    // - validates the input
    // - saves results of format-validation in FormData -> FormFieldData -> FieldContent
    return formManager.onFieldChanged<I, V>(BricksLocalizations.of(context), keyString, input, defaultValue).input;
  }

  bool _hasFormatterValidator() => widget.validateMode != ValidateModeBrick.noValidator;

  Color? makeColor() => widget.colorMaker.makeColor(context, _states);
}
