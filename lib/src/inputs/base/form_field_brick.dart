import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/inputs/text/text_input_base/states_color_maker.dart';

abstract class FormFieldBrick<T> extends StatefulWidget {
  final String keyString;
  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final WidgetStatesController? statesObserver;
  final WidgetStatesController? statesNotifier;
  final T? initialValue;

  // TODO implement identical functionality as in flutter_form_builder using onChange, onEditingComplete, onSave
  final AutovalidateMode autoValidateMode;

  T getValue();

  FormFieldBrick({
    super.key,
    required this.keyString,
    required this.formManager,
    required this.colorMaker,
    this.statesObserver,
    this.statesNotifier,
    this.autoValidateMode = AutovalidateMode.disabled,
  }) : initialValue = formManager.getInitialValue(keyString) {
    formManager.registerField(keyString, T.runtimeType);
  }
}

abstract class FormFieldStateBrick<T extends FormFieldBrick> extends State<T> {
  FormManager get formManager => widget.formManager;

  String get keyString => widget.keyString;

  /// Controls the field's color and is passed to `InputDecoration` it the field shows its error this way.
  String? _error;

  /// **Must be called** either in `onChanged` or `onEditingComplete`. If not called there neither validation nor error
  /// display will be performed.
  /// ---
  /// Makes `FormManager`
  /// - validate the field
  /// - register both new value and error in `FormManager` -> `FormStateBrick` -> `FormFieldStateBrick`
  /// - return error which then controls the field's color and if the field uses `InputDecoration` to display error it
  ///   is passed there.
  void _onFieldChanged(dynamic value) {
    setState(() {
      _error = formManager.onFieldChanged(keyString, value);
    });
  }
}
