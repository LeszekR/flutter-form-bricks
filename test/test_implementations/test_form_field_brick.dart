import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_brick.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

class TestFormFieldBrick extends FormFieldBrick<String, String> {
  TestFormFieldBrick({
    super.key,
    required super.keyString,
    required super.formManager,
    required super.colorMaker,
  });

  @override
  TestFormFieldBrickState createState() => TestFormFieldBrickState();
}

class TestFormFieldBrickState extends FormFieldStateBrick<String, String, TestFormFieldBrick> {
  String value = '';

  void changeValue(BricksLocalizations localizations, String newValue) {
    value = newValue;
    onFieldChanged(localizations, newValue, );
  }

  @override
  String getValue() => value;

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(
      key: GlobalKey<TestFormFieldBrickState>(debugLabel: widget.keyString),
    );
  }
}
