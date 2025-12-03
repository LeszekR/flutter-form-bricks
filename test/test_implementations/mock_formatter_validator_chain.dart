import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

import 'mock_formatter_validator.dart';

/// Mocked [FormatterValidatorChain] that returns a fixed validation result.
/// For use in all value-change tests to simulate both valid and invalid responses.
class MockFormatterValidatorChain extends FormatterValidatorChain<String, TextEditingValue> {
  final String? mockError;

  /// This is a mock necessary for the constructor. It will NOT run since this [MockFormatterValidator]
  /// really is only a placeholder while this [MockFormatterValidatorChain] is the actual mock which returns
  /// [FieldContent] build with the passed `mockError`.
  MockTextFormatterValidator mockFormatterValidator = MockTextFormatterValidator(null);

  MockFormatterValidatorChain([this.mockError]) : super([MockTextFormatterValidator(mockError)]);

  @override
  FieldContent<String, TextEditingValue> runChain(BricksLocalizations localizations, String keyString,
      String? inputValue) {
    return TextFieldContent.of('ala', TextEditingValue(text: 'ala'), mockError == null ? true : false, mockError);
  }
}
