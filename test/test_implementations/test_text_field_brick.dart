import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_input_base/text_field_brick.dart';

class TestTextFieldBrick extends TextFieldBrick {
  TestTextFieldBrick({
    super.controller,
    required super.keyString,
    required super.formManager,
    StatesColorMaker? colorMaker,
  });

  @override
  TestTextFieldBrickState createState() => TestTextFieldBrickState();

}

class TestTextFieldBrickState extends TextFieldStateBrick {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
