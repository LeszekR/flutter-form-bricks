import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/string_extension.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

/// Mocked [FormatterValidator] that returns a fixed validation result.
/// For use in all value-change tests to simulate both valid and invalid responses.
class MockTextFormatterValidator extends FormatterValidator<TextEditingValue, String> {
  final TextEditingValue? returnInputTEV;
  final String? mockError;

  MockTextFormatterValidator({this.returnInputTEV, this.mockError});

  @override
  FieldContent<TextEditingValue, String> run(
    BricksLocalizations localizations,
    String keyString,
    FieldContent<TextEditingValue, String> fieldContent,
  ) {
    bool isValid = mockError == null ? true : false;
    return FieldContent.of(returnInputTEV, returnInputTEV?.text, isValid, mockError);
  }
}
