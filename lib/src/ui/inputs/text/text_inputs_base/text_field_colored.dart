import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_desktop_bricks/src/ui/inputs/text/text_inputs_base/widget_color.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../forms/form_manager/form_manager.dart';
import '../../states_controller/error_message_notifier.dart';

class TextFieldColored extends StatefulWidget {
  final WidgetColor widgetColor;
  final String keyString;
  final FormManager formManager;
  final AutovalidateMode autoValidateMode;
  final double? textWidth;
  final int? maxLines;
  final int? inputHeightMultiplier;
  final bool expands;
  final bool? withTextEditingController;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final dynamic initialValue;
  final bool readonly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueTransformer? valueTransformer;
  final ValueChanged<String?>? onChanged;
  final dynamic onEditingComplete;
  final ValueChanged<String?>? onSubmitted;
  final TextInputAction? textInputAction;
  final WidgetStatesController? receiverStatesController;
  final WidgetStatesController? notifierStatesController;

  TextFieldColored(
    this.keyString, {
    super.key,
    required this.widgetColor,
    required this.formManager,
    required this.autoValidateMode,
    this.textWidth,
    this.maxLines,
    this.inputHeightMultiplier,
    this.expands = true,
    this.validator,
    this.inputFormatters,
    this.initialValue,
    this.readonly = false,
    this.obscureText = false,
    this.keyboardType,
    this.valueTransformer,
    this.withTextEditingController,
    this.receiverStatesController,
    this.notifierStatesController,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.textInputAction,
  });

  @override
  State<StatefulWidget> createState() => _TextFieldColoredState();
}

class _TextFieldColoredState extends State<TextFieldColored> with ErrorMessageNotifier {
  dynamic initialValue;
  Set<WidgetState>? _states;

  @override
  void initState() {
    super.initState();

    super.setErrorMessageListener(widget.formManager, widget.keyString);

    _setStates(widget.notifierStatesController);
    widget.receiverStatesController?.addListener(_onStatesChanged);

    if (widget.withTextEditingController ?? true) {
      var controllerValue = widget.initialValue;
      if (controllerValue != null) controllerValue = controllerValue.toString();
      widget.formManager.setEditingController(widget.keyString, controllerValue);
    } else {
      initialValue = widget.initialValue;
    }
  }

  @override
  void dispose() {
    widget.receiverStatesController?.removeListener(_onStatesChanged);
    super.dispose();
  }

  void _onStatesChanged() {
    setState(() {
      _setStates(widget.notifierStatesController);
    });
  }

  void _setStates(WidgetStatesController? statesNotifier) {
    _states = statesNotifier?.value;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.textWidth,
      child: FormBuilderTextField(
        key: Key(widget.keyString),
        name: widget.keyString,
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: _states == null ? null : widget.widgetColor.makeColor(_states!),
        ),
        statesController: widget.receiverStatesController,
        validator: widget.validator,
        autovalidateMode: widget.autoValidateMode,
        controller: widget.formManager.getTextEditingController(widget.keyString),
        focusNode: widget.formManager.getFocusNode(widget.keyString),
        initialValue: initialValue,
        readOnly: widget.readonly,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        textAlignVertical: TextAlignVertical.top,
        valueTransformer: widget.valueTransformer,
        expands: widget.expands,
        onChanged: _onChanged,
        onEditingComplete: _onEditingComplete,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }

  var _skipOnChanged = false;

  void _onChanged(value) {
    // stop infinite call here at changing the field value to trimmed one
    if (_skipOnChanged) return;

    widget.onChanged?.call(value?.trim());

    // we need formManager to validate and show error when onEditingComplete will NEVER be called
    // if onEditingComplete is called then formManager.onFieldChanged is called there so we skip it here
    if (widget.onEditingComplete == null || widget.onEditingComplete == () {}) {
      _skipOnChanged = true;
      widget.formManager.onFieldChanged(widget.keyString, value);
      _skipOnChanged = false;
    }
  }

  void _onEditingComplete() {
    _skipOnChanged = true;
    var value = widget.onEditingComplete?.call();
    _skipOnChanged = false;
    widget.formManager.onFieldChanged(widget.keyString, value);
  }
}
