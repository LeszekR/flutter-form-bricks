import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_input_base/text_field_brick.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

class TestPlainTextFormFieldBrick extends TextFieldBrick {
  TestPlainTextFormFieldBrick({
    super.key,
    required super.keyString,
    required super.formManager,
    required super.colorMaker,
    super.initialInput,
    super.isFocusedOnStart,
    super.formatterValidatorChainBuilder,
  });

  @override
  TestFormFieldBrickState createState() => TestFormFieldBrickState();
}

class TestFormFieldBrickState extends TextFieldStateBrick {
  TextEditingValue value = TextEditingValue(text: '');

  void changeValue(BricksLocalizations localizations, String newInput) {
    value = TextEditingValue(text: newInput);
    onFieldChanged(localizations, newInput, );
  }

  @override
  TextEditingValue getValue() => value;

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(
      key: GlobalKey<TestFormFieldBrickState>(debugLabel: widget.keyString),
    );
  }
}
