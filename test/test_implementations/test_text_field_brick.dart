import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/inputs/state/text_editing_value_brick.dart';
import 'package:flutter_form_bricks/src/inputs/text/text_input_base/text_field_brick.dart';

class TestTextFieldBrick extends TextFieldBrick {
  TestTextFieldBrick({
    super.controller,
    required super.keyString,
    required super.formManager,
    required super.colorMaker,
  });

  @override
  TextFieldStateBrick createState() => TestTextFieldBrickState();

  @override
  TextEditingValue getValue() {
    // TODO: implement getValue
    throw UnimplementedError();
  }
}

class TestTextFieldBrickState extends TextFieldStateBrick {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
