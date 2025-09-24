import 'package:flutter/cupertino.dart';

import '../../../../shelf.dart';

abstract class FormFieldBrick extends StatefulWidget {
  final String keyString;
  final FormManager formManager;
  final StatesColorMaker colorMaker;
  final WidgetStatesController? statesObserver;
  final WidgetStatesController? statesNotifier;

  // TODO implement identical functionality as in flutter_form_builder using onChange, onEditingComplete, onSave
  final AutovalidateMode autoValidateMode;

  FormFieldBrick({
    // TODO refactor to obligatory use of KeyString class guaranteeing key uniqueness
    super.key,
    required this.keyString,
    required this.formManager,
    required this.colorMaker,
    this.statesObserver,
    this.statesNotifier,
    this.autoValidateMode = AutovalidateMode.disabled,
  });
}

abstract class FormFieldBrickState<T extends FormFieldBrick> extends State<T> {
  // TODO implement onChange common to all inputs
}
