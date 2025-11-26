import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_brick.dart';

class TestFormFieldBrick extends FormFieldBrick<String> {
  TestFormFieldBrick({
    super.key,
    required super.keyString,
    required super.formManager,
    required super.colorMaker,
  });

  @override
  State<FormFieldBrick<String>> createState() => TestFormFieldBrickState();
}

class TestFormFieldBrickState extends FormFieldStateBrick<TestFormFieldBrick, String?> {
  String? value;

  void changeValue(String newValue) {
    value = newValue;
    onFieldChanged(newValue, );
  }

  @override
  String? getValue() => value;

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(
      key: GlobalKey<TestFormFieldBrickState>(debugLabel: widget.keyString),
    );
  }
}
