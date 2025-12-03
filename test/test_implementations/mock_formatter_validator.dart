import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/formatter_validators/formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

/// Mocked [FormatterValidator] that returns a fixed validation result.
/// For use in all value-change tests to simulate both valid and invalid responses.
class MockTextFormatterValidator extends FormatterValidator<String, TextEditingValue> {
  final String? mockError;

  MockTextFormatterValidator(this.mockError);

  @override
  FieldContent<String, TextEditingValue> run(
    BricksLocalizations localizations,
    String keyString,
    FieldContent<String, TextEditingValue> fieldContent,
  ) {
    bool isValid = mockError == null ? true : false;
    return FieldContent.of('ala', TextEditingValue(text: 'ala'), isValid, mockError);
  }
}
