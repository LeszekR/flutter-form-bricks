import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/form_fields/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/text_field_brick.dart';

class TestTextFieldDescriptor extends FormFieldDescriptor<TextEditingValue, String, TestTextField> {
  TestTextFieldDescriptor({
    required super.keyString,
    super.initialInput,
    super.isRequired,
    super.runValidatorsFullRun,
    super.additionalFormatterValidatorsMaker,
  });
}

class TestTextField extends TextFieldBrick<String> {
  TestTextField({
    super.key,
    required super.keyString,
    required super.formManager,
    super.colorMaker,
    super.statesObserver,
    super.statesNotifier,
    super.controller,
  }) : super(validateMode: ValidateModeBrick.onChange);

  @override
  TestTextFieldState createState() => TestTextFieldState();
}

class TestTextFieldState extends TextFieldStateBrick<String, TestTextField> {
  TextEditingValue get text => controller.value;

  @override
  String? get defaultValue => controller.text;
}
