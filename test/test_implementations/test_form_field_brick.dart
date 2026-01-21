import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/states_color_maker.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/text_field_brick.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

class TestPlainTextFormFieldBrick extends TextFieldBrick {
  TestPlainTextFormFieldBrick({
    super.key,
    required super.keyString,
    required super.formManager,
    super.colorMaker,
    super.initialInput,
    super.isFocusedOnStart,
    super.defaultFormatterValidatorListMaker,
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
