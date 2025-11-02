import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/inputs/base/form_field_brick.dart';

class TestTextFormFieldBrick extends FormFieldBrick<String> {
  TestTextFormFieldBrick({
    required super.keyString,
    required super.formManager,
    required super.colorMaker,
  });

  @override
  State<FormFieldBrick<String>> createState() => TestFormFieldBrickState();

  @override
  String getValue() {
    // TODO: implement getValue
    throw UnimplementedError();
  }
}

class TestFormFieldBrickState extends State<TestTextFormFieldBrick> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
