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
  TestTextFieldBrickState createState() => TestTextFieldBrickState();

}

class TestTextFieldBrickState extends TextfieldContentBrick {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
