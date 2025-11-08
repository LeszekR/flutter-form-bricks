import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/input_value_error.dart';
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

  FormFieldBrick({
    Key? key,
    required this.keyString,
    required this.formManager,
    required this.colorMaker,
    this.statesObserver,
    this.statesNotifier,
    this.autoValidateMode = AutovalidateMode.disabled,
  })  : initialValue = formManager.getInitialValue(keyString),
        super(key: key ?? ValueKey(keyString)) {
    formManager.registerField(keyString, T);
  }
}

abstract class FormFieldStateBrick<K extends FormFieldBrick, T> extends State<K> {
  T getValue();



  late final FocusNode focusNode;

  FormManager get formManager => widget.formManager;

  String get keyString => widget.keyString;

  /// Controls the field's color and is passed to `InputDecoration` it the field shows its error this way.
  String? _error;

  @override
  void initState() {
    focusNode = FocusNode();
    formManager.setFocusListener(focusNode, keyString);
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  /// **Must be called** either in `onChanged` or `onEditingComplete`. If not called there neither validation nor error
  /// display will be performed.
  /// ---
  /// Makes `FormManager`
  /// - validate the field
  /// - register both new value and error in `FormManager` -> `FormStateBrick` -> `FormFieldStateBrick`
  /// - return error which then controls the field's color and if the field uses `InputDecoration` to display error it
  ///   is passed there.
  void onFieldChanged(dynamic value) {
    InputValueError valueAndError = formManager.getFormatterValidatorChain(keyString)!.run(value);
    formManager.onFieldChanged(keyString, valueAndError);
    setState(() {});
  }
}
