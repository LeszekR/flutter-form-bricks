import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../forms/form_manager/form_manager.dart';
import '../../base/double_widget_states_controller.dart';
import '../../base/error_message_notifier.dart';

class TextFieldColored extends StatefulWidget {
  final String keyString;
  final FormManager formManager;
  final AutovalidateMode autovalidateMode;
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
  final List<String>? linkedFields;
  final TextInputType? keyboardType;
  final ValueTransformer? valueTransformer;
  final ValueChanged<String?>? onChanged;
  final dynamic onEditingComplete;
  final DoubleWidgetStatesController? notifierDoubleStatesController;
  final ValueChanged<String?>? onSubmitted;
  final TextInputAction? textInputAction;

  const TextFieldColored(this.keyString,
      {super.key,
      required this.formManager,
      required this.autovalidateMode,
      this.textWidth,
      this.maxLines,
      this.inputHeightMultiplier,
      this.expands = true,
      this.validator,
      this.inputFormatters,
      this.initialValue,
      this.readonly = false,
      this.obscureText = false,
      this.linkedFields,
      this.keyboardType,
      this.valueTransformer,
      this.withTextEditingController,
      this.onChanged,
      this.onEditingComplete,
      this.notifierDoubleStatesController,
      this.onSubmitted,
      this.textInputAction});

  @override
  State<StatefulWidget> createState() => _TextFieldColoredState();
}

class _TextFieldColoredState extends State<TextFieldColored> with ErrorMessageNotifier {
  dynamic firstValue;

  @override
  void initState() {
    super.initState();

    super.setErrorMessageListener(widget.formManager, widget.keyString);

    if (widget.withTextEditingController ?? true) {
      var controllerValue = widget.initialValue;
      if (controllerValue != null) controllerValue = controllerValue.toString();
      widget.formManager.setEditingController(widget.keyString, controllerValue);
    } else {
      firstValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    // STATE AWARE - color depends on state
    // ======================================================
    if (widget.notifierDoubleStatesController != null) {
      return ValueListenableBuilder(
          valueListenable: widget.notifierDoubleStatesController!,
          builder: (context, states, _) {
            return SizedBox(
                width: widget.textWidth,
                child: FormBuilderTextField(
                  key: Key(widget.keyString),
                  name: widget.keyString,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: AppColor.makeColor(states),
                  ),
                  statesController: widget.notifierDoubleStatesController!.receiverStatesController,
                  autovalidateMode: widget.autovalidateMode,
                  validator: widget.validator,
                  controller: widget.formManager.getTextEditingController(widget.keyString),
                  focusNode: widget.formManager.getFocusNode(widget.keyString),
                  initialValue: firstValue,
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
                ));
          });
    }

    // STATE IRRELEVANT - color controlled BY AppStyle.theme
    // ======================================================
    return SizedBox(
        width: widget.textWidth,
        child: FormBuilderTextField(
          key: Key(widget.keyString),
          name: widget.keyString,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          autovalidateMode: AutovalidateMode.always,
          validator: widget.validator,
          controller: widget.formManager.getTextEditingController(widget.keyString),
          focusNode: widget.formManager.getFocusNode(widget.keyString),
          initialValue: firstValue,
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
        ));
  }

  var _skipOnChanged = false;

  void _onChanged(value) {
    // stop infinite call here at changing the field value to trimmed one
    if (_skipOnChanged) return;

    widget.onChanged?.call(value?.trim());

    // we need formManager to validate and show error when onEditingComplete will NOT be called
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
