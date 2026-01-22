import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/timestamp_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/text_field_brick.dart';

class TestPlainTextFieldDescriptor extends FormFieldDescriptor<TextEditingValue, String, TestPlainTextFieldBrick> {
  TestPlainTextFieldDescriptor({
    required super.keyString,
    super.initialInput,
    super.isFocusedOnStart,
    super.isRequired,
    super.runValidatorsFullRun,
    super.defaultFormatterValidatorsMaker,
  });
}

class TestPlainTextFieldBrick extends TextFieldBrick<String> {
  TestPlainTextFieldBrick({
    super.key,
    required super.keyString,
    required super.formManager,
    super.colorMaker,
  });

  @override
  TestFormFieldBrickState createState() => TestFormFieldBrickState();
}

class TestFormFieldBrickState extends TextFieldStateBrick {
  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(
      key: GlobalKey<TestFormFieldBrickState>(debugLabel: widget.keyString),
    );
  }
}
